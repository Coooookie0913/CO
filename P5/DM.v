module DM (
    //input
    input clk,
    input reset,
    input MemWrite,
    input [31:0] pc,
    input [31:0] Addr,
    input [31:0] WriteData,
    //output
    output [31:0] RD
);

    reg [31:0] dm[0:3071] ;
    integer i;

    assign RD = dm[Addr[11:2]];//?

    always @(posedge clk ) begin
        if (reset) begin
            for (i = 0; i < 3072; i = i + 1)begin
                dm[i] <= 32'h0000_0000;
            end
        end
        else if (WriteData) begin
            dm[Addr[11:2]] <= WriteData;
            $display("@%h: *%h <= %h",pc,Addr,WriteData);
        end
    end
    
endmodule