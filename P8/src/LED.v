module LED (
    //input
    input clk,
    input reset,
    input [3:0] byteen,
    input [31:0] LED_in,
    //output
    output [31:0] LED_light
);
    
    reg [31:0] LED_light_reg;

    always @(posedge clk ) begin
        if (reset) begin
            LED_light_reg <= 32'd0;
        end
        else begin
            if (byteen[0]) LED_light_reg[7:0] <= LED_in[7:0];
            if (byteen[1]) LED_light_reg[15:8] <= LED_in[15:8];
            if (byteen[2]) LED_light_reg[23:16] <= LED_in[23:16];
            if (byteen[3]) LED_light_reg[31:24] <= LED_in[31:24];
        end
    end

    assign LED_light = ~ LED_light_reg;

endmodule