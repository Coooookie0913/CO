module D_Reg (
    //input
    input [31:0] F_instr,
    input [31:0] F_pc,
    input [31:0] F_pc8,
    input [4:0] F_ExcCode,
    input F_BD,
    input reset,
    input stall,
    input clk,
    input Req,
    //output
    output [31:0] D_instr,
    output [31:0] D_pc8,
    output [31:0] D_pc,
    output [4:0] D_ExcCode,
    output D_BD
);

reg [31:0] D_instr_reg,D_pc8_reg,D_pc_reg ;
reg [4:0] D_ExcCode_reg ;
reg D_BD_reg;

always @(posedge clk ) begin
    if (reset || Req) begin
        D_instr_reg <= 32'h0;
        D_pc8_reg <= 32'h0000_3008;
        D_pc_reg <= (Req) ? 32'h0000_4180 : 32'h0000_3004;
        D_ExcCode_reg <= 5'd0;
        D_BD_reg <= 1'b0;
    end
    else if (!stall) begin
        D_instr_reg <= F_instr;
        D_pc8_reg <= F_pc8;
        D_pc_reg <= F_pc;
        D_ExcCode_reg <= F_ExcCode;
        D_BD_reg <= F_BD;
    end
end

assign D_instr = D_instr_reg;
assign D_pc8 = D_pc8_reg;
assign D_pc = D_pc_reg;
assign D_ExcCode = D_ExcCode_reg;
assign D_BD = D_BD_reg;
    
endmodule