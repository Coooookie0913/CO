`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:46:35 10/29/2022 
// Design Name: 
// Module Name:    im 
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
module IM(
    //input
    input clk,
    input reset,
    input [31:0] pc,
	 //output
    output [5:0] opcode,
    output [5:0] func,
	 
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd,
	 
    output [15:0] imm16,
    output [25:0] imm26
    );
	 
    reg [31:0] rom[0:4095];
    wire [11:0] addr;
    wire [31:0] regValue,temp;
    integer i;
	 
    initial begin
        $readmemh("code.txt",rom);
    end
	 
    //always @(posedge clk ) begin
    //    if (reset) begin
    //        for(i = 0; i < 4096; i = i+1)
    //        rom[i] <= 32'b0;
    //    end
    //end
	 //IM doesn't need to be cleared ?
	 
	assign temp = pc - 32'h0000_3000;//Addr begin at 0x0000_3000
    assign addr = temp[13:2];
    assign regValue = rom[addr];
	 
	 //splitter
    assign opcode = regValue[31:26];
    assign func = regValue[5:0];
    assign rs = regValue[25:21];
    assign rt = regValue[20:16];
    assign rd = regValue[15:11];
    assign imm16 = regValue[15:0];
    assign imm26 = regValue[25:0];
endmodule
