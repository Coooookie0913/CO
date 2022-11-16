module GRF (
    //input
    input clk,
    input reset,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WriteData,
    input RegWrite,
    input [31:0] pc,
    //output
    output [31:0] RD1,
    output [31:0] RD2
);

reg [31:0] rf [0:31] ;
integer i;

//read
assign RD1 = (A1 == A3 && RegWrite && A1 != 0) ? WriteData : //内部转发
             (A1 != 0) ? rf[A1] :
             32'h0000_0000;
assign RD2 = (A2 == A3 && RegWrite && A2 != 0) ? WriteData ://内部转发
             (A2 != 0) ? rf[A2] :
             32'h0000_0000;

//write
always @(posedge clk ) begin
    if (reset) begin
        for (i = 0; i < 32; i = i + 1) begin
            rf[i] <= 32'h0000_0000;
        end
    end
    else if (RegWrite && (A3 != 0)) begin
        rf[A3] <= WriteData;
        $display("@%h: $%d <= %h",pc,A3,WriteData);
    end
end
endmodule