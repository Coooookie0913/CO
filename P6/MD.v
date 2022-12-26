module MD (
    //input
    input clk,
	 input reset,
    input E_start,
    input [31:0] SrcA,
    input [31:0] SrcB,
    input [3:0] MDCtrl,
    //output
    output [31:0] MDR,
    output busy
    );

    reg [31:0] HI,HI_temp;
    reg [31:0] LO,LO_temp;
    reg [31:0] cnt;
    reg [31:0] max;
	 reg [31:0] busy_reg;

    always @(posedge clk ) begin
        if (reset) begin
            HI <= 32'h0000_0000;
            HI_temp <= 32'h0000_0000;
            LO <= 32'h0000_0000;
            LO_temp = 32'h0000_0000;
            cnt <= 32'h0000_0000;
            max <= 32'h0000_0000;
				busy_reg <= 32'h0000_0000;
        end
        else if (E_start) begin //E级需要进行乘除法运算
            case (MDCtrl)
                4'b0000 : begin
                    {HI_temp,LO_temp} <= $signed (SrcA) * $signed (SrcB) ;
                    max <= 5;
                end
                4'b0001 : begin
                    {HI_temp,LO_temp} <= $unsigned (SrcA) * $unsigned (SrcB) ;
                    max <= 5;
                end
                4'b0010 : begin
                    LO_temp <= $signed (SrcA) / $signed (SrcB) ;
                    HI_temp <= $signed (SrcA) % $signed (SrcB) ;
                    max <= 10;
                end
                4'b0011 : begin
                    LO_temp <= $unsigned (SrcA) / $unsigned (SrcB);
                    HI_temp <= $unsigned (SrcA) % $unsigned (SrcB);
                    max <= 10;
                end
                default: ;
            endcase
        end
        else begin
            case (MDCtrl)
                4'b0110 : begin
                    HI <= SrcA;
						  HI_temp <= SrcA;
                end
                4'b0111 : begin
                    LO <= SrcA;
						  LO_temp <= SrcA;
                end
                default: ;
            endcase
        end
    end   

    always @(posedge clk ) begin
        if (E_start) begin
            busy_reg <= 1'b1;
            cnt <= 1;
        end
        else if ((!E_start) && (cnt == max) && busy_reg) begin
            busy_reg <= 0;
            cnt <= 0;
            HI <= HI_temp;
            LO <= LO_temp;
        end
        else if((!E_start) && (cnt >= 1) && busy_reg) begin
            cnt <= cnt + 1;
        end
		  else begin
		      cnt <= 0;
		  end
    end 
	 
	 assign busy = busy_reg;
	 assign MDR = (MDCtrl == 4'b0100) ? HI :
	              (MDCtrl == 4'b0101) ? LO :
					  32'h0000_0000;
    
endmodule