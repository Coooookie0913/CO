`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:55:02 10/29/2022 
// Design Name: 
// Module Name:    alu 
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
module ALU(
    input [31:0] SourceA,
    input [31:0] SourceB,
    input [2:0] aluCtrl,
    output [31:0] ALUResult
    );

    assign ALUResult = (aluCtrl == 3'b000) ? SourceA & SourceB :
                       (aluCtrl == 3'b001) ? SourceA | SourceB :
                       (aluCtrl == 3'b010) ? SourceA + SourceB :
                       (aluCtrl == 3'b110) ? SourceA - SourceB :
                       32'b0;
endmodule
