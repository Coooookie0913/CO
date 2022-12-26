`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:57:18 10/29/2022 
// Design Name: 
// Module Name:    branch 
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
module Branch(
    input If_branch,
    input [31:0] ALUResult,
    output PCSource
    );
    assign PCSource = (If_branch && (ALUResult == 0)) ? 1'b1 : 1'b0;
endmodule
