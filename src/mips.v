module mips (
    input clk,
    input reset
);
    //wire
    //PC
    wire [31:0] F_pc;
	 wire [31:0] F_pc4;
    wire [31:0] F_pc8;
	 wire npcSel;
    wire [31:0] D_npc;//直接接过来？不经过流水寄存器？
	 wire [31:0] F_npc;
    //IM
    wire [31:0] F_instr;
    //D_MCU
    wire [31:0] D_instr;
    wire [1:0] D_JCtrl;
    wire [2:0] D_EXTCtrl;
    wire [1:0] Tuse_rs;
    wire [1:0] Tuse_rt;
    wire D_Branch;
    wire [1:0] D_RegDst;
	 wire [1:0] D_Tnew;
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
    //ALU
    wire [31:0] E_V1;
    wire [31:0] E_V2;
    wire [31:0] E_E32;
    wire [31:0] E_AR;
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
    wire [4:0] M_A3;
    wire [4:0] M_A2;
    //DM
    wire [31:0] M_AR;
	 wire [31:0] M_Data;
    wire [31:0] M_V2;
    wire [31:0] M_RD;
    wire [31:0] M_WD;
    wire [31:0] M_pc8;
    wire [31:0] M_pc;
    //W_MCU
    wire [31:0] W_instr;
    wire [1:0] W_MemtoReg;
    wire W_RegWrite;
    wire [31:0] W_out;
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

    IM IM_mips (
	     //input
        .F_pc(F_pc),
		  //output
        .F_instr(F_instr)
    );
    
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
        //signal
        .clk(clk),
        .reset(reset),
        .RegWrite(W_RegWrite),
        //data
        .A1(D_instr[25:21]),
        .A2(D_instr[20:16]),
        .A3(W_A3),
        .WriteData(W_out),
        .pc(W_pc),
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
        .ALUCtrl(E_ALUCtrl),
        .ALUSrcBSel(E_ALUSrcBSel),
        .E_Tnew(E_Tnew),
		  .RegWrite(E_RegWrite)
    );

    //mux
    assign E_SrcA = (ALUa_Fwd == 2'b10) ? M_Data :
                    (ALUa_Fwd == 2'b01) ? W_out :
                    E_V1 ;

    assign E_SrcB_temp = (ALUb_Fwd == 2'b10) ? M_Data :
                         (ALUb_Fwd == 2'b01) ? W_out :
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
        .E_V2(E_SrcB_temp),
        .E_pc8(E_pc8),
        .E_pc(E_pc),
        //output
        .M_instr(M_instr),
        .M_A2(M_A2),
        .M_A3(M_A3),
        .M_AR(M_AR),
        .M_V2(M_V2),
        .M_pc8(M_pc8),
        .M_pc(M_pc)
    );

    MCU M_MCU (
        //input
        .instr(M_instr),
        //output
        .MemWrite(M_MemWrite),
        .RegWrite(M_RegWrite),
		  .jal(M_jal),
        .M_Tnew(M_Tnew)
    );

    //mux
    assign M_WD = (DM_Fwd) ? W_out : M_V2;
	 
	 assign M_Data = (M_jal) ? M_pc8 : M_AR;

    DM DM_mips (
        //input
        //signal
        .clk(clk),
        .reset(reset),
        .MemWrite(M_MemWrite),
        //data
        .pc(M_pc),
        .Addr(M_AR),
        .WriteData(M_WD),
        //output
        .RD(M_RD)
    );

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
        //output
        .W_instr(W_instr),
        .W_A3(W_A3),
        .W_AR(W_AR),
        .W_RD(W_RD),
        .W_pc8(W_pc8),
        .W_pc(W_pc)
    );

    MCU W_MCU (
        //input
        .instr(W_instr),
        //output
        .MemtoReg(W_MemtoReg),
        .RegWrite(W_RegWrite)
    );

    //mux 
    assign W_out = (W_MemtoReg == 2'b10) ? W_pc8 :
                   (W_MemtoReg == 2'b01) ? W_RD :
                   W_AR;
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
        //output
        .cmp1_Fwd(cmp1_Fwd),
        .cmp2_Fwd(cmp2_Fwd),
        .ALUa_Fwd(ALUa_Fwd),
        .ALUb_Fwd(ALUb_Fwd),
        .DM_Fwd(DM_Fwd),
		  .stall(stall)
    );
	 
endmodule