module ALU (
    //input
    input [31:0] SrcA,
    input [31:0] SrcB,
    input [2:0] ALUCtrl,
    //output
    output [31:0] AR,
    output Overflow
);

    reg [31:0] temp_slt,temp_sltu;
    always @(*) begin
        if ($signed(SrcA) < $signed(SrcB)) begin
            temp_slt <= 32'h0000_0001;
        end
        else begin
            temp_slt <= 32'h0000_0000;
        end
        if ({1'b0,SrcA} < {1'b0,SrcB}) begin
            temp_sltu <= 32'h0000_0001;
        end
        else begin
            temp_sltu <= 32'h0000_0000;
        end
    end

    assign AR = (ALUCtrl == 3'b000) ? (SrcA & SrcB) :
                (ALUCtrl == 3'b001) ? (SrcA | SrcB) :
                (ALUCtrl == 3'b010) ? (SrcA + SrcB) :
                (ALUCtrl == 3'b110) ? (SrcA - SrcB) :
				    (ALUCtrl == 3'b011) ? temp_slt :
				    (ALUCtrl == 3'b100) ? temp_sltu :
                32'h0000_0000;

    //Overflow
    wire [32:0] exSrcA,exSrcB,exAdd,exSub;
    assign exSrcA = {SrcA[31],SrcA};
    assign exSrcB = {SrcB[31],SrcB};
    assign exAdd = exSrcA + exSrcB;
    assign exSub = exSrcA - exSrcB;
    assign Overflow = (ALUCtrl == 3'b010) ? (exAdd[32] != exAdd[31]) :
                      (ALUCtrl == 3'b110) ? (exSub[32] != exSub[31]) :
                      1'b0;
    
endmodule