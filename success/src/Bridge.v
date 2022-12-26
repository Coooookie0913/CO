module Bridge (
    //input
    input clk,
    input reset,
    input [31:0] A_in, //读写外设单元地址
    input [31:0] WD_in, //写入外设单元数据
    input [3:0] byteen, //写入外设单元使能
    input [31:0] DM_RD, //DM读取值输入
    input [31:0] T0_RD, //T0读取值输入
    input [31:0] UART_RD,//UART读取值输入
    input [31:0] DT_RD,//DigitalTube读取值输入
    input [31:0] Key_RD,//key读取值输入
    input [31:0] DipSwitch_RD,//DipSwitch读取值输入
    //output
	 output [31:0] RD_out,//从外设读取数据
    output [31:0] A_out, //读写外设单元地址
    output [31:0] WD_out, //写入外设单元数据
    output [3:0] DM_byteen, //DM写入使能
    output T0_WE, //T0写入使能
    output [3:0] UART_byteen,//UART写入使能
    output [3:0] DT_byteen,//DigitalTube写入使能
    output [3:0] LED_byteen//LED写入使能
);

reg [31:0] A_in_reg,T0_RD_reg,UART_RD_reg,DT_RD_reg,Key_RD_reg,DipSwitch_RD_reg;
always @(posedge clk ) begin
    if (reset) begin
        A_in_reg <= 32'd0;
        T0_RD_reg <= 32'd0;
        UART_RD_reg <= 32'd0;
        DT_RD_reg <= 32'd0;
        Key_RD_reg <= 32'd0;
        DipSwitch_RD_reg <= 32'd0;
    end 
    else begin
        A_in_reg <= A_in;
        T0_RD_reg <= T0_RD;
        UART_RD_reg <= UART_RD;
        DT_RD_reg <= DT_RD;
        Key_RD_reg <= Key_RD;
        DipSwitch_RD_reg <= DipSwitch_RD;
    end
end

assign A_out = A_in;
assign WD_out = WD_in;
assign DM_byteen = (A_in >= 32'h0000_0000 && A_in <= 32'h0000_2fff) ? byteen : 4'b0000;
assign T0_WE = (A_in >= 32'h0000_7f00 && A_in <= 32'h0000_7f0b) ? (&byteen) : 1'b0;
assign UART_byteen = (A_in >= 32'h0000_7f30 && A_in <= 32'h0000_7f3f) ? byteen : 4'b0000;
assign DT_byteen = (A_in >= 32'h0000_7f50 && A_in <= 32'h0000_7f57) ? byteen : 4'b0000;
assign LED_byteen = (A_in >= 32'h0000_7f70 && A_in <= 32'h0000_7f73) ? byteen : 4'b0000;
assign RD_out = (A_in_reg >= 32'h0000_0000 && A_in_reg <= 32'h0000_2fff) ? DM_RD :
                (A_in_reg >= 32'h0000_7f00 && A_in_reg <= 32'h0000_7f0b) ? T0_RD_reg :
                (A_in_reg >= 32'h0000_7f30 && A_in_reg <= 32'h0000_7f3f) ? UART_RD_reg :
                (A_in_reg >= 32'h0000_7f50 && A_in_reg <= 32'h0000_7f57) ? DT_RD_reg :
                (A_in_reg >= 32'h0000_7f60 && A_in_reg <= 32'h0000_7f67) ? DipSwitch_RD_reg :
                (A_in_reg >= 32'h0000_7f68 && A_in_reg <= 32'h0000_7f6b) ? Key_RD_reg :
				    32'h0000_0000;
endmodule