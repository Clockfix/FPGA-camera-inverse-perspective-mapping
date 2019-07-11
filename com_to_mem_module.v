//      This module is based on Top module: com_to_mem_top.v
//      recive comand, addres and data by 
//      UART and write information in Block RAM

//`include "clock_divider_param.v"
//`include "clock_enable_param.v"
//`include "7segment_v2.v"
//`include "com_to_mem_FSM.v" 
//`include "UART_Loopback_module.v"

module com_to_mem #( parameter
    WAIT = 1,
    WAIT_WIDTH = 2,
    ADDR_WIDTH = 17, 
    DATA_WIDTH = 8, 
    DEPTH =  76_800
)(
    input clk,
    input sw,
    input i_enable,
    // input [DATA_WIDTH-1:0] i_data_rd,
    input RsRx,         // UART RX Data
    output RsTx,        // UART TX Data
    output  [6:0] seg, 
    output  [3:0] an,   
//    output        dp,
    output [ADDR_WIDTH-1:0] o_addr_wr,
    output [ADDR_WIDTH-1:0] o_addr_rd,
    output [DATA_WIDTH-1:0] o_data_wr,
    output o_write ,
    output [6:0]            o_addr_wr_reg,
    output [24:0]           o_data_reg,
    output                  o_we_reg
       );

wire clk10k;
wire [7:0] w_dout;
wire w_RX_DV;
wire w_TX_Done;
wire [3:0] w_state;
wire [3:0] w_byte;

//------ instatiated modules ---------------------------

com_to_mem_FSM #(
    .ADDR_WIDTH(ADDR_WIDTH), 
    .DATA_WIDTH(DATA_WIDTH), 
    .DEPTH(DEPTH)
) FSM1(
    .clk(clk),
    .i_enable(i_enable),
    .din(w_dout),
    .TX_Done(w_TX_Done), 
    .i_RX_DV(w_RX_DV),
    .addr_wr(o_addr_wr),
    .addr_rd(o_addr_rd),
    .data_wr(o_data_wr),
    .write(o_write),
    .o_state(w_state),
    .o_byte(w_byte),
    .o_addr_wr_reg(o_addr_wr_reg),
    .o_data_reg(o_data_reg),
    .o_we_reg(o_we_reg)
);


bin_7segment bin_7segment1(
    .clk(clk10k),  
    .sw({w_state, w_byte, w_dout}),   
    .seg(seg),  
    .an(an),   
    .dp());

UART_Loopback_module #( 
    .DATA_WIDTH('d8)
) UART_Loopback_module1
(   .clk(clk), 
    .loopback(sw),         
    .RsRx(RsRx),         
    .RsTx(RsTx),        
    .dout(w_dout),  
    .o_TX_Done(w_TX_Done),
    .o_RX_DV(w_RX_DV));

clock_divider #(
    .DIVIDER(1_000),
    .WIDTH(24)
) clock_divider7seg (
    .clk(clk),
    .clk_out(clk10k)
);



endmodule