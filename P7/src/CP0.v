`define BD Cause[31]
`define IP Cause[15:10]
`define ExcCode Cause[6:2]
`define IM SR[15:10]
`define IE SR[0]
`define EXL SR[1]

module CP0 (
    //input
    input clk,
    input reset,
    input en, //写使能
    input BDIn, //是否延迟槽指令
    input EXLClr, //复位EXL，eret
    input [4:0] ExcCodeIn, //异常类型
    input [5:0] HWInt, //中断信号
    input [4:0] CP0Addr, //寄存器地址
    input [31:0] CP0In, //CP0写入数据
    input [31:0] vPC, //受害PC
    //output
    output Req, //进入处理程序请求
    output [31:0] EPCout, //EPC的值
    output [31:0] CP0out //CP0读出数据
);

//reg
reg [31:0] EPC,Cause,SR,PrID;

//Req
wire IntReq,ExcReq;
assign IntReq = ((|(`IM & HWInt)) && `IE && (!`EXL)); //Interrupt
assign ExcReq = ((|ExcCodeIn) && (!`EXL)); //Exception
assign Req = IntReq || ExcReq;

//EPC
assign EPCout = (Req) ? ((BDIn) ? (vPC - 4) : vPC) :
                EPC ;

//read
assign CP0out = (CP0Addr == 5'd12) ? SR :
                (CP0Addr == 5'd13) ? Cause :
                (CP0Addr == 5'd14) ? EPC :
                5'd0;

//write
always @(posedge clk ) begin
    if (reset) begin
        EPC <= 32'h0000_0000;
        Cause <= 32'h0000_0000;
        SR <= 32'h0000_0000;
        PrID <= 32'h2137_3293;
    end
    else begin
        if (EXLClr) begin
            `EXL <= 1'b0;
        end

        if (Req) begin //int or exc
            `EXL <= 1'b1;
            `BD <= BDIn;
            `ExcCode <= (IntReq) ? 5'b00000 : ExcCodeIn;
             EPC <= EPCout;
        end
        else if (en) begin //mtc0
            if (CP0Addr == 5'd12) begin
                SR <= CP0In;
            end
            else if (CP0Addr == 5'd14) begin
                EPC <= CP0In;
            end
        end
        `IP <= HWInt;//更新IP域
    end
end
    
endmodule