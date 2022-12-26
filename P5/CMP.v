module CMP (
    //input
    input [31:0] r1,
    input [31:0] r2,
    input D_Branch,
    //output
    output cmp_out
);

    assign cmp_out = ((r1 == r2) && D_Branch) ? 1'b1 : 1'b0;

endmodule