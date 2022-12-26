// lw/lh/lhu/lb/lbu
wire [31:0] temp = data_memory[Addr[11:2]] ;
    always @(*) begin
        case(LSOp)
            `LS_LW: read_data = temp;
            `LS_LH: read_data = (Addr[1] == 1'b0) ? {{16{temp[15]}},temp[15:0]} :
                                {{16{temp[31]}},temp[31:16]};
            `LS_LHU: read_data = (Addr[1] == 1'b0) ? {{16{1'b0}},temp[15:0]} :
                                {{16{1'b0}},temp[31:16]};
            `LS_LB: read_data = (Addr[1:0] == 2'b00) ? {{24{temp[7]}},temp[7:0]} :
                                (Addr[1:0] == 2'b01) ? {{24{temp[15]}},temp[15:8]} :
                                (Addr[1:0] == 2'b10) ? {{24{temp[23]}},temp[23:16]} :
                                {{24{temp[31]}},temp[31:24]};
            `LS_LBU: read_data = (Addr[1:0] == 2'b00) ? {{24{1'b0}},temp[7:0]}:
                                 (Addr[1:0] == 2'b01) ? {{24{1'b0}},temp[15:8]}:
                                 (Addr[1:0] == 2'b10) ? {{24{1'b0}},temp[23:16]}:
                                 {{24{1'b0}},temp[31:24]};
            default: read_data = temp;
        endcase
    end

// sw/sh/sb
always @(posedge clk ) begin
    if (reset) begin
        for(i = 0; i < 3072; i = i + 1)begin
            data_memory[i] = 32'h0;
        end
    end
    else if(MemWrite == 1) begin
        case(LSOp)
            `LS_SW: data_memory[Addr[11:2]] <= WriteData;
            `LS_SH: data_memory[Addr[11:2]] <=
            (Addr[1] == 1'b0) ? {temp[31:16],WriteData[15:0]} :
            {WriteData[15:0],temp[15:0]};
            `LS_SB: data_memory[Addr[11:2]] <=
            (Addr[1:0] == 2'b00) ? {temp[31:8],WriteData[7:0]} :
            (Addr[1:0] == 2'b01) ? {temp[31:16],WriteData[7:0],temp[7:0]} :
            (Addr[1:0] == 2'b10) ? {temp[31:24],WriteData[7:0],temp[15:0]} :
            {WriteData[7:0],temp[23:0]};
        default: data_memory[Addr[11:2]] <= data_memory[Addr[11:2]];
        endcase
    else data_memory[Addr[11:2]] <= data_memory[Addr[11:2]];
    end
end

//判断data中的1个数是否为奇数
//某位学长
//类似于VotePlus的做法
wire odd;
reg [31:0] num;
initial begin
    num = 0;
end
integer i;
always @(*) begin
    num = 0;//每次计算的时候num需要清零
    for(i = 0; i < 32; i = i + 1) begin
        if(RegRead1[i] == 1) begin
            num = num + 1;
        end
    end
end
assign odd = num[0];
//我的想法（和奇偶校验做法一样）
wire odd;
assign odd = ^RegRead1;

//“字对齐”输出,即要求必须是4的倍数，而我们原来输出的都是byte的地址
$display$display("@%h: *%h <= %h",pc,{MemAddr[31:2],{2{1'b0}}},WriteData);

//判断data后缀0个数
//while（for不能加break，但是好像可以在循环条件上加上判断？）
reg [31:0] num ;
initial begin
    num = 0;
end
integer i;
always @(*) begin
    num = 0;
    i = 0;//initial
    while ((i < 32) && (RegRead1[i] == 0)) begin
        num = num + 1;
        i = i + 1;
    end
end
//for
always @(*) begin
    num = 0;
    for(i = 0;(i < 32) && (RegRead1[i] == 0); i = i + 1) begin
        num = num + 1;
    end
end

