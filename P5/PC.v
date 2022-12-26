module PC (
    //input 
    input clk,
    input reset,
    input stall,
    input [31:0] npc,
    //output
    output [31:0] F_pc8,
    output [31:0] F_pc
);

reg [31:0] temp ;

always @(posedge clk ) begin
    if (reset) begin
        temp <= 32'h0000_3000;
    end
    else if (!stall) begin
        temp <= npc;
    end
    //stall则temp的值不改变
    //是否会出现锁存器？如何解决？
end

assign F_pc = temp;
assign F_pc8 = temp + 8;
    
endmodule