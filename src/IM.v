module IM (
    //input 
    input [31:0] F_pc,
    //output
    output [31:0] F_instr
);

reg [31:0] rom [0:4095] ;
wire [11:0] addr;
wire [31:0] temp ;

initial begin
    $readmemh("code.txt",rom);
end

assign temp = F_pc - 32'h0000_3000;
assign addr = temp[13:2];
assign F_instr = rom[addr];
    
endmodule