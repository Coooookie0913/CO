module NPC (
    //input
    input [31:0] E32,
    input [25:0] imm26,
    input [31:0] pc,
    input [31:0] ra,
    input [1:0] JCtrl,
    input cmp_out,
    //output
    output [31:0] npc
);

    wire [31:0] temp ;
  
    assign temp = (cmp_out) ? (E32 + pc + 4) :
                  (pc + 4);
    
    assign npc = (JCtrl == 2'b00) ? temp :
                 (JCtrl == 2'b01) ? {pc[31:28],imm26,2'b00} :
                 ra;
  
endmodule