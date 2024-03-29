/*
 * uart_count is used to indicate the sample point of the receiver and transmitter
 *      when they are working(not idle)
 * 'period' represents the number of clock cycles of a sample cycle
 * 'preset' means the value of 'count' starts as it for the first sample cycle
 *      but the second and subsequent start as 0. Thus,'preset' play a role in 
 *      lagging the sample point for a while, which will be helpful for the receiver
 * 'q' is the signal to indicate the sample point which will be SET(high level) 
 *      for only one clock cycle
 */
module UART (
    input clk,
    input reset,
    input rxd,
    input [31:0] WD,
    input [31:0] Addr,
    input [3:0] byteen,
    input load,
    input store,
    output [31:0] RD,
    output interrupt,
    output txd
);

    
    reg [31:0] tx_data;
    integer cnt;
	 wire [7:0] rx_data;
    wire [5:0] LSR;
    wire [15:0] DIVR;
    wire [15:0] DIVT;

    wire [15:0] period;

    wire rx_clear;
    wire tx_start;
    wire tx_avai;

    assign rx_clear = load & (Addr >= 32'h7f30 && Addr <= 32'h7f33);
    assign tx_start = (cnt > 0);
    assign LSR = {tx_avai,4'b0000,interrupt};
    assign period = 2604;
    assign DIVR = 2604;
    assign DIVT = 2604;
    assign RD = (Addr[3:2] == 2'b00) ? {rx_data,24'd0} :
                (Addr[3:2] == 2'b01) ? {26'd0,LSR} :
                (Addr[3:2] == 2'b10) ? {16'd0,DIVR} :
                (Addr[3:2] == 2'b11) ? {16'd0,DIVT} :
                32'd0;

    always @(posedge clk) begin
     if((byteen == 4'b1111)&&(Addr >= 32'h7f30 && Addr <= 32'h7f33)) begin
        tx_data <= WD;
        cnt <= 4;
     end
	 else if((byteen==4'b0001 || byteen==4'b0010 || byteen==4'b0100 || byteen==4'b1000)&&(Addr >= 32'h7f30 && Addr<=32'h7f33)) begin
	    tx_data <= WD;
        cnt <= 1;
	 end
     else if(tx_avai) begin
         tx_data <= tx_data<<8;
         if(cnt > 0)
         cnt <= cnt - 1;
     end
 end


uart_rx RX(
    //input
    .clk(clk),
    .rstn(~reset),
    .period(period),
    .rxd(rxd),
    .rx_clear(rx_clear),
    //output
    .rx_data(rx_data),
    .rx_ready(interrupt)
);

uart_tx TX(
    //input
    .clk(clk),
    .rstn(~reset),
    .period(period),
    .tx_start(tx_start),
    .tx_data(tx_data[31:24]),
    //output
    .txd(txd),
    .tx_avai(tx_avai)
);
    
endmodule


module uart_count (
    input wire clk,
    input wire rstn,
    input wire en,
    input wire [15:0] period,
    input wire [15:0] preset,   // preset value
    output wire q
);

    reg [15:0] count;

    always @(posedge clk) begin
        if (~rstn) begin
            count <= 0;
        end
        else begin
            if (en) begin
                if (count + 16'd1 == period) begin
                    count <= 16'd0;
                end
                else begin
                    count <= count + 16'd1;
                end
            end
            else begin
                count <= preset;
            end
        end
    end

    assign q = count + 16'd1 == period;

endmodule


module uart_tx (
    input wire clk,
    input wire rstn,
    input wire [15:0] period,
    input wire tx_start,        // 1 if outside wants to send data
    input wire [7:0] tx_data,   // data to be sent
    output wire txd,
    output wire tx_avai         // 1 if uart can send data
);
    localparam IDLE = 0, START = 1, WORK = 2, STOP = 3;

    reg [1:0] state;
    reg [7:0] data;         // a copy of 'tx_data', modified(right shift) at each sample point
    reg [2:0] bit_count;    // number of bits which is not sent

    wire count_en = state != IDLE;
    wire count_q;

    uart_count count (
        .clk(clk), .rstn(rstn), .period(period), .en(count_en), .q(count_q),
        .preset(16'b0) // no offset
    );

    // transmit
    always @(posedge clk) begin
        if (~rstn) begin
            state <= IDLE;
            data <= 0;
            bit_count <= 0;
        end
        else begin
            case (state)
                IDLE: begin
                    if (tx_start) begin
                        state <= START;
                        data <= tx_data;
                    end
                end
                START: begin
                    if (count_q) begin
                        state <= WORK;
                        bit_count <= 3'd7;
                    end
                end
                WORK: begin
                    if (count_q) begin
                        data <= {1'b0, data[7:1]}; // right shift
                        if (bit_count == 0) begin
                            state <= STOP;
                        end
                        else begin
                            bit_count <= bit_count - 3'd1;
                        end
                    end
                end
                STOP: begin
                    if (count_q) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    assign tx_avai = state == IDLE;
    assign txd = (state == IDLE || state == STOP) ? 1'b1 :
                 (state == START) ? 1'b0 : data[0];

endmodule

module uart_rx (
    input wire clk,
    input wire rstn,
    input wire [15:0] period,
    input wire rxd,
    input wire rx_clear,        // 1 if outside took or discarded the received data
    output reg [7:0] rx_data,   // data has been read
    output reg rx_ready         // 1 if 'uart_rx' has read complete data(a byte)
);
    localparam IDLE = 0, START = 1, WORK = 2, STOP = 3;

    wire count_en = state != IDLE;
    wire count_q;

    uart_count count (
        .clk(clk), .rstn(rstn), .period(period), .en(count_en), 
        .q(count_q), .preset(period >> 1) // half sample cycle offset
    );

    reg [1:0] state;
    reg [7:0] buffer;       // buffer for received bits
    reg [2:0] bit_count;    // number of bits which need to receive

    always @(posedge clk) begin
        if (~rstn) begin
            state <= 0;
            buffer <= 0;
            bit_count <= 0;
        end
        else begin
            case (state)
                IDLE: begin
                    if (~rxd) begin
                        state <= START;
                        buffer <= 0;
                    end
                end
                START: begin
                    if (count_q) begin
                        state <= WORK;
                        bit_count <= 3'd7;
                    end
                end
                WORK: begin
                    if (count_q) begin
                        if (bit_count == 0) begin
                            state <= STOP;
                        end
                        else begin
                            bit_count <= bit_count - 3'd1;
                        end
                        buffer <= {rxd, buffer[7:1]};   // take received bit
                    end
                end
                STOP: begin
                    if (count_q) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    always @(posedge clk) begin
        if (~rstn) begin
            rx_data <= 0;
            rx_ready <= 0;
        end
        else begin
            if (rx_clear) begin
                rx_data <= 0;
                rx_ready <= 0;
            end
            else if (state == STOP && count_q) begin    // complete receiving
                rx_data <= buffer;
                rx_ready <= 1;
            end
        end
    end


endmodule