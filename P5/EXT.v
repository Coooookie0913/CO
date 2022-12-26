module EXT (
    //input
    input [15:0] imm16,
    input [2:0] EXTCtrl,
    //output
    output [31:0] E32
);
    assign E32 = (EXTCtrl == 3'b000) ? {{16{imm16[15]}},imm16} :
                (EXTCtrl == 3'b001) ? {{16{1'b0}},imm16} :
                (EXTCtrl == 3'b010) ? {imm16,{16{1'b0}}} :
                {{14{imm16[15]}},imm16,{2{1'b0}}};
                
endmodule