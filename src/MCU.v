module MCU (
    //input
    input [31:0] instr,
    //output
    //D
    output [1:0] RegDst,
    output Branch,
    output [2:0] EXTCtrl,
    output [1:0] JCtrl,
	 output npcSel,
    //E
    output [2:0] ALUCtrl,
    output ALUSrcBSel,
    //M
    output MemWrite,
    output RegWrite,
	 output jal,
    //W
    output [1:0] MemtoReg, 
    //Hazard
    output [1:0] Tuse_rs,
    output [1:0] Tuse_rt,
    output [1:0] D_Tnew,
    output [1:0] E_Tnew,
    output [1:0] M_Tnew
);
    //wire
    wire [5:0] opcode;
    wire [5:0] func;
	 wire add,sub,ori,lw,sw,beq,lui,jr;
    assign opcode = instr[31:26];
	 assign func = instr[5:0];
    	 
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
    assign RegDst[1] = jal;
    assign RegDst[0] = add || sub; 
	 assign EXTCtrl[2] = 1'b0;
    assign EXTCtrl[1] = beq || lui;
    assign EXTCtrl[0] = ori || beq;
    assign Branch = beq;
    assign JCtrl[1] = jr;
    assign JCtrl[0] = jal;
    assign ALUCtrl[2] = sub || beq;
    assign ALUCtrl[1] = add || sub || lw || sw || beq || lui;
    assign ALUCtrl[0] = ori;
    assign ALUSrcBSel = ori || lw || sw || lui ;
    assign MemWrite = sw;
    assign RegWrite = add || sub || ori || lw || lui || jal;
    assign MemtoReg[1] = jal;
    assign MemtoReg[0] = lw;
	 assign npcSel = beq || jal || jr;
    assign Tuse_rs = (jal) ? 2'b11 :
                     (add || sub || ori || lw || sw || lui) ? 2'b01 :
                     2'b00;
    assign Tuse_rt = (ori || lw || lui || jal || jr) ? 2'b11 :
                     (sw) ? 2'b10 :
                     2'b00;
    assign D_Tnew  = (lw) ? 2'b11 :
                     (add || sub || ori || lui) ? 2'b10 :
                     2'b00;
    assign E_Tnew = (lw) ? 2'b10 :
                    (add || sub || ori || lui) ? 2'b01 :
                    2'b00;
    assign M_Tnew = (lw) ? 2'b01 :
                    2'b00;
endmodule