`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:05:29 10/27/2022
// Design Name:   mips
// Module Name:   C:/Users/HP/Desktop/ise/P4/tb.v
// Project Name:  P4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mips
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb;

	// Inputs
	reg clk;
	reg reset;

	// Instantiate the Unit Under Test (UUT)
	mips uut (
		.clk(clk), 
		.reset(reset) 
	); 
   
	initial begin
		// Initialize Inputs
		clk = 1; 
		reset = 1; 
      #12.5 reset=0;
		// Wait 100 ns for global reset to finish
         
		// Add stimulus here

	end
	always begin 
	   #5 clk=~clk;
	
	end 

endmodule



