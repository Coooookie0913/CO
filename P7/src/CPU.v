`define Int 5'd0
`define AdEL 5'd4
`define AdES 5'd5
`define Syscall 5'd8 
`define RI 5'd10 
`define Ov 5'd12 

module CPU (
    input clk,
    input reset,
    input [31:0] i_inst_rdata,
    input [31:0] m_data_rdata,
    input interrupt,
    input Timer1,
    input Timer0,
    output [31:0] i_inst_addr,
    output [31:0] m_data_addr,
    output [31:0] m_data_wdata,
    output [3:0] m_data_byteen,
    output [31:0] m_inst_addr,
    output w_grf_we,
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr,
    output [31:0] macroscopic_pc
);

    assign i_inst_addr =  F_pc;
    assign m_data_addr =  M_AR;
    assign m_data_wdata = M_WD;
    assign m_data_byteen = (|M_ExcCode_fixed) ? 4'b0000 : M_byteen;
    assign m_inst_addr = M_pc;
    assign w_grf_we = W_RegWrite;
    assign w_grf_addr = W_A3;
    assign w_grf_wdata = W_Data;
    assign w_inst_addr = W_pc;
    assign macroscopic_pc = M_pc;
    
    //wire
    //PC
	 wire [31:0] F_instr;
	 assign F_instr = (D_eret) ? 32'h00000000 :
	                  (F_ExcCode == `AdEL) ? 32'h0000_0000 : 
							i_inst_rdata;
	 wire [31:0] F_pc;
    wire [31:0] F_pc_temp;
	 wire [31:0] F_pc4;
	 wire [31:0] F_pc4_temp;
    wire [31:0] F_pc8;
	 wire [31:0] F_pc8_temp;
	 wire npcSel;
    wire [31:0] D_npc;
	 wire [31:0] F_npc;
    wire F_BD;
    //D_MCU
    wire D_BD;
    wire [31:0] D_instr;
    wire [1:0] D_JCtrl;
    wire [2:0] D_EXTCtrl;
    wire [1:0] Tuse_rs;
    wire [1:0] Tuse_rt;
    wire [1:0] D_Branch;
    wire [1:0] D_RegDst;
	 wire [1:0] D_Tnew;
    wire D_MD ;
    wire D_syscall;
    wire D_RI;
    wire D_eret;
    //CMP
    wire [31:0] D_V1;
    wire [31:0] D_V2;
    wire cmp_out;
    //GRF
    wire [4:0] D_A1;
    wire [4:0] D_A2;
    wire [4:0] D_A3;
    wire [4:0] W_A3;
	 wire [4:0] D_CP0Addr;
    wire [31:0] D_RD1;
    wire [31:0] D_RD2;
    //EXT
    wire [15:0] imm16;
    wire [31:0] D_E32;
    //NPC
    wire [31:0] D_pc;
    wire [25:0] imm26;
    wire [31:0] RD1;
    wire [31:0] D_pc8;
    //E_MCU
    wire E_BD;
    wire [31:0] E_instr;
    wire [2:0] E_ALUCtrl;
    wire E_ALUSrcBSel;
	 wire E_RegWrite;//
    wire [4:0] E_A1;
    wire [4:0] E_A2;
    wire [4:0] E_A3;
	 wire [4:0] E_CP0Addr;
    wire [3:0] E_MDCtrl;
    wire E_start;
    wire E_OvCalInstr;
    wire E_OvLoadInstr;
    wire E_OvSaveInstr;
    wire E_mtc0;
    //ALU
    wire [31:0] E_V1;
    wire [31:0] E_V2;
    wire [31:0] E_E32;
    wire [31:0] E_AR;
    wire E_Overflow;
    //MD
    wire [31:0] E_MDR;
    wire E_busy;
    wire [31:0] E_pc;
    wire [31:0] E_pc8;
    wire [31:0] E_SrcA;
    wire [31:0] E_SrcB_temp;
    wire [31:0] E_SrcB;
	 wire [31:0] E_Data;
	 wire E_mf;
    //M_MCU
    wire M_BD;
    wire [3:0] M_byteen;
    wire [31:0] M_instr;
    wire M_MemWrite;
    wire M_RegWrite;
	 wire M_jal;
    wire [1:0] loadOp;
    wire [4:0] M_A3;
    wire [4:0] M_A2;
    wire M_lw;
    wire M_lh;
    wire M_lb;
    wire M_sw;
    wire M_sh;
    wire M_sb;
    wire M_mfc0;
	 wire M_mtc0;
    wire M_EXLClr;
    wire M_DM_Addr;
    wire M_Timer_Addr;
    wire M_IG_Addr;
    wire M_CP0WE;
    //DM
    wire [31:0] M_AR;
	 wire [31:0] M_MDR;
    wire [31:0] M_Data_temp;
	 wire [31:0] M_Data;
	 wire [31:0] M_Datae;
    wire [31:0] M_V2;
    wire [31:0] M_WD;
	 wire [31:0] M_WD_temp;
	 wire [31:0] M_RD;
	 //Load
	 wire [1:0] M_loadOp;
    wire [31:0] M_pc8;
    wire [31:0] M_pc;
    //CP0
    wire [5:0] HWInt;
    wire [31:0] M_CP0out;
    wire [31:0] EPC;
    wire Req;
	 wire [4:0] M_CP0Addr;
    //W_MCU
    wire [31:0] W_instr;
    wire [1:0] W_MemtoReg;
    wire W_RegWrite;
    wire [31:0] W_Data;
    wire [31:0] W_Datam;
	 wire [31:0] W_pc;
	 wire [31:0] W_pc8;
	 wire [31:0] W_AR;
	 wire [31:0] W_RD;
	 wire [31:0] W_CP0out;
    //HCU
    wire [1:0] E_Tnew;
    wire [1:0] M_Tnew;
    wire stall;
    wire [1:0] cmp1_Fwd;
    wire [1:0] cmp2_Fwd;
    wire [1:0] ALUa_Fwd;
    wire [1:0] ALUb_Fwd;
    wire DM_Fwd;
    //Exception
    wire [4:0] F_ExcCode;
    wire [4:0] D_ExcCode,D_ExcCode_fixed;
    wire [4:0] E_ExcCode,E_ExcCode_fixed;
	 wire [4:0] M_ExcCode,M_ExcCode_fixed;

//*********************F**********************
	
    //module
    PC PC_mips (
        //input
        //signal
        .clk(clk),
        .reset(reset),
        .stall(stall),
        //data
        .npc(F_npc),
		  .Req(Req),
		  .eret(D_eret),
		  .EPC(EPC),
        //output
        .F_pc8(F_pc8),
		  .F_pc4(F_pc4),
        .F_pc(F_pc)
    );
 	 
    assign F_ExcCode =  ((F_pc[1:0] != 2'b00) || (!((F_pc >= 32'h0000_3000) && (F_pc <= 32'h0000_6ffc))) ) ? `AdEL : 5'b00000;
    assign F_BD = npcSel;
	 
//*********************D**********************	
    
    //D
    D_Reg D_Reg_cpu (
        //input
        //signal
        .clk(clk),
        .reset(reset),
        .stall(stall),
        //data
        .F_instr(F_instr),
        .F_pc(F_pc),
        .F_pc8(F_pc8),
        .F_ExcCode(F_ExcCode),
        .F_BD(F_BD),
        .Req(Req),
        //output
        .D_instr(D_instr),
        .D_pc8(D_pc8),
        .D_pc(D_pc),
        .D_ExcCode(D_ExcCode),
        .D_BD(D_BD)
    );

    MCU D_MCU (
        //input
        .instr(D_instr),
        //output
        //MCtrl
        .Branch(D_Branch),
        .EXTCtrl(D_EXTCtrl),
        .JCtrl(D_JCtrl),
        .RegDst(D_RegDst),
		  .npcSel(npcSel),
        .start(D_strat),
        .MD(D_MD),
        //Exception
        .syscall(D_syscall),
        .RI(D_RI),
        .eret(D_eret),
        //HCtrl
        .Tuse_rs(Tuse_rs),
        .Tuse_rt(Tuse_rt),
        .D_Tnew(D_Tnew)
    );

    CMP CMP_cpu (
        //input
       .r1(D_V1),
       .r2(D_V2),
       .D_Branch(D_Branch),
       //output
       .cmp_out(cmp_out)
    );
	 
	 GRF GRF_cpu (
	     //input
		  .clk(clk),
		  .reset(reset),
		  .A1(D_instr[25:21]),
		  .A2(D_instr[20:16]),
		  .A3(W_A3),
		  .WriteData(W_Data),
		  .RegWrite(W_RegWrite),
		  //output
		  .RD1(D_RD1),
		  .RD2(D_RD2)
	 );

    EXT EXT_cpu (
        //input
        .imm16(D_instr[15:0]),
        .EXTCtrl(D_EXTCtrl),
        //output
        .E32(D_E32)
    );

    NPC NPC_cpu (
        //input
        .E32(D_E32),
        .imm26(D_instr[25:0]),
        .pc(D_pc),
		  .ra(D_V1),
        .JCtrl(D_JCtrl),
        .cmp_out(cmp_out),
		  .Req(Req),
        //output
        .D_npc(D_npc)
    );

    //mux
	 assign F_npc = (npcSel) ? D_npc : F_pc4; //如果是D_eret,那么一定选择pc4,也就是EPC+4
	 
    assign D_A3 = (D_RegDst == 2'b10) ? 5'b11111 :
                  (D_RegDst == 2'b01) ? D_instr[15:11] :
                   D_instr[20:16] ;
    
    assign D_V1 = (cmp1_Fwd == 2'b10) ? E_Data :
	               (cmp1_Fwd == 2'b01) ? M_Data :
                  D_RD1 ;
    
    assign D_V2 = (cmp2_Fwd == 2'b10) ? E_Data :
	               (cmp2_Fwd == 2'b01) ? M_Data :
                  D_RD2 ;

    assign D_ExcCode_fixed = (|D_ExcCode) ? D_ExcCode :
	                          (D_syscall) ? `Syscall :
                             (D_RI) ? `RI :
									  5'b00000 ;
    
//*********************E**********************	 

    //E
    E_Reg E_Reg_cpu (
        //input
        //signal
        .clk(clk),
        .reset(reset),
        .stall(stall),
        //data
        .D_instr(D_instr),
        .D_A1(D_instr[25:21]),
        .D_A2(D_instr[20:16]),
        .D_A3(D_A3),
		  .D_CP0Addr(D_instr[15:11]),
        .D_V1(D_V1),
        .D_V2(D_V2),
        .D_pc(D_pc),
        .D_pc8(D_pc8),
        .D_E32(D_E32),
        .D_ExcCode_fixed(D_ExcCode_fixed),
        .D_BD(D_BD),
        .Req(Req),
        //output
        .E_instr(E_instr),
        .E_A1(E_A1),
        .E_A2(E_A2),
        .E_A3(E_A3),
		  .E_CP0Addr(E_CP0Addr),
        .E_V1(E_V1),
        .E_V2(E_V2),
        .E_E32(E_E32),
        .E_pc(E_pc),
        .E_pc8(E_pc8),
        .E_ExcCode(E_ExcCode),
        .E_BD(E_BD)
    );

    MCU E_MCU (
        //input
        .instr(E_instr),
        //output
        .start(E_start),
		  .mf(E_mf),
        .ALUCtrl(E_ALUCtrl),
        .ALUSrcBSel(E_ALUSrcBSel),
        .E_Tnew(E_Tnew),
		  .RegWrite(E_RegWrite),
        .MDCtrl(E_MDCtrl),
        .OvCalInstr(E_OvCalInstr),
        .OvLoadInstr(E_OvLoadInstr),
        .OvSaveInstr(E_OvSaveInstr),
        .mtc0(E_mtc0)
    );

    //mux
    assign E_SrcA = (ALUa_Fwd == 2'b10) ? M_Data :
                    (ALUa_Fwd == 2'b01) ? W_Data :
                    E_V1 ;

    assign E_SrcB_temp = (ALUb_Fwd == 2'b10) ? M_Data :
                         (ALUb_Fwd == 2'b01) ? W_Data :
                         E_V2; 
    
    assign E_SrcB = (E_ALUSrcBSel) ? E_E32 : E_SrcB_temp;
	 assign E_Data = (E_mf) ? E_MDR : E_AR;

    ALU ALU_cpu (
        //input
        .SrcA(E_SrcA),
        .SrcB(E_SrcB),
        .ALUCtrl(E_ALUCtrl),
        //output
        .AR(E_AR),
        .Overflow(E_Overflow)
    );

    MD MD_cpu (
        //input 
        .clk(clk),
		.reset(reset),
        .E_start(E_start),
        .SrcA(E_SrcA),
        .SrcB(E_SrcB),
        .MDCtrl(E_MDCtrl),
        .Req(Req),
        //output
        .MDR(E_MDR),
        .busy(E_busy)
    );

    assign E_ExcCode_fixed = (|E_ExcCode) ? E_ExcCode :
	                          (E_OvCalInstr) ? (E_Overflow ? `Ov : E_ExcCode) :
                             (E_OvLoadInstr) ? (E_Overflow ? `AdEL : E_ExcCode) :
                             (E_OvSaveInstr) ? (E_Overflow ? `AdES : E_ExcCode) :
                             5'b00000; 
	 
//*********************M**********************	 

    //M
    M_Reg M_Reg_cpu (
        //input
        //signal
        .clk(clk),
        .reset(reset),
        //data
        .E_instr(E_instr),
        .E_A2(E_A2),
        .E_A3(E_A3),
		  .E_CP0Addr(E_CP0Addr),
        .E_AR(E_AR),
		  .E_MDR(E_MDR),
		  .E_Data(E_Data),
        .E_V2(E_SrcB_temp),
        .E_pc8(E_pc8),
        .E_pc(E_pc),
        .E_ExcCode_fixed(E_ExcCode_fixed),
        .E_BD(E_BD),
        .Req(Req),
        //output
        .M_instr(M_instr),
        .M_A2(M_A2),
        .M_A3(M_A3),
		  .M_CP0Addr(M_CP0Addr),
        .M_AR(M_AR),
		  .M_MDR(M_MDR),
		  .M_Datae(M_Datae),
        .M_V2(M_V2),
        .M_pc8(M_pc8),
        .M_pc(M_pc),
        .M_ExcCode(M_ExcCode),
        .M_BD(M_BD)
    );

    MCU M_MCU (
        //input
        .instr(M_instr),
		  .M_AR(M_AR),
        //output
        .MemWrite(M_MemWrite),
        .RegWrite(M_RegWrite),
		  .jal(M_jal),
		  .mf(M_mf),
        .byteen(M_byteen),
        .loadOp(M_loadOp),
        .M_Tnew(M_Tnew),
        //Exception
        .lw(M_lw),
        .lh(M_lh),
        .lb(M_lb),
        .sw(M_sw),
        .sh(M_sh),
        .sb(M_sb),
        .mfc0(M_mfc0),
		  .mtc0(M_mtc0),
        .CP0WE(M_CP0WE),
        .EXLClr(M_EXLClr)
    );

    Load Load_cpu (
        //input
        .m_data_rdata(m_data_rdata),
        .loadOp(M_loadOp),
        .byte_Addr(M_AR[1:0]),
        //output
        .RD(M_RD)
    );
	 
	Store Store_cpu (
	     //input
		  .WD_temp(M_WD_temp),
		  .byteen(m_data_byteen),
		  //output
		  .WD(M_WD)
	 );

    assign HWInt = {3'b000,interrupt,Timer1,Timer0}; 
	 wire intrespon;
	 
    CP0 CP0_cpu (
	     //input
        .clk(clk),
        .reset(reset),
        .en(M_CP0WE),
        .EXLClr(M_EXLClr),
        .CP0In(M_WD_temp),
        .CP0Addr(M_CP0Addr),
        .BDIn(M_BD),
        .ExcCodeIn(M_ExcCode_fixed),
        .HWInt(HWInt),
		  .vPC(M_pc),
		  //output
        .CP0out(M_CP0out),
        .EPCout(EPC),
        .Req(Req)
     );
    
    //Addr
    assign M_DM_Addr = (M_AR >= 32'h0000_0000) && (M_AR <= 32'h0000_2fff);
    assign M_Timer_Addr = ((M_AR >= 32'h0000_7f00) && (M_AR <= 32'h0000_7f0b)) || ((M_AR >= 32'h0000_7f10) && (M_AR <= 32'h0000_7f1b));
    assign M_IG_Addr = (M_AR >= 32'h0000_7f20) && (M_AR <= 32'h0000_7f23);

    //mux
    assign M_WD_temp = (DM_Fwd) ? W_Data : M_V2;
	 
	 assign M_Data = (M_jal) ? M_pc8 : M_Datae;

    assign M_ExcCode_fixed = (|M_ExcCode) ? M_ExcCode :
	                          ((M_lw || M_lh || M_lb) && (!M_DM_Addr) && (!M_Timer_Addr) && (!M_IG_Addr)) ? `AdEL :
                             ((M_sw || M_sh || M_sb) && (!M_DM_Addr) && (!M_Timer_Addr) && (!M_IG_Addr)) ? `AdES ://越界
                             ((M_lw) && (M_AR[1:0] != 2'b00)) ? `AdEL :
                             ((M_sw) && (M_AR[1:0] != 2'b00)) ? `AdES : //没有字对齐
                             ((M_lh) && (M_AR[0] != 1'b0)) ? `AdEL :
                             ((M_sh) && (M_AR[0] != 1'b0)) ? `AdES : //没有半字对齐
                             ((M_lh || M_lb) && M_Timer_Addr) ? `AdEL : //半字或字节访问Timer
                             ((M_sh || M_sb) && M_Timer_Addr) ? `AdES : //半字或字节写入Timer
									  ((M_sw) && ((M_AR == 32'h0000_7f08) || (M_AR == 32'h0000_7f18))) ? `AdES : 
                             5'b00000;


//*********************W**********************	 

    //W
    W_Reg W_Reg_cpu (
        //input
        //signal
        .clk(clk),
        .reset(reset),
        //data
        .M_instr(M_instr),
        .M_A3(M_A3),
        .M_AR(M_AR),
        .M_RD(M_RD),
        .M_pc8(M_pc8),
        .M_pc(M_pc),
        .M_Data(M_Data),
        .Req(Req),
		  .M_CP0out(M_CP0out),
        //output
        .W_instr(W_instr),
        .W_A3(W_A3),
        .W_AR(W_AR),
        .W_RD(W_RD),
        .W_pc8(W_pc8),
        .W_pc(W_pc),
        .W_Datam(W_Datam),
		  .W_CP0out(W_CP0out)
    );

    MCU W_MCU (
        //input
        .instr(W_instr),
        //output
        .MemtoReg(W_MemtoReg),
        .RegWrite(W_RegWrite)
    );

    //mux 
    assign W_Data =  (W_MemtoReg == 2'b10) ? W_CP0out :
	                  (W_MemtoReg == 2'b01) ? W_RD :
                     W_Datam;

	 HCU HCU_cpu (
        //input
        .Tuse_rs(Tuse_rs),
        .Tuse_rt(Tuse_rt),
        .E_Tnew(E_Tnew),
        .M_Tnew(M_Tnew),
		  .E_RegWrite(E_RegWrite),
        .M_RegWrite(M_RegWrite),
        .W_RegWrite(W_RegWrite),
        .D_A1(D_instr[25:21]),
        .D_A2(D_instr[20:16]),
        .E_A1(E_A1),
        .E_A2(E_A2),
        .E_A3(E_A3),
        .M_A2(M_A2),
        .M_A3(M_A3),
        .W_A3(W_A3),
		  .E_CP0Addr(E_CP0Addr),
		  .M_CP0Addr(M_CP0Addr),
        .D_MD(D_MD),
        .E_busy(E_busy),
        .E_start(E_start),
        .D_eret(D_eret),
        .E_mtc0(E_mtc0),
        .M_mtc0(M_mtc0),
        //output
        .cmp1_Fwd(cmp1_Fwd),
        .cmp2_Fwd(cmp2_Fwd),
        .ALUa_Fwd(ALUa_Fwd),
        .ALUb_Fwd(ALUb_Fwd),
        .DM_Fwd(DM_Fwd),
		  .stall(stall)
    );
	 
endmodule