module ALU (
    //input
    input [31:0] SrcA,
    input [31:0] SrcB,
    input [2:0] ALUCtrl,
    //output
    output [31:0] AR
);
    
    assign AR = (ALUCtrl == 3'b000) ? (SrcA & SrcB) :
                (ALUCtrl == 3'b001) ? (SrcA | SrcB) :
                (ALUCtrl == 3'b010) ? (SrcA + SrcB) :
                (ALUCtrl == 3'b110) ? (SrcA - SrcB) :
                32'h0000_0000;
    
endmodule