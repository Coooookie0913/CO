module mips (
    input clk,                    // 时钟信号
    input reset,                  // 同步复位信号
    input interrupt,              // 外部中断信号
    output [31:0] macroscopic_pc, // 宏观 PC

    output [31:0] i_inst_addr,    // IM 读取地址（取指 PC）
    input  [31:0] i_inst_rdata,   // IM 读取数据

    output [31:0] m_data_addr,    // DM 读写地址
    input  [31:0] m_data_rdata,   // DM 读取数据
    output [31:0] m_data_wdata,   // DM 待写入数据
    output [3 :0] m_data_byteen,  // DM 字节使能信号

    output [31:0] m_int_addr,     // 中断发生器待写入地址
    output [3 :0] m_int_byteen,   // 中断发生器字节使能信号

    output [31:0] m_inst_addr,    // M 级 PC

    output w_grf_we,              // GRF 写使能信号
    output [4 :0] w_grf_addr,     // GRF 待写入寄存器编号
    output [31:0] w_grf_wdata,    // GRF 待写入数据

    output [31:0] w_inst_addr     // W 级 PC
);
    
wire [31:0] T0_RD,T1_RD,m_data_addr_temp,m_data_wdata_temp,m_data_rdata_bridge;
wire [3:0] m_data_byteen_temp;
wire T0_WE,T1_WE,T0_IRQ,T1_IRQ;
wire intrespon;
CPU CPU_mips(
   //input
   .clk(clk),
   .reset(reset),
   .interrupt(interrupt),
   .Timer1(T1_IRQ),
   .Timer0(T0_IRQ),
   .i_inst_rdata(i_inst_rdata),
   .m_data_rdata(m_data_rdata_bridge),
   //output
   .i_inst_addr(i_inst_addr),
   .m_data_addr(m_data_addr_temp),
   .m_data_wdata(m_data_wdata_temp),
   .m_data_byteen(m_data_byteen_temp),
   .m_inst_addr(m_inst_addr),
   .w_grf_we(w_grf_we),
   .w_grf_addr(w_grf_addr),
   .w_grf_wdata(w_grf_wdata),
   .w_inst_addr(w_inst_addr),
   .macroscopic_pc(macroscopic_pc)
);    

Bridge Bridge_mips(
   //input
   .A_in(m_data_addr_temp),
   .WD_in(m_data_wdata_temp),
   .byteen(m_data_byteen_temp),
   .DM_RD(m_data_rdata),
   .T0_RD(T0_RD),
   .T1_RD(T1_RD),
	.interrupt(interrupt),
   //output
	.RD_out(m_data_rdata_bridge),
   .A_out(m_data_addr),
   .WD_out(m_data_wdata),
   .DM_byteen(m_data_byteen),
   .T0_WE(T0_WE),
   .T1_WE(T1_WE),
   .m_int_addr(m_int_addr),
   .m_int_byteen(m_int_byteen)
);

TC Timer0_mips(
   //input
   .clk(clk),
   .reset(reset),
   .Addr(m_data_addr[31:2]),
   .WE(T0_WE),
   .Din(m_data_wdata),
   //output
   .Dout(T0_RD),
   .IRQ(T0_IRQ)
);

TC Timer1_mips(
   //input 
   .clk(clk),
   .reset(reset),
   .Addr(m_data_addr[31:2]),
   .WE(T1_WE),
   .Din(m_data_wdata),
   //output
   .Dout(T1_RD),
   .IRQ(T1_IRQ)
);

endmodule