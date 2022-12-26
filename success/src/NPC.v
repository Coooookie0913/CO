module NPC (
    //input
    input [31:0] E32,
    input [25:0] imm26,
    input [31:0] pc,
    input [31:0] ra,
    input [1:0] JCtrl,
    input cmp_out,
	 input Req,
    //output
    output [31:0] D_npc
);

    wire [31:0] temp ;
  
    assign temp = (cmp_out) ? (E32 + pc + 4) : //beq
                  (pc + 8);
    
    assign D_npc = (Req) ? 32'h0000_4180 :
	                (JCtrl == 2'b00) ? temp :
                   (JCtrl == 2'b01) ? {pc[31:28],imm26,2'b00} : //不涉及高4位，均为0
                   ra;
  
endmodule