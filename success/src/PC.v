module PC (
    //input 
    input clk,
    input reset,
    input stall,
    input [31:0] npc,
	 input Req,
	 input eret,
	 input [31:0] EPC,
    //output
    output [31:0] F_pc8,
	 output [31:0] F_pc4,
    output [31:0] F_pc
);

reg [31:0] temp ;

always @(posedge clk ) begin
    if (reset) begin
        temp <= 32'h0000_3000;
    end
    else if ((!stall) || Req) begin
        temp <= (Req) ? 32'h0000_4180 :
					 npc;
    end
end

assign F_pc = (eret) ? EPC : ( Req ? 32'h0000_4180 : temp);
assign F_pc4 = (eret) ? (EPC + 4) : temp + 4;
assign F_pc8 = (eret) ? (EPC + 8) : temp + 8;
    
endmodule