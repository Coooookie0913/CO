module mips (
    // clock and reset
    input clk_in,
    input sys_rstn,
    // dip switch
    input [7:0] dip_switch0,
    input [7:0] dip_switch1,
    input [7:0] dip_switch2,
    input [7:0] dip_switch3,
    input [7:0] dip_switch4,
    input [7:0] dip_switch5,
    input [7:0] dip_switch6,
    input [7:0] dip_switch7,
    // key
    input [7:0] user_key,
    // led
    output [31:0] led_light,
    // digital tube
    output [7:0] digital_tube2,
    output digital_tube_sel2,
    output [7:0] digital_tube1,
    output [3:0] digital_tube_sel1,
    output [7:0] digital_tube0,
    output [3:0] digital_tube_sel0,
    // uart
    input uart_rxd,
    output uart_txd
);
    
//IM
wire [31:0] i_inst_addr;
wire [31:0] i_inst_rdata;

//DM
wire [31:0] m_data_addr;
wire [31:0] m_data_addr_temp;
wire [31:0] m_data_rdata;
wire [31:0] m_data_rdata_bridge;
wire [31:0] m_data_wdata;
wire [31:0] m_data_wdata_temp;
wire [3:0] m_data_byteen;
wire [3:0] m_data_byteen_temp;

//Timer
wire [31:0] T0_RD;
wire T0_WE;
wire T0_IRQ;

//DigitalTube
wire [3:0] DT_byteen;
wire [31:0] DT_RD;

//UART
wire interrupt;
wire [31:0] UART_RD;
wire [3:0] UART_byteen;
wire cpu_load;
wire cpu_store;

//key
wire [31:0] key_out;

//DipSwitch
wire [31:0] DipSwitch_out;

//LED
wire [3:0] LED_byteen;
wire [31:0] LED_in;

//reset
wire reset;
assign reset = ~sys_rstn;

CPU CPU_mips(
   //input
   .clk(clk_in),
   .reset(reset),
   .interrupt(interrupt),
   .Timer0(T0_IRQ),
   .i_inst_rdata(i_inst_rdata),
   .m_data_rdata(m_data_rdata_bridge),
   //output
   .i_inst_addr(i_inst_addr),
   .m_data_addr(m_data_addr_temp),
   .m_data_wdata(m_data_wdata_temp),
   .m_data_byteen(m_data_byteen_temp),
   .uart_load(uart_load),
   .uart_store(uart_store)
);    

Bridge Bridge_mips(
   //input
	.clk(clk_in),
	.reset(reset),
   .A_in(m_data_addr_temp),
   .WD_in(m_data_wdata_temp),
   .byteen(m_data_byteen_temp),
   .DM_RD(m_data_rdata),
   .T0_RD(T0_RD),
	.UART_RD(UART_RD),
   .DT_RD(DT_RD),
   .Key_RD(key_out),
   .DipSwitch_RD(DipSwitch_out),
   //output
	.RD_out(m_data_rdata_bridge),
   .A_out(m_data_addr),
   .WD_out(m_data_wdata),
   .DM_byteen(m_data_byteen),
   .T0_WE(T0_WE),
   .UART_byteen(UART_byteen),
   .DT_byteen(DT_byteen),
   .LED_byteen(LED_byteen)
);

TC Timer0_mips(
   //input
   .clk(clk_in),
   .reset(reset),
   .Addr(m_data_addr[31:2]),
   .WE(T0_WE),
   .Din(m_data_wdata),
   //output
   .Dout(T0_RD),
   .IRQ(T0_IRQ)
);

wire [31:0] i_inst_addr_fixed;
assign i_inst_addr_fixed = i_inst_addr - 32'h0000_3000;

IM IM_mips(
   //input
   .clka(clk_in),
   .addra(i_inst_addr_fixed[13:2]),
   //output
   .douta(i_inst_rdata)
);

DM DM_mips(
   //input
   .clka(clk_in),
   .wea(m_data_byteen),
   .addra(m_data_addr[13:2]),
   .dina(m_data_wdata),
   //output
   .douta(m_data_rdata)
);

UART UART_mips(
   //input
   .clk(clk_in),
   .reset(reset),
   .rxd(uart_rxd),
   .WD(m_data_wdata),
   .Addr(m_data_addr),
   .byteen(UART_byteen),
   .load(uart_load),
   .store(uart_store),
   //output
   .RD(UART_RD),
   .interrupt(interrupt),
   .txd(uart_txd)
);

DigitalTube DigitalTube_mips(
   //input
   .clk(clk_in),
   .reset(reset),
   .Addr(m_data_addr),
   .DT_byteen(DT_byteen),
   .WD(m_data_wdata),
   //output
   .RD(DT_RD),
   .digital_tube0(digital_tube0),
   .digital_tube_sel0(digital_tube_sel0),
   .digital_tube1(digital_tube1),
   .digital_tube_sel1(digital_tube_sel1),
   .digital_tube2(digital_tube2),
   .digital_tube_sel2(digital_tube_sel2)
);

DipSwitch DipSwitch_mips(
   //input
   .Addr(m_data_addr),
   .dip_switch0(dip_switch0),
   .dip_switch1(dip_switch1),
   .dip_switch2(dip_switch2),
   .dip_switch3(dip_switch3),
   .dip_switch4(dip_switch4),
   .dip_switch5(dip_switch5),
   .dip_switch6(dip_switch6),
   .dip_switch7(dip_switch7),
   //output
   .out(DipSwitch_out)
);

Key Key_mips(
   //input
   .key_in(user_key),
   //output
   .key_out(key_out)
);

LED LED_mips(
   //input
   .clk(clk_in),
   .reset(reset),
   .LED_in(m_data_wdata),
   .byteen(LED_byteen),
   //output
   .LED_light(led_light)
);

endmodule