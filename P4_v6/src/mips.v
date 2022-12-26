`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:41:28 10/29/2022 
// Design Name: 
// Module Name:    mips 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mips(
    input wire reset,
    input wire clk
    );
	 
	 //PC NPC
	 wire [31:0] pc,pc4,npc;
	 wire PCCtrl,Jump,jr;
	 wire [25:0] imm26;
	 wire [15:0] imm16;
	 //IM
	 wire RegWrite;
	 wire [5:0] opcode,func;
	 wire [4:0] rs,rt,rd;
	 //GRF
	 wire [4:0] A3;
	 wire RegDst,raLink;
	 wire [31:0] RegWriteData,RD1,RD2;
	 //ALU
	 wire aluSource;
	 wire [2:0] ALUCtrl;
	 wire [31:0] SourceB,ALUResult;
	 //DM
	 wire MemWrite,MemtoReg,AddrTrans;
	 wire [31:0] ReadData;
	 //EXT
	 wire [1:0] EXTCtrl;
	 wire [31:0] immExtend;
	 //Branch
	 wire If_branch;

    //IM	
    IM im(
//input
	 //signal
	 .clk(clk), 
	 .reset (reset),
	 //data
	 .pc(pc), 
//output
    //data
	 .opcode(opcode),
	 .func(func),
    .rs(rs),
	 .rt(rt),
	 .rd(rd),
    .imm16(imm16), 
	 .imm26(imm26)
	 );
	 
	 //PC
    PC pc_mips(
//input
    //signal
	 .clk(clk),
	 .reset(reset),
	 //data	 
	 .NPC(npc),
//output	 
	 .PC(pc)
	 );
	 
	 //NPC
    NPC npc_mips(
//input
    //data
	 .pc(pc), 
	 .imm16(imm16),
	 .imm26(imm26), 
	 .ra(RD1),
	 //signal
    .PCCtrl(PCCtrl), 
	 .Jump(Jump),
	 .jr(jr),
//output
	 .npc(npc),
    .pc4(pc4)
	 );
	 
	 //Controller
    Controller controller(
//input
    //data
	 .opcode(opcode), 
	 .func(func), 
//output
    //signal
	 //NPC
	 .Jump(Jump),
    .jr(jr),
	 //GRF
	 .RegDst(RegDst),
	 .raLink(raLink),
	 .RegWrite(RegWrite),
	 //ALU
    .aluSource(aluSource),
	 .aluCtrl(ALUCtrl),
	 //Branch
	 .Branch(If_branch),
	 //DM
    .MemtoReg(MemtoReg),
	 .AddrTrans(AddrTrans),
	 .MemWrite(MemWrite),
	 //EXT
    .EXTCtrl(EXTCtrl)
	 );
	 
	 //branch
    Branch branch(
//input
	 .If_branch(If_branch),
	 .ALUResult(ALUResult),
//output
	 .PCSource(PCCtrl)
	 );
	 
    wire [4:0] temp;
    wire [4:0] dollar_31 = 5'b11111;
	//RegDstSel
    mux_1for5 RegDstSel(
//input
    //data	 
	 .A(rt), 
	 .B(rd),
	 //signal
	 .sel(RegDst),
//output	 
	 .result(temp)
	 );
	 
	 //A3Sel
    mux_1for5 A3Sel(
//input
	 .A(temp),
	 .B(dollar_31), 
	 .sel(raLink),
//output
	 .result(A3)
	 );
	 
	 //GRF
    GRF GRF(
//input
    //signal	 
	 .clk(clk),
	 .reset(reset),
	 .RegWrite(RegWrite),
	 //data
	 .A1(rs),
	 .A2(rt),
	 .A3(A3),
	 .pc(pc),
	 .Data(RegWriteData),
//output
	 .RD1(RD1),
	 .RD2(RD2)
	 );
	 
	 //EXT
    EXT EXT(
//input
	 .imm16(imm16),
	 .EXTControl(EXTCtrl),
//output	 
	 .immExtend(immExtend)
	 );
	 
	 //aluSrcSel
    mux_1for32 aluSourceSel(
//input	 
	 .A(RD2),
	 .B(immExtend),
	 .sel(aluSource),
//output
	 .result(SourceB)
	 );
	 
	 //ALU
     ALU alu(
//input 
    //data	 
	 .SourceA(RD1),
	 .SourceB(SourceB),
    //signal	 
	 .aluCtrl(ALUCtrl),
//output
	 .ALUResult(ALUResult)
	 );
	 
	 //DM
    DM dm(
//input
    //signal	 
	 .clk(clk),
	 .reset(reset),
	 .MemWrite(MemWrite),
	 //data
	 .pc(pc),
	 .Addr(ALUResult),
	 .WriteData(RD2), 
//output
	 .ReadData(ReadData)
	 );
	 
    wire [31:0] temp1;
	 
	 //MemtoRegSel
    mux_1for32 MemtoRegSel(
	 .A(ALUResult),
	 .B(ReadData),
	 .sel(MemtoReg), 
	 .result(temp1)
	 );
	 //AddrTransSel
    mux_1for32 AddrTransSel(
	 .A(temp1), 
	 .B(pc4), 
	 .sel(AddrTrans),
	 .result(RegWriteData)
	 );
endmodule
