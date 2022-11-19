module E_Reg (
    //input
    input clk,
    input reset,
    input stall,
    input [31:0] D_instr,
    input [4:0] D_A1,
    input [4:0] D_A2,
    input [4:0] D_A3,
    input [31:0] D_V1,
    input [31:0] D_V2,
    input [31:0] D_pc,
    input [31:0] D_pc8,
    input [31:0] D_E32,
    //output
    output [31:0] E_instr,
    output [4:0] E_A1,
    output [4:0] E_A2,
    output [4:0] E_A3,
    output [31:0] E_V1,
    output [31:0] E_V2,
    output [31:0] E_E32,
    output [31:0] E_pc8,
    output [31:0] E_pc
);

    //temp
    reg [31:0] E_instr_reg,E_V1_reg,E_V2_reg,E_E32_reg,E_pc8_reg,E_pc_reg ;
    reg [4:0] E_A1_reg,E_A2_reg,E_A3_reg ;
	 reg [1:0] E_cmp1_Fwd_reg;
	 reg [1:0] E_cmp2_Fwd_reg;
    

    always @(posedge clk ) begin
        if (reset || stall) begin
            E_instr_reg <= 32'h0000_0000;
            E_V1_reg <= 32'h0000_0000;
            E_V2_reg <= 32'h0000_0000;
            E_E32_reg <= 32'h0000_0000;
            E_pc8_reg <= 32'h0000_3008;
            E_pc_reg <= 32'h0000_3000;
            E_A1_reg <= 5'b00000;
            E_A2_reg <= 5'b00000;
            E_A3_reg <= 5'b00000;
        end
        else begin
            E_instr_reg <= D_instr;
            E_V1_reg <= D_V1;
            E_V2_reg <= D_V2;
            E_E32_reg <= D_E32;
            E_pc8_reg <= D_pc8;
            E_pc_reg <= D_pc;
            E_A1_reg <= D_A1;
            E_A2_reg <= D_A2;
            E_A3_reg <= D_A3;
        end
    end

    assign E_instr = E_instr_reg;
    assign E_V1 = E_V1_reg;
    assign E_V2 = E_V2_reg;
    assign E_E32 = E_E32_reg;
    assign E_pc8 = E_pc8_reg;
    assign E_pc = E_pc_reg;
    assign E_A1 = E_A1_reg;
    assign E_A2 = E_A2_reg;
    assign E_A3 = E_A3_reg;

endmodule