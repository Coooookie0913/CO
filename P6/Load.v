module Load (
    //input
    input [31:0] m_data_rdata,
    input [1:0] byte_Addr,
    input [1:0] loadOp,
    //output
    output [31:0] RD
   );
    
    assign RD = (loadOp == 2'b00) ? m_data_rdata :
                ((loadOp == 2'b01) && byte_Addr[1]) ? {{16{m_data_rdata[31]}},m_data_rdata[31:16]} :
                ((loadOp == 2'b01) && (!byte_Addr[1])) ? {{16{m_data_rdata[15]}},m_data_rdata[15:0]} :
                ((loadOp == 2'b10) && (byte_Addr == 2'b11)) ? {{24{m_data_rdata[31]}},m_data_rdata[31:24]} :
                ((loadOp == 2'b10) && (byte_Addr == 2'b10)) ? {{24{m_data_rdata[23]}},m_data_rdata[23:16]} :
                ((loadOp == 2'b10) && (byte_Addr == 2'b01)) ? {{24{m_data_rdata[15]}},m_data_rdata[15:8]} :
                ((loadOp == 2'b10) && (byte_Addr == 2'b00)) ? {{24{m_data_rdata[7]}},m_data_rdata[7:0]} :
					 32'h0000_0000;

endmodule