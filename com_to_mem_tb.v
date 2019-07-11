// This file is Test Bench for UART to memory module
// its simulates UART comands sent to FPGA to 
// write in memmory address value.

// 100MHz clock on Basys3 -> 10ns period
// 50% duty cycle 5ns HIGH and 5ns LOW
//`timescale [time unit] / [time precision]
`timescale 10 ns / 1ns

`include "UART_Loopback_module.v"
`include "UART_TX.v"
`include "UART_RX.v"
`include "clock_divider_param.v"
`include "clock_enable_param.v"
`include "bram.v"
`include "7segment.v"
`include "com_to_mem_FSM_hex.v" 

`include "com_to_mem_top.v"

module com_to_mem_tb();

reg clk = 1'b1;
reg RsRx;         // UART RX Data
wire RsTx;        // UART TX Data
wire [15:0] led;
wire  [6:0] seg; 
wire  [3:0] an; 
reg sw=1'b1;  
//wire  dp;

// 50% duty cycle clock
always #0.5 clk <= ~clk; 

initial begin
// starting UART transition
// h70  ->  p
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
// h30  ->  0
    #9000;
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;

// h30  ->  0
    #9000;
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;

// h30  ->  0
    #9000;
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;

// h35  ->  5
    #9000;
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;

// h35  ->  5
    #9000;
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;

// h32  ->  2
    #9000;
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;

// h35  ->  5
    #9000;
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;

// h35  ->  5
    #9000;
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;

    #10_000;

// h72  ->  r
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
// h30  ->  0
    #9000;
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;

// h30  ->  0
    #9000;
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;

// h30  ->  0
    #9000;
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;


// h35  ->  5
    #9000;
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;

// h35  ->  5
    #9000;
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;

 #10_000;

// h70  ->  p
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
// h30  ->  0
    #9000;
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;

// h30  ->  0
    #9000;
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;

// h30  ->  0
    #9000;
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;

// h35  ->  5
    #9000;
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;

// h35  ->  5
    #9000;
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;

// h32  ->  2
    #9000;
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;

// h35  ->  5
    #9000;
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;

// h35  ->  5
    #9000;
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;

    #10_000;

// h72  ->  r
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
// h30  ->  0
    #9000;
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;

// h30  ->  0
    #9000;
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;

// h30  ->  0
    #9000;
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;

// h35  ->  5
    #9000;
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;

// h35  ->  5
    #9000;
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;

    #10_000;


    $display(" ");
    $display("Use this command to open timing diagram:");
    $display("gtkwave -f wave.vcd");
    $display("----------------------------------------------");
    $finish();
end

initial 
  begin 
    $display(" ");
    $display("----------------------------------------------");
    $display("          Starting Testbench...");
    $dumpfile("wave.vcd");
    $dumpvars(0);

end

top Test_Unit(
    .clk(clk),
    .sw(sw),          
    .RsRx(RsRx),         
    .RsTx(RsTx),        
    .led(led),  
    .seg(seg),  
    .an(an)//,   
//    .dp(dp)      
);

endmodule