module MD (
    //input
    input clk,
	 input reset,
    input E_start,
    input [31:0] SrcA,
    input [31:0] SrcB,
    input [3:0] MDCtrl,
    input Req,
    //output
    output [31:0] MDR,
    output in_ready//是否准备好处理新的请求
    );

    reg [31:0] HI;
    reg [31:0] LO;

    wire [1:0] in_op;
    wire in_sign;
    wire in_valid;//是否有新的计算请求等待处理
    wire out_valid;//输出结果是否有效
    wire out_ready;//后级模块是否准备好接收计算结果
    wire [31:0] out_res0,out_res1;

    MulDivUnit MulDivUnit_MD (
        //input
        .clk(clk),
        .reset(reset),
        .in_src0(SrcA),
        .in_src1(SrcB),
        .in_op(in_op),
        .in_sign(in_sign),
        .in_valid(in_valid),
        .out_ready(out_ready),
        //output
        .in_ready(in_ready),
        .out_valid(out_valid),
        .out_res0(out_res0),
        .out_res1(out_res1)
    );

    //sign
    assign in_sign = (MDCtrl == 4'b0000 || MDCtrl == 4'b0010) ? 1'b1 : 1'b0;//mult or div
    //op
    assign in_op = (MDCtrl == 4'b0000 || MDCtrl == 4'b0001) ? 2'b01 : //mult or multu
                   (MDCtrl == 4'b0010 || MDCtrl == 4'b0011) ? 2'b10 : //div or divu
                   2'b00;
    //out_ready
    assign out_ready = 1'b1;
    //in_valid
    assign in_valid = E_start;

    always @(posedge clk ) begin
        if (reset) begin
            HI <= 32'h0000_0000;
            LO <= 32'h0000_0000;
        end
        else if (!Req && (out_valid == 1'b1)) begin//乘除槽计算完毕
            HI <= out_res1;
            LO <= out_res0;
        end
        else if (!Req) begin //M级当前不是Req才可以执行 
            case (MDCtrl)
                4'b0110 : begin//mthi
                    HI <= SrcA;
                end
                4'b0111 : begin//mtlo
                    LO <= SrcA;
                end
                default: ;
            endcase
        end
    end   

	assign MDR = (MDCtrl == 4'b0100) ? HI :
	             (MDCtrl == 4'b0101) ? LO :
				 32'h0000_0000;
    
endmodule