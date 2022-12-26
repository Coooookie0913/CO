module W_Reg (
    //input
    input clk,
    input reset,
    input [31:0] M_instr,
    input [4:0] M_A3,
    input [31:0] M_AR,
    input [31:0] M_pc8,
    input [31:0] M_pc,
    input [31:0] M_Data,
	 input [1:0] M_loadOp,
	 input [31:0] M_CP0out,
    input Req,
    //output
    output [31:0] W_instr,
    output [4:0] W_A3,
    output [31:0] W_AR,
    output [31:0] W_RD,
    output [31:0] W_pc8,
    output [31:0] W_pc,
    output [31:0] W_Datam,
	 output [1:0] W_loadOp,
	 output [31:0] W_CP0out
);

    //temp
    reg [31:0] W_instr_reg,W_AR_reg,W_pc8_reg,W_pc_reg,W_Datam_reg,W_CP0out_reg ;
    reg [4:0] W_A3_reg;
	 reg [1:0] W_loadOp_reg;
    
    always @(posedge clk ) begin
        if (reset || Req) begin
            W_instr_reg <= 32'h0000_0000;
            W_A3_reg <= 5'b00000;
            W_AR_reg <= 32'h0000_0000;
            W_pc8_reg <= 32'h0000_3008;
            W_pc_reg <= (Req) ? 32'h0000_4180 : 32'h0000_3000;
            W_Datam_reg <= 32'h0000_0000;
			   W_CP0out_reg <= 32'h0000_0000;
				W_loadOp_reg <= 2'b00;
        end
        else begin
            W_instr_reg <= M_instr;
            W_A3_reg <= M_A3;
            W_AR_reg <= M_AR;
            W_pc8_reg <= M_pc8;
            W_pc_reg <= M_pc;
            W_Datam_reg <= M_Data;
			   W_CP0out_reg <= M_CP0out;
				W_loadOp_reg <= M_loadOp;
        end
    end
	 
	 assign W_instr = W_instr_reg;
	 assign W_A3 = W_A3_reg;
	 assign W_AR = W_AR_reg;
	 assign W_pc8 = W_pc8_reg;
	 assign W_pc = W_pc_reg;
	 assign W_Datam = W_Datam_reg;
	 assign W_CP0out = W_CP0out_reg;
	 assign W_loadOp = W_loadOp_reg;
	 
endmodule