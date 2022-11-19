module mips (
    input clk,
    input reset,
    input [31:0] i_inst_rdata,
    input [31:0] m_data_rdata,
    output [31:0] i_inst_addr,
    output [31:0] m_data_addr,
    output [31:0] m_data_wdata,
    output [3:0] m_data_byteen,
    output [31:0] m_inst_addr,
    output w_grf_we,
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr
);

    assign i_inst_addr = F_pc;
    assign m_data_addr = M_AR;
    assign m_data_wdata = M_WD;
    assign m_inst_addr = M_pc;
    assign w_grf_we = W_RegWrite;
    assign w_grf_addr = W_A3;
    assign w_grf_wdata = W_Data;
    assign w_inst_addr = W_pc;
    
    //wire
    //PC
	 wire [31:0] F_instr;
	 assign F_instr = i_inst_rdata;
    wire [31:0] F_pc;
	 wire [31:0] F_pc4;
    wire [31:0] F_pc8;
	 wire npcSel;
    wire [31:0] D_npc;
	 wire [31:0] F_npc;
    //D_MCU
    wire [31:0] D_instr;
    wire [1:0] D_JCtrl;
    wire [2:0] D_EXTCtrl;
    wire [1:0] Tuse_rs;
    wire [1:0] Tuse_rt;
    wire [1:0] D_Branch;
    wire [1:0] D_RegDst;
	 wire [1:0] D_Tnew;
    wire D_MD ;
    //CMP
    wire [31:0] D_V1;
    wire [31:0] D_V2;
    wire cmp_out;
    //GRF
    wire [4:0] D_A1;
    wire [4:0] D_A2;
    wire [4:0] D_A3;
    wire [4:0] W_A3;
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
    wire [31:0] E_instr;
    wire [2:0] E_ALUCtrl;
    wire E_ALUSrcBSel;
	 wire E_RegWrite;//
    wire [4:0] E_A1;
    wire [4:0] E_A2;
    wire [4:0] E_A3;
    wire [3:0] E_MDCtrl;
    wire E_start;
    //ALU
    wire [31:0] E_V1;
    wire [31:0] E_V2;
    wire [31:0] E_E32;
    wire [31:0] E_AR;
    //MD
    wire [31:0] E_MDR;
    wire E_busy;
    wire [31:0] E_pc;
    wire [31:0] E_pc8;
    wire [31:0] E_SrcA;
    wire [31:0] E_SrcB_temp;
    wire [31:0] E_SrcB;
	 wire [31:0] E_Data;
    //M_MCU
    wire [31:0] M_instr;
    wire M_MemWrite;
    wire M_RegWrite;
	 wire M_jal;
    wire [1:0] loadOp;
    wire [4:0] M_A3;
    wire [4:0] M_A2;
    //DM
    wire [31:0] M_AR;
	 wire [31:0] M_MDR;
	 wire [31:0] M_Data;
    wire [31:0] M_V2;
    wire [31:0] M_WD;
	 wire [31:0] M_WD_temp;
	 wire [31:0] M_RD;
	 //Load
	 wire [1:0] M_loadOp;
    wire [31:0] M_pc8;
    wire [31:0] M_pc;
    //W_MCU
    wire [31:0] W_instr;
    wire W_MemtoReg;
    wire W_RegWrite;
    wire [31:0] W_Data;
    wire [31:0] W_Datam;
	 wire [31:0] W_pc;
	 wire [31:0] W_pc8;
	 wire [31:0] W_AR;
	 wire [31:0] W_RD;
    //HCU
    wire [1:0] E_Tnew;
    wire [1:0] M_Tnew;
    wire stall;
    wire [1:0] cmp1_Fwd;
    wire [1:0] cmp2_Fwd;
    wire [1:0] ALUa_Fwd;
    wire [1:0] ALUb_Fwd;
    wire DM_Fwd;
	 
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
        //output
        .F_pc8(F_pc8),
		  .F_pc4(F_pc4),
        .F_pc(F_pc)
    );
 	 
//*********************D**********************	
    
    //D
    D_Reg D_Reg_mips (
        //input
        //signal
        .clk(clk),
        .reset(reset),
        .stall(stall),
        //data
        .F_instr(F_instr),
        .F_pc(F_pc),
        .F_pc8(F_pc8),
        //output
        .D_instr(D_instr),
        .D_pc8(D_pc8),
        .D_pc(D_pc)
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
        //HCtrl
        .Tuse_rs(Tuse_rs),
        .Tuse_rt(Tuse_rt),
        .D_Tnew(D_Tnew)
    );

    CMP CMP_mips (
        //input
       .r1(D_V1),
       .r2(D_V2),
       .D_Branch(D_Branch),
       //output
       .cmp_out(cmp_out)
    );
	 
	 GRF GRF_mips (
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

    EXT EXT_mips (
        //input
        .imm16(D_instr[15:0]),
        .EXTCtrl(D_EXTCtrl),
        //output
        .E32(D_E32)
    );

    NPC NPC_mips (
        //input
        .E32(D_E32),
        .imm26(D_instr[25:0]),
        .pc(D_pc),
		  .ra(D_V1),
        .JCtrl(D_JCtrl),
        .cmp_out(cmp_out),
        //output
        .D_npc(D_npc)
    );

    //mux
	 assign F_npc = (npcSel) ? D_npc : F_pc4;
	 
    assign D_A3 = (D_RegDst == 2'b10) ? 5'b11111 :
                  (D_RegDst == 2'b01) ? D_instr[15:11] :
                   D_instr[20:16] ;
    
    assign D_V1 = (cmp1_Fwd == 2'b10) ? E_Data :
	               (cmp1_Fwd == 2'b01) ? M_Data :
                  D_RD1 ;
    
    assign D_V2 = (cmp2_Fwd == 2'b10) ? E_Data :
	               (cmp2_Fwd == 2'b01) ? M_Data :
                  D_RD2 ;
    
//*********************E**********************	 

    //E
    E_Reg E_Reg_mips (
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
        .D_V1(D_V1),
        .D_V2(D_V2),
        .D_pc(D_pc),
        .D_pc8(D_pc8),
        .D_E32(D_E32),
        //output
        .E_instr(E_instr),
        .E_A1(E_A1),
        .E_A2(E_A2),
        .E_A3(E_A3),
        .E_V1(E_V1),
        .E_V2(E_V2),
        .E_E32(E_E32),
        .E_pc(E_pc),
        .E_pc8(E_pc8)
    );

    MCU E_MCU (
        //input
        .instr(E_instr),
        //output
        .start(E_start),
        .ALUCtrl(E_ALUCtrl),
        .ALUSrcBSel(E_ALUSrcBSel),
        .E_Tnew(E_Tnew),
		  .RegWrite(E_RegWrite),
        .MDCtrl(E_MDCtrl)
    );

    //mux
    assign E_SrcA = (ALUa_Fwd == 2'b10) ? M_Data :
                    (ALUa_Fwd == 2'b01) ? W_Data :
                    E_V1 ;

    assign E_SrcB_temp = (ALUb_Fwd == 2'b10) ? M_Data :
                         (ALUb_Fwd == 2'b01) ? W_Data :
                         E_V2; 
    
    assign E_SrcB = (E_ALUSrcBSel) ? E_E32 : E_SrcB_temp;
	 assign E_Data = 32'b0;

    ALU ALU_mips (
        //input
        .SrcA(E_SrcA),
        .SrcB(E_SrcB),
        .ALUCtrl(E_ALUCtrl),
        //output
        .AR(E_AR)
    );

    MD MD_mips(
        //input 
        .clk(clk),
		  .reset(reset),
        .E_start(E_start),
        .SrcA(E_SrcA),
        .SrcB(E_SrcB),
        .MDCtrl(E_MDCtrl),
        //output
        .MDR(E_MDR),
        .busy(E_busy)
    );
	 
//*********************M**********************	 

    //M
    M_Reg M_Reg_mips (
        //input
        //signal
        .clk(clk),
        .reset(reset),
        //data
        .E_instr(E_instr),
        .E_A2(E_A2),
        .E_A3(E_A3),
        .E_AR(E_AR),
		  .E_MDR(E_MDR),
        .E_V2(E_SrcB_temp),
        .E_pc8(E_pc8),
        .E_pc(E_pc),
        //output
        .M_instr(M_instr),
        .M_A2(M_A2),
        .M_A3(M_A3),
        .M_AR(M_AR),
		  .M_MDR(M_MDR),
        .M_V2(M_V2),
        .M_pc8(M_pc8),
        .M_pc(M_pc)
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
        .byteen(m_data_byteen),
        .loadOp(M_loadOp),
        .M_Tnew(M_Tnew)
    );

    Load Load_mips(
        //input
        .m_data_rdata(m_data_rdata),
        .loadOp(M_loadOp),
        .byte_Addr(M_AR[1:0]),
        //output
        .RD(M_RD)
    );
	 
	 Store Store_mips(
	     //input
		  .WD_temp(M_WD_temp),
		  .byteen(m_data_byteen),
		  //output
		  .WD(M_WD)
	 );

    //mux
    assign M_WD_temp = (DM_Fwd) ? W_Data : M_V2;
	 
	 assign M_Data = (M_jal) ? M_pc8 : 
	                 (M_mf) ? M_MDR :
						   M_AR;

//*********************W**********************	 

    //W
    W_Reg W_Reg_mips (
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
        //output
        .W_instr(W_instr),
        .W_A3(W_A3),
        .W_AR(W_AR),
        .W_RD(W_RD),
        .W_pc8(W_pc8),
        .W_pc(W_pc),
        .W_Datam(W_Datam)
    );

    MCU W_MCU (
        //input
        .instr(W_instr),
        //output
        .MemtoReg(W_MemtoReg),
        .RegWrite(W_RegWrite)
    );

    //mux 
    assign W_Data = (W_MemtoReg) ? W_RD :
                     W_Datam;

	 HCU HCU_mips (
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
        .D_MD(D_MD),
        .E_busy(E_busy),
        .E_start(E_start),
        //output
        .cmp1_Fwd(cmp1_Fwd),
        .cmp2_Fwd(cmp2_Fwd),
        .ALUa_Fwd(ALUa_Fwd),
        .ALUb_Fwd(ALUb_Fwd),
        .DM_Fwd(DM_Fwd),
		  .stall(stall)
    );
	 
endmodule