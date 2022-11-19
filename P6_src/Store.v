module Store (
    //input
    input [3:0] byteen,
    input [31:0] WD_temp,
    //output
    output [31:0] WD
    );
    
    reg [31:0] WD_reg;

    always @(*) begin
        case (byteen)
            4'b1111: WD_reg <= WD_temp;
            4'b1100: WD_reg <= {WD_temp[15:0],16'h0000};
            4'b0011: WD_reg <= {16'h0000,WD_temp[15:0]};
            4'b1000: WD_reg <= {WD_temp[7:0],24'h00_0000};
            4'b0100: WD_reg <= {8'h00,WD_temp[7:0],16'h0000};
            4'b0010: WD_reg <= {16'h0000,WD_temp[7:0],8'h00};
            4'b0001: WD_reg <= {24'h00_0000,WD_temp[7:0]};
            default: WD_reg <= 32'h0000_0000;
        endcase
    end

    assign WD = WD_reg;

endmodule