module CMP (
    //input
    input [31:0] r1,
    input [31:0] r2,
    input [1:0] D_Branch,
    //output
    output cmp_out
);

    assign cmp_out = ((r1 == r2) && (D_Branch == 2'b01)) ? 1'b1 : 
                     ((r1 != r2) && (D_Branch == 2'b10)) ? 1'b1 :
                     1'b0;

endmodule