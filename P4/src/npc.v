`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:49:36 10/29/2022 
// Design Name: 
// Module Name:    npc 
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
module NPC(
    //input
    input [31:0] pc,
    input [15:0] imm16,
    input [25:0] imm26,
    input [31:0] ra,
    input PCCtrl,
    input Jump,
    input jr,
	 //output
    output [31:0] npc,
    output [31:0] pc4
    );
	 
    wire [31:0] pcExtend1,pcExtend2,result1,result2;
	 
    assign pc4 = pc + 4;
    assign pcExtend1 = {{14{imm16[15]}},imm16,2'b00} + pc4;
    assign pcExtend2 = {pc[31:28],imm26,2'b00};
	 //PCSourceSel
    mux_1for32 PCSourceSel(
	 .A(pc4),
	 .B(pcExtend1),
	 .sel(PCCtrl),
	 .result(result1)
	 );
	 //JRSel
    mux_1for32 JRSel(
	 .A(pcExtend2), 
	 .B(ra), 
	 .sel(jr),
	 .result(result2)
	 );
	 //JumpSel
    mux_1for32 JumpSel(
	 .A(result1), 
	 .B(result2),
	 .sel(Jump), 
	 .result(npc)
	 );
endmodule
