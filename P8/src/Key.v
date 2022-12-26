module Key (
    input [7:0] key_in,
    output [31:0] key_out
);
    assign key_out = {24'd0,~key_in};
endmodule