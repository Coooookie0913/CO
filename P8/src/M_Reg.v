module M_Reg (
    //input
    input clk,
    input reset,
    input [31:0] E_instr,
    input [4:0] E_A2,
    input [4:0] E_A3,
	 input [4:0] E_CP0Addr,
    input [31:0] E_AR,
	 input [31:0] E_MDR,
	 input [31:0] E_Data,
    input [31:0] E_V2,
    input [31:0] E_pc8,
    input [31:0] E_pc,
    input [4:0] E_ExcCode_fixed,
    input E_BD,
    input Req,
    //output
    output [31:0] M_instr,
    output [4:0] M_A2,
    output [4:0] M_A3,
	 output [4:0] M_CP0Addr,
    output [31:0] M_AR,
	 output [31:0] M_MDR,
	 output [31:0] M_Datae,
    output [31:0] M_V2,
    output [31:0] M_pc8,
    output [31:0] M_pc,
    output [4:0] M_ExcCode,
    output M_BD
);

//temp
reg [31:0] M_instr_reg,M_AR_reg,M_MDR_reg,M_V2_reg,M_pc8_reg,M_pc_reg,M_Datae_reg ;
reg [4:0] M_A2_reg,M_A3_reg,M_ExcCode_reg,M_CP0Addr_reg;
reg M_BD_reg;

always @(posedge clk ) begin
    if (reset || Req) begin
        M_instr_reg <= 32'h0000_0000;
        M_A2_reg <= 5'b00000;
        M_A3_reg <= 5'b00000;
        M_AR_reg <= 32'h0000_0000;
		  M_MDR_reg <= 32'h0000_0000;
		  M_Datae_reg <= 32'h0000_0000;
        M_V2_reg <= 32'h0000_0000;
        M_pc8_reg <= 32'h0000_3008;
        M_pc_reg <= (Req) ? 32'h0000_4180 : 32'h0000_3000;
        M_ExcCode_reg <= 5'b00000;
        M_BD_reg <= 1'b0;
		  M_CP0Addr_reg <= 5'b00000;
    end
    else begin
        M_instr_reg <= E_instr;
        M_AR_reg <= E_AR;
		  M_MDR_reg <= E_MDR;
		  M_Datae_reg <= E_Data;
        M_A3_reg <= E_A3;
        M_A2_reg <= E_A2;
        M_V2_reg <= E_V2;
        M_pc8_reg <= E_pc8;
        M_pc_reg <= E_pc;
        M_ExcCode_reg <= E_ExcCode_fixed;
        M_BD_reg <= E_BD;
		  M_CP0Addr_reg <= E_CP0Addr;
    end
end

assign M_instr = M_instr_reg;
assign M_A2 = M_A2_reg;
assign M_A3 = M_A3_reg;
assign M_AR = M_AR_reg;
assign M_MDR = M_MDR_reg;
assign M_Datae = M_Datae_reg;
assign M_V2 = M_V2_reg;
assign M_pc8 = M_pc8_reg;
assign M_pc = M_pc_reg; 
assign M_ExcCode = M_ExcCode_reg;
assign M_BD = M_BD_reg;
assign M_CP0Addr = M_CP0Addr_reg;

endmodule