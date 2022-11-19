module HCU (
    //input
    input [1:0] Tuse_rs,
    input [1:0] Tuse_rt,
    input [1:0] E_Tnew,
    input [1:0] M_Tnew,
	input E_RegWrite,
	input M_RegWrite,
	input W_RegWrite,
    input [4:0] D_A1,
    input [4:0] D_A2,
    input [4:0] E_A1,
    input [4:0] E_A2,
    input [4:0] E_A3,
    input [4:0] M_A2,
    input [4:0] M_A3,
    input [4:0] W_A3,
    input D_MD,
    input E_busy,
    input E_start,
    //output
    output stall,
    output [1:0] cmp1_Fwd,
    output [1:0] cmp2_Fwd,
    output [1:0] ALUa_Fwd,
    output [1:0] ALUb_Fwd,
    output DM_Fwd
);
    //W_Tnew = 2'b00
	 wire [1:0] W_Tnew;
	 assign W_Tnew = 2'b00;
	 
    //stall
    //stall_rs
    wire stall_rs0_e1,stall_rs0_e2,stall_rs0_m1,stall_rs1_e2;
    assign stall_rs0_e1 = (Tuse_rs == 2'b00) && (E_Tnew == 2'b01) && (D_A1 == E_A3) && (D_A1 != 5'b00000) && E_RegWrite;
    assign stall_rs0_e2 = (Tuse_rs == 2'b00) && (E_Tnew == 2'b10) && (D_A1 == E_A3) && (D_A1 != 5'b00000) && E_RegWrite;
    assign stall_rs0_m1 = (Tuse_rs == 2'b00) && (M_Tnew == 2'b01) && (D_A1 == M_A3) && (D_A1 != 5'b00000) && M_RegWrite;
    assign stall_rs1_e2 = (Tuse_rs == 2'b01) && (E_Tnew == 2'b10) && (D_A1 == E_A3) && (D_A1 != 5'b00000) && E_RegWrite;
    //stall_rt
    wire stall_rt0_e1,stall_rt0_e2,stall_rt0_m1,stall_rt1_e2;
    assign stall_rt0_e1 = (Tuse_rt == 2'b00) && (E_Tnew == 2'b01) && (D_A2 == E_A3) && (D_A2 != 5'b00000) && E_RegWrite;
    assign stall_rt0_e2 = (Tuse_rt == 2'b00) && (E_Tnew == 2'b10) && (D_A2 == E_A3) && (D_A2 != 5'b00000) && E_RegWrite;
    assign stall_rt0_m1 = (Tuse_rt == 2'b00) && (M_Tnew == 2'b01) && (D_A2 == M_A3) && (D_A2 != 5'b00000) && M_RegWrite;
    assign stall_rt1_e2 = (Tuse_rt == 2'b01) && (E_Tnew == 2'b10) && (D_A2 == E_A3) && (D_A2 != 5'b00000) && E_RegWrite;
    //stall_MD
    wire stall_MD;
    assign stall_MD = D_MD && (E_busy || E_start);
    //stall
    wire stall_rs,stall_rt;
    assign stall_rs = stall_rs0_e1 || stall_rs0_e2 || stall_rs0_m1 || stall_rs1_e2;
    assign stall_rt = stall_rt0_e1 || stall_rt0_e2 || stall_rt0_m1 || stall_rt1_e2;
    assign stall = stall_rs || stall_rt || stall_MD;

    //Hazard
    assign cmp1_Fwd = ((D_A1 == E_A3) && (D_A1 != 5'b00000) && (E_Tnew == 2'b00) && E_RegWrite) ? 2'b10:
	                   ((D_A1 == M_A3) && (D_A1 != 5'b00000) && (M_Tnew == 2'b00) && M_RegWrite) ? 2'b01 :
                      2'b00;
    assign cmp2_Fwd = ((D_A2 == E_A3) && (D_A2 != 5'b00000) && (E_Tnew == 2'b00) && E_RegWrite) ? 2'b10:
	                   ((D_A2 == M_A3) && (D_A2 != 5'b00000) && (M_Tnew == 2'b00) && M_RegWrite) ? 2'b01 :
                      2'b00;
    assign ALUa_Fwd = ((E_A1 == M_A3) && (E_A1 != 5'b00000) && (M_Tnew == 2'b00) && M_RegWrite ) ? 2'b10 :
                      ((E_A1 == W_A3) && (E_A1 != 5'b00000) && (W_Tnew == 2'b00) && W_RegWrite) ? 2'b01 :
                      2'b00;
    assign ALUb_Fwd = ((E_A2 == M_A3) && (E_A2 != 5'b00000) && (M_Tnew == 2'b00) && M_RegWrite ) ? 2'b10 :
                      ((E_A2 == W_A3) && (E_A2 != 5'b00000) && (W_Tnew == 2'b00) && W_RegWrite) ? 2'b01 :
                      2'b00;
    assign DM_Fwd = ((M_A2 == W_A3) && (M_A2 != 5'b00000) && (W_Tnew == 2'b00) && W_RegWrite) ? 1'b1 : 1'b0;
endmodule