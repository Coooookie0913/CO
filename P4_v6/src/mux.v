`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:01:16 10/29/2022 
// Design Name: 
// Module Name:    mux 
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
module mux_1for32 (
    input [31:0] A,
    input [31:0] B,
    input sel,
    output [31:0] result
    );
    assign result = (sel) ? B : A;
endmodule

module mux_1for5 (
    input [4:0] A,
    input [4:0] B,
    input sel,
    output [4:0] result
    );
    assign result = (sel) ? B : A;
endmodule