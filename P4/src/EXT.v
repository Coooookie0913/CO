`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:58:25 10/29/2022 
// Design Name: 
// Module Name:    EXT 
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
/*module EXT(
    input [15:0] imm16,
    input [1:0] EXTControl,
    output [31:0] immExtend
    );
    //  case(EXTControl)
    //  2'b00: immExtend = {{16{imm16[15]}},imm16};
    //  2'b01: immExtend = {{16{1'b0}},imm16};
    //  2'b10: immExtend = {imm16,{16{1'b0}};
    //  2'b11: immExtend = {{14{imm16[15]}},imm16,2'b00};
    //  default: immExtend = 32'b0;

    assign immExtend = (EXTControl == 2'b00) ? {{16{imm16[15]}},imm16}:
                       (EXTControl == 2'b01) ? {{16{1'b0}},imm16}: 
                       (EXTControl == 2'b10) ? {imm16,{16{1'b0}}: 
                       (EXTControl == 2'b11) ?  {{14{imm16[15]}},imm16,2'b00}: 
                       32'b0000_0000_0000_0000_0000_0000_0000_0000 ;
endmodule*/

module EXT (
    input [15:0] imm16,
    input [1:0] EXTControl,
    output [31:0] immExtend
);
    assign immExtend = (EXTControl == 2'b00) ? {{16{imm16[15]}},imm16}:
                       (EXTControl == 2'b01) ? {{16{1'b0}},imm16}: 
                       (EXTControl == 2'b10) ? {imm16,{16{1'b0}}}: 
                       (EXTControl == 2'b11) ?  {{14{imm16[15]}},imm16,2'b00}:
                       32'b0 ;
endmodule
