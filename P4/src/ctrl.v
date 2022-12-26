`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:42:55 10/29/2022 
// Design Name: 
// Module Name:    ctrl 
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
/*module maindec(
    input [5:0] opcode,
    input [5:0] func,
    output Jump,
    output jr,
    output RegDst,
    output raLink,
    output aluSource,
    output Branch,
    output MemtoReg,
    output AddrTrans,
    output RegWrite,
    output MemWrite,
    output [1:0] EXTCtrl,
    output [1:0] aluop
    );
    wire add,sub,ori,lw,sw,beq,lui,jal,jr,R;
    assign R = (~opcode[5]) & (~opcode[4]) & (~opcode[3]) & (~opcode[2]) & (~opcode[1]) & (~opcode[0]);
    assign add = R & func[5] & (~func[4]) & (~func[3]) & (~func[2]) & (~func[1]) & (~func[0]);
    assign sub = R & func[5] & (~func[4]) & (~func[3]) & (~func[2]) & func[1] & (~func[0]);
    assign ori = (~opcode[5]) & (~opcode[4]) & opcode[3] & opcode[2] & (~opcode[1]) & opcode[0];
    assign lw = opcode[5] & (~opcode[4]) & (~opcode[3]) & (~opcode[2]) & opcode[1] & opcode[0];
    assign sw = opcode[5] & (~opcode[4]) & opcode[3] & (~opcode[2]) & opcode[1] & opcode[0];
    assign beq = (~opcode[5]) & (~opcode[4]) & (~opcode[3]) & opcode[2] & (~opcode[1]) & (~opcode[2]);
    assign lui = (~opcode[5]) & (~opcode[4]) & opcode[3] & opcode[2] & opcode[1] & opcode[0];
    assign jal = (~opcode[5]) & (~opcode[4]) & (~opcode[3]) & (~opcode[2]) & opcode[1] & opcode[0];
    assign jr = R & (~func[5]) & (~func[4]) & func[3] & (~func[2]) & (~func[1]) & (~func[0]);

    assign Jump = jal | jr;
    assign RegDst = add | sub;
    assign raLink = jal;
    assign aluSource = ori | lw | sw | lui;
    assign Branch = beq;
    assign MemtoReg = lw;
    assign AddrTrans = jal;
    assign RegWrite = add | sub | ori | lw | lui | jal;
    assign MemWrite = sw ;
    assign aluCtrl[2] = sub | beq;
    assign aluCtrl[1] = add | sub | lw | sw | beq | lui;
    assign aluCtrl[0] = ori;
    assign EXTCtrl[1] = beq | lui;
    assign EXTCtrl[0] = ori | beq;*/

/*    wire [13:0] controls;
    assign {aluop,EXTCtrl,Branch,RegDst,RegWrite,aluSource,MemWrite,MemtoReg,AddrTrans,raLink,jr,Jump} = controls;
    
    case (opcode)
      6'b000000: controls =(func != 6'b001000) ? 12'b10_0001_1000_0000 : 12'b00_0000_0000_0011;//Rtype,jr
      6'b001101: controls = 12'b11_0100_1100_0000;//ori
      6'b100011: controls = 12'b00_0000_1101_0000;//lw
      6'b101011: controls = 12'b00_0000_0110_0000;//sw
      6'b000100: controls = 12'b01_1110_0000_0000;//beq
      6'b001111: controls = 12'b00_1000_1100_0000;//lui
      6'b000011: controls = 12'b00_0000_1000_1101;//jal
      default: controls = 12'bxx_xxxx_xxxx_xxxx;
    endcase
endmodule

module aludec(
    input [5:0] func,
    input [1:0] aluop,
    output [2:0] aluCtrl
    );
    case(aluop)
      2'b00: aluCtrl = 3'b010;//add for lw sw lui
      2'b01: aluCtrl = 3'b110;//sub for beq
      2'b11: aluCtrl = 3'b001;//or for ori
      default:case (func)
          6'b100000: aluCtrl = 3'b010;
          6'b100010: aluCtrl = 3'b110;
          default: aluCtrl = 3'bxxx;
endmodule   */ 

module Controller(
    //input
    input [5:0] opcode,
    input [5:0] func,
	 //output
    output Jump,
    output jr,
    output RegDst,
    output raLink,
    output aluSource,
    output Branch,
    output MemtoReg,
    output AddrTrans,
    output RegWrite,
    output MemWrite,
    output [1:0] EXTCtrl,
    output [2:0] aluCtrl
    );

    wire add,sub,ori,lw,sw,beq,lui,jal;
	 
	 //instr
	 assign add = (opcode == 6'b000000) && (func == 6'b100000);
	 assign sub = (opcode == 6'b000000) && (func == 6'b100010);
	 assign ori = (opcode == 6'b001101);
	 assign lw = (opcode == 6'b100011);
	 assign sw = (opcode == 6'b101011);
	 assign beq = (opcode == 6'b000100);
	 assign lui = (opcode == 6'b001111);
	 assign jal = (opcode == 6'b000011);
	 assign jr = (opcode == 6'b000000) && (func == 6'b001000);

    //out
    assign Jump = jal | jr;
    assign RegDst = add | sub;
    assign raLink = jal;
    assign aluSource = ori | lw | sw | lui;
    assign Branch = beq;
    assign MemtoReg = lw;
    assign AddrTrans = jal;
    assign RegWrite = add | sub | ori | lw | lui | jal;
    assign MemWrite = sw ;
    assign aluCtrl[2] = sub | beq;
    assign aluCtrl[1] = add | sub | lw | sw | beq | lui;
    assign aluCtrl[0] = ori;
    assign EXTCtrl[1] = beq | lui;
    assign EXTCtrl[0] = ori | beq;
endmodule