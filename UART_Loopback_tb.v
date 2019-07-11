`include "UART_Loopback_module.v"
`include "UART_TX.v"
`include "UART_RX.v"

module UART_Loopback_tb();

reg clk = 1'b1;
reg RsRx;         // UART RX Data
wire RsTx;        // UART TX Data
wire [7:0]   dout;  // data out
wire o_TX_Done;     // high when transition is done
wire o_RX_DV;        // data valid

always #1 clk <= ~clk; 

initial begin
// starting UART transition
    #0 RsRx = 1;
    #1736 RsRx = 0;
    #1736 RsRx = 1;
    #1736 RsRx = 0;
    #1736 RsRx = 1;
    #1736 RsRx = 0;
    #1736 RsRx = 1;
    #1736 RsRx = 0;
    #1736 RsRx = 1;
    #1736 RsRx = 0;
    #1736 RsRx = 1;

    #100_000;
    $finish();
end

initial 
  begin 
    $display(" ");
    $display("----------------------------------------------");
    $display("          Starting Testbench...");
    $dumpfile("wave.vcd");
    $dumpvars(0);
    $display("----------------------------------------------");
    $display(" ");
end

UART_Loopback_module Test_Unit(
    .clk(clk),          
    .RsRx(RsRx),         
    .RsTx(RsTx),        
    .dout(dout),  
    .o_TX_Done(o_TX_Done),     
    .o_RX_DV(o_RX_DV)      
);

endmodule