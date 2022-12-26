`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:53:41 10/29/2022 
// Design Name: 
// Module Name:    GRF 
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
module GRF(
    //input
    input clk,
    input reset,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
	input [31:0] pc,
    input [31:0] Data,
    input RegWrite,
	 //output
    output [31:0] RD1,
    output [31:0] RD2
    );
	 
    reg [31:0] rf[0:31];
    integer i;
    
    assign RD1 = (A1 != 0) ? rf[A1] : 32'b0;
    assign RD2 = (A2 != 0) ? rf[A2] : 32'b0;
    
    always @(posedge clk ) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1 ) begin
                rf[i] <= 32'b0;
            end
        end
        else if(RegWrite && A3 != 5'b0)  begin
        rf[A3] <= Data;
        $display("@%h: $%d <= %h",pc,A3,Data);
        end
    end
endmodule
