`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:52:32 10/29/2022 
// Design Name: 
// Module Name:    pc 
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
module PC(
    input clk,
    input reset,
    input [31:0] NPC,
    output [31:0] PC
    );
    reg [31:0] temp;
	 
	 //initial begin
	 //    temp = 32'h0000_3000;
	 //end
	 //PC doesn't need initializing? 
	 //Normally,use reset to initialize
	 
    always @(posedge clk ) begin
        if (reset) temp <= 32'h0000_3000;
        else temp <= NPC;
    end
	 
    assign PC = temp;
endmodule
