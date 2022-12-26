module D_Reg (
    //input
    input [31:0] F_instr,
    input [31:0] F_pc,
    input [31:0] F_pc8,
    input reset,
    input stall,
    input clk,
    //output
    output [31:0] D_instr,
    output [31:0] D_pc8,
    output [31:0] D_pc
);

reg [31:0] D_instr_reg,D_pc8_reg,D_pc_reg ;

always @(posedge clk ) begin
    if (reset) begin
        D_instr_reg <= 32'h0;
        D_pc8_reg <= 32'h0000_3008;
        D_pc_reg <= 32'h0000_3000;
    end
    else if (!stall) begin
        D_instr_reg <= F_instr;
        D_pc8_reg <= F_pc8;
        D_pc_reg <= F_pc;
    end
end

assign D_instr = D_instr_reg;
assign D_pc8 = D_pc8_reg;
assign D_pc = D_pc_reg;
    
endmodule