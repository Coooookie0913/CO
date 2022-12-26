module DipSwitch(
    //input
    input [31:0] Addr,
    input [7:0] dip_switch0,
    input [7:0] dip_switch1,
    input [7:0] dip_switch2,
    input [7:0] dip_switch3,
    input [7:0] dip_switch4,
    input [7:0] dip_switch5,
    input [7:0] dip_switch6,
    input [7:0] dip_switch7,
    //output
    output [31:0] out
);

assign out = (Addr[2] == 1'b0) ? {~dip_switch3,~dip_switch2,~dip_switch1,~dip_switch0} :
             {~dip_switch7,~dip_switch6,~dip_switch5,~dip_switch4} ;

endmodule