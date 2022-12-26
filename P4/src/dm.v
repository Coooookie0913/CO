`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:56:07 10/29/2022 
// Design Name: 
// Module Name:    dm 
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
module DM(
    //input
    input clk,
    input reset,
	input [31:0] pc,
    input [31:0] Addr,
    input [31:0] WriteData,
    input MemWrite,
	 //output
    output [31:0] ReadData
    );
	 
    reg[31:0] dm[0:3071];
    wire [11:0] addr;
	 integer i;
	 
    assign addr = Addr[13:2];//?3072
    assign ReadData = dm[addr];
	 
    always @(posedge clk ) begin
        if (reset) begin
            for (i = 0; i < 3072; i = i+1)begin
                dm[i] <= 32'b0;
            end
        end
        else if(MemWrite) begin
            dm[addr] <= WriteData;
            $display("@%h: *%h <= %h",pc,Addr,WriteData);
        end 
    end
endmodule
