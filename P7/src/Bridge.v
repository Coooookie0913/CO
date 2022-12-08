module Bridge (
    //input
    input [31:0] A_in, //读写外设单元地址
    input [31:0] WD_in, //写入外设单元数据
    input [3:0] byteen, //写入外设单元使能
    input [31:0] DM_RD, //DM读取值输入
    input [31:0] T0_RD, //T0读取值输入
    input [31:0] T1_RD, //T1读取值输入
	 input interrupt,
    //output
	 output [31:0] RD_out,//从外设读取数据
    output [31:0] A_out, //读写外设单元地址
    output [31:0] WD_out, //写入外设单元数据
    output [3:0] DM_byteen, //DM写入使能
    output T0_WE, //T0写入使能
    output T1_WE, //T1写入使能
    output [31:0] m_int_addr, //中断发生器写入地址
    output [3:0] m_int_byteen //中断发生器字节使能信号
);

assign A_out = A_in;
assign WD_out = WD_in;
assign DM_byteen = (A_in >= 32'h0000_0000 && A_in <= 32'h0000_2fff) ? byteen : 4'b0000;
assign T0_WE = (A_in >= 32'h0000_7f00 && A_in <= 32'h0000_7f0b) ? (&byteen) : 1'b0;
assign T1_WE = (A_in >= 32'h0000_7f10 && A_in <= 32'h0000_7f1b) ? (&byteen) : 1'b0; 
assign m_int_addr = ((|m_int_byteen)&&interrupt) ? A_in : 32'h0000_0000;
assign m_int_byteen = ((A_in >= 32'h0000_7f20 && A_in <= 32'h0000_7f23)&&interrupt) ? byteen : 4'b0000;
assign RD_out = (A_in >= 32'h0000_0000 && A_in <= 32'h0000_2fff) ? DM_RD :
                (A_in >= 32'h0000_7f00 && A_in <= 32'h0000_7f0b) ? T0_RD :
					 (A_in >= 32'h0000_7f10 && A_in <= 32'h0000_7f1b) ? T1_RD :
					 32'h0000_0000;
endmodule