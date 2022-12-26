module DigitalTube (
    //input
    input clk,
    input reset,
    input [31:0] Addr,
    input [3:0] DT_byteen,
    input [31:0] WD,
    //output
    output [31:0] RD,
    output reg [7:0] digital_tube0,
    output [3:0] digital_tube_sel0,
    output reg [7:0] digital_tube1,
    output [3:0] digital_tube_sel1,
    output [7:0] digital_tube2,
    output digital_tube_sel2
);
 
reg [3:0] digital_tube_sel0_reg,digital_tube_sel1_reg;
reg [7:0] tube0,tube1;
reg [1:0] pos;
reg [31:0] num,sign;
reg [31:0] counter;

always @(posedge clk ) begin
    if (reset) begin
        digital_tube_sel0_reg <= 4'b0000;
        digital_tube_sel1_reg <= 4'b0000;
        pos <= 2'b00;
        num <= 32'd0;
        sign <= 32'd0;
        counter <= 32'd0;
		  tube0 <= 32'd0;
		  tube1 <= 32'd0;
    end
    else begin
        if (|DT_byteen) begin
            case (Addr[2])
                1'b0: begin
                    if (DT_byteen[3]) num[31:24] <= WD[31:24];
                    if (DT_byteen[2]) num[23:16] <= WD[23:16];
                    if (DT_byteen[1]) num[15:8] <= WD[15:8];
                    if (DT_byteen[0]) num[7:0] <= WD[7:0];
                end 
                1'b1: begin
                    if (DT_byteen[3]) sign[31:24] <= WD[31:24];
                    if (DT_byteen[2]) sign[23:16] <= WD[23:16];
                    if (DT_byteen[1]) sign[15:8] <= WD[15:8];
                    if (DT_byteen[0]) sign[7:0] <= WD[7:0];
                end
                default: ;
            endcase
        end

        counter <= counter + 1;

        if (counter == 32'd500000) begin
            digital_tube_sel0_reg[pos - 2'b01] <= 1'b0;
            digital_tube_sel1_reg[pos - 2'b01] <= 1'b0;
            digital_tube_sel0_reg[pos] <= 1'b1;
            digital_tube_sel1_reg[pos] <= 1'b1;

            case (pos)
                2'b00:begin
                    tube0 <= num[3:0];
                    tube1 <= num[19:16];
                end 
                2'b01:begin
                    tube0 <= num[7:4];
                    tube1 <= num[23:20];
                end
                2'b10:begin
                    tube0 <= num[11:8];
                    tube1 <= num[27:24];
                end
                2'b11:begin
                    tube0 <= num[15:12];
                    tube1 <= num[31:28];
                end
                default: ;
            endcase

            counter <= 32'd0;
            pos <= pos + 2'b01;
        end
    end
end

always @(*) begin
    case (tube0)
      4'd0:  digital_tube0 = 8'b10000001;
		4'd1:  digital_tube0 = 8'b11001111;
		4'd2:  digital_tube0 = 8'b10010010;
		4'd3:  digital_tube0 = 8'b10000110;
		4'd4:  digital_tube0 = 8'b11001100;
		4'd5:  digital_tube0 = 8'b10100100;
		4'd6:  digital_tube0 = 8'b10100000;
		4'd7:  digital_tube0 = 8'b10001111;
		4'd8:  digital_tube0 = 8'b10000000;
		4'd9:  digital_tube0 = 8'b10000100;
		4'd10: digital_tube0 = 8'b10001000;
		4'd11: digital_tube0 = 8'b11100000;
		4'd12: digital_tube0 = 8'b10110001;
		4'd13: digital_tube0 = 8'b11000010;
		4'd14: digital_tube0 = 8'b10110000;
		4'd15: digital_tube0 = 8'b10111000;
		default: digital_tube0 = 8'b11111111;
    endcase   
    case (tube1)
      4'd0:  digital_tube1 = 8'b10000001;
		4'd1:  digital_tube1 = 8'b11001111;
		4'd2:  digital_tube1 = 8'b10010010;
		4'd3:  digital_tube1 = 8'b10000110;
		4'd4:  digital_tube1 = 8'b11001100;
		4'd5:  digital_tube1 = 8'b10100100;
		4'd6:  digital_tube1 = 8'b10100000;
		4'd7:  digital_tube1 = 8'b10001111;
		4'd8:  digital_tube1 = 8'b10000000;
		4'd9:  digital_tube1 = 8'b10000100;
		4'd10: digital_tube1 = 8'b10001000;
		4'd11: digital_tube1 = 8'b11100000;
		4'd12: digital_tube1 = 8'b10110001;
		4'd13: digital_tube1 = 8'b11000010;
		4'd14: digital_tube1 = 8'b10110000;
		4'd15: digital_tube1 = 8'b10111000;
		default: digital_tube1 = 8'b11111111;
    endcase
end

assign digital_tube_sel0 = digital_tube_sel0_reg;
assign digital_tube_sel1 = digital_tube_sel1_reg;
assign digital_tube_sel2 = 1'b1;
assign digital_tube2 = 8'b1111_1111;
assign RD = (Addr[2] == 1'b0) ? num : sign;
    
endmodule