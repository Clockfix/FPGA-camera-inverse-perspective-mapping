//
//      Original file donwloaded from nandland.com
//      
//      Outputs byte received from UART
//
//`include "UART_RX.v"
//`include "UART_TX.v"

module UART_Loopback_module #( parameter 
    DATA_WIDTH = 8
)
(   input clk,          // Main Clock
    input loopback,
    input RsRx,         // UART RX Data
    output RsTx,        // UART TX Data
    output [DATA_WIDTH-1:0]   dout,  // data out
    output o_TX_Done,     // high when transition is done
    output o_RX_DV        // data valid
);

wire w_TX_Active, w_TX_Serial;

wire [DATA_WIDTH-1:0] w_RX_Byte;

UART_RX #(.CLKS_PER_BIT(868)) UART_RX_Inst
    (.clk(clk),
     .RsRx(RsRx),
     .o_RX_DV(o_RX_DV),
     .o_RX_Byte(w_RX_Byte));

UART_TX #(.CLKS_PER_BIT(868)) UART_TX_Inst
    (.clk(clk),
     .i_TX_DV(o_RX_DV),
     .i_TX_Byte(w_RX_Byte),
     .o_TX_Active(w_TX_Active),
     .o_TX_Serial(w_TX_Serial),
     .o_TX_Done(o_TX_Done)); 

// drive UART line high when transmiter not active
assign RsTx = (w_TX_Active && loopback) ? w_TX_Serial : 1'b1;

assign dout = w_RX_Byte;

endmodule