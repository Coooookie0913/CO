module MCU (
    //input
    input [31:0] instr,
	 input [31:0] M_AR,
    //output
    //D
    output [1:0] RegDst,
    output [1:0] Branch,
    output [2:0] EXTCtrl,
    output [1:0] JCtrl,
	 output npcSel,
    output start,
    output MD,
	 output mf,
    //E
    output [2:0] ALUCtrl,
    output [3:0] MDCtrl,
    output ALUSrcBSel,
    //M
    output MemWrite,
    output RegWrite,
	 output jal,
    output [3:0] byteen,
    output [1:0] loadOp,
    //W
    output [1:0] MemtoReg, 
    //Hazard
    output [1:0] Tuse_rs,
    output [1:0] Tuse_rt,
    output [1:0] D_Tnew,
    output [1:0] E_Tnew,
    output [1:0] M_Tnew,
    //Exception
    output RI,
    output EXLClr,
    output CP0WE,
    output OvCalInstr,
    output OvLoadInstr,
    output OvSaveInstr,
    output lw,
    output sw,
    output lh,
    output sh,
    output lb,
    output sb,
    output eret,
    output syscall,
    output mfc0,
    output mtc0
);
    //wire
    wire [5:0] opcode;
    wire [5:0] func;
	 wire [4:0] special;
	 wire lui,jr;
    wire add,sub,and1,or1,slt,sltu;
    wire cal_r;
    wire ori,addi,andi;
    wire cal_i;
    wire beq,bne;
    wire B;
    //wire sb,sh,sw;
    wire store;
    //wire lb,lh,lw;
    wire load;
    wire mult,multu,div,divu;
    wire md;
    wire mfhi,mflo;
    wire mthi,mtlo;
    wire mt;
    assign opcode = instr[31:26];
	 assign func = instr[5:0];
    assign special = instr[25:21];
    	 
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
    assign and1 = (opcode == 6'b000000) && (func == 6'b100100);
    assign or1 = (opcode == 6'b000000) && (func == 6'b100101);
    assign slt = (opcode == 6'b000000) && (func == 6'b101010);
    assign sltu = (opcode == 6'b000000) && (func == 6'b101011);
    assign addi = (opcode == 6'b001000);
    assign andi = (opcode == 6'b001100);
    assign bne = (opcode == 6'b000101);
    assign sb = (opcode == 6'b101000);
    assign sh = (opcode == 6'b101001);
    assign lb = (opcode == 6'b100000);
    assign lh = (opcode == 6'b100001);
    assign mult = (opcode == 6'b000000) && (func == 6'b011000);
    assign multu = (opcode == 6'b000000) && (func == 6'b011001);
    assign div = (opcode == 6'b000000) && (func == 6'b011010);
    assign divu = (opcode == 6'b000000) && (func == 6'b011011);
    assign mfhi = (opcode == 6'b000000) && (func == 6'b010000);
    assign mflo = (opcode == 6'b000000) && (func == 6'b010010);
    assign mthi = (opcode == 6'b000000) && (func == 6'b010001);
    assign mtlo = (opcode == 6'b000000) && (func == 6'b010011);
    assign eret = (opcode == 6'b010000) && (func == 6'b011000);
    assign syscall = (opcode == 6'b000000) && (func == 6'b001100);
    assign mtc0 = (opcode == 6'b010000) && (special == 5'b00100);
    assign mfc0 = (opcode == 6'b010000) && (special == 5'b00000);

    //sort
    assign cal_r = add || sub || and1 || or1 || slt || sltu ; 
    assign cal_i = addi || andi || ori || lui;
    assign B = beq || bne;
    assign load = lb || lh || lw;
    assign store = sb || sh || sw;
    assign md = mult || multu || div || divu;
    assign mf = mfhi || mflo;
    assign mt = mthi || mtlo;

    //out
    assign RegDst[1] = jal;
    assign RegDst[0] = cal_r || mf || mtc0; 
	 assign EXTCtrl[2] = 1'b0;
    assign EXTCtrl[1] = B || lui;
    assign EXTCtrl[0] = andi || ori || B;
    assign Branch[1] = bne;
    assign Branch[0] = beq;
    assign JCtrl[1] = jr;
    assign JCtrl[0] = jal;
    assign ALUCtrl[2] = sub || sltu ;
    assign ALUCtrl[1] = add || sub || load || store || lui || slt || addi ;
    assign ALUCtrl[0] = ori || or1 || slt ;
    assign ALUSrcBSel = cal_i || load || store ;
    assign MemWrite = store;
    assign RegWrite = cal_r || cal_i || load || jal || mf || mfc0;
	 assign MemtoReg[1] = mfc0;
    assign MemtoReg[0] = load;
	 assign npcSel = B || jal || jr;
    assign byteen = (sw) ? 4'b1111 :
                    (sh && M_AR[1]) ? 4'b1100 :
                    (sh && (!M_AR[1])) ? 4'b0011 :
                    (sb && (M_AR[1:0] == 2'b11)) ? 4'b1000 :
                    (sb && (M_AR[1:0] == 2'b10)) ? 4'b0100 :
                    (sb && (M_AR[1:0] == 2'b01)) ? 4'b0010 :
                    (sb && (M_AR[1:0] == 2'b00)) ? 4'b0001 :
						  4'b0000;
    assign loadOp = (lw) ? 2'b00 :
                    (lh) ? 2'b01 :
                    (lb) ? 2'b10 :
						  2'b11;
						  
    assign MDCtrl[3] = 1'b0;
    assign MDCtrl[2] = mf || mt ;
    assign MDCtrl[1] = div || divu || mthi || mtlo ;
    assign MDCtrl[0] = multu || divu || mflo || mtlo ; 
    assign start = md;
    assign MD = md || mf || mt;

    //Exception
    assign EXLClr = eret;
    assign CP0WE = mtc0;
    assign OvCalInstr = add || sub || addi;
    assign OvLoadInstr = lw || lh || lb;
    assign OvSaveInstr = sw || sh || sb;
    assign RI = !(cal_r || cal_i || B || load || store || md || mf || mt || jal || jr || eret || mtc0 || mfc0 || syscall || (instr == 32'h0000_0000));

    //Hazard
    assign Tuse_rs = (jal || mf || mtc0 || mfc0) ? 2'b11 :
                     (cal_r || cal_i || load || store || md) ? 2'b01 :
                     2'b00;
    assign Tuse_rt = (cal_i || load || jal || jr || mf || mfc0) ? 2'b11 :
                     (store || mtc0) ? 2'b10 :
					      (cal_r || md) ? 2'b01 :
                     2'b00;
    assign D_Tnew  = (load || mfc0) ? 2'b11 :
                     (cal_r || cal_i || mf) ? 2'b10 :
                     2'b00;
    assign E_Tnew = (load || mfc0) ? 2'b10 :
                    (cal_r || cal_i || mf) ? 2'b01 :
                    2'b00;
    assign M_Tnew = (load || mfc0) ? 2'b01 :
                    2'b00;
endmodule