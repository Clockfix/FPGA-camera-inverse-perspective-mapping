// This file is Test Bench for top_vga_mem module
//  
// 

// 100MHz clock on Basys3 -> 10ns period
// 50% duty cycle 5ns HIGH and 5ns LOW
//`timescale [time unit] / [time precision]
`timescale 10 ns / 1ns

//sub modules
`include "clock_divider_param.v"
`include "clock_enable_param.v"
`include "blockram.v"
`include "pattern_gen.v"
`include "vga_module.v"
`include "horizontal_counter.v"
`include "vertical_counter.v"
`include "UART_Loopback_module.v"
`include "UART_TX.v"
`include "UART_RX.v"
`include "7segment.v"
`include "com_to_mem_FSM_hex.v" 
`include "com_to_mem_module.v"
`include "ov7670_top.v"
`include "debounce_switch.v"
`include "ov7670_capture.v"
`include "ov7670_controller.v"
`include "imag_procesor.v"
`include "default_reg_writer.v"
`include "i2c_sender.v"
`include "ov7670_registers.v"
`include "imag_save.v" 
`include "rgb2gray.v" 
`include "imag_transform.v"
`include "reg_reader.v"
`include "address_gen.v"
`include "overlay.v"
`include "two_cam_one_screen.v"
`include "lookuptable.v"

//top module
`include "top.v"

module top_vga_mem_tb#( parameter
    WAIT = 1,
    WAIT_WIDTH = 2,
    SPEED = 2,
     //memory parameters
    ADDR_WIDTH = 17, //19, // 
    DATA_WIDTH = 12, 
    DEPTH =  307_200//76_800, // 
)();

reg clk = 1'b0;
reg pclk = 1'b0;
reg hs = 1'b0;
reg vs = 1'b0;

// 50% duty cycle clock
always #0.5 clk <= ~clk;
always #2 pclk <= ~pclk;
always #100 hs <= 1;
always #102 hs <= 0;
always #200 vs <= 1;
always #202 vs <= 0;

reg RsRx;
wire RsTx;

top_vga_mem #(
    .SPEED(SPEED),
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .DEPTH(DEPTH)
)Test_Unit(
    .clk(clk), 
    .RsRx(RsRx),
    .RsTx(RsTx),
    .sw(3'b101),
    .ov7670_cam1_pclk(pclk),
    .ov7670_cam2_pclk(pclk),
    .ov7670_cam1_vs(vs),
    .ov7670_cam1_hs(hs),
    .ov7670_cam2_vs(vs),
    .ov7670_cam2_hs(hs),
    .im_p(9'b00_01_01_000)  
);

initial begin
// starting UART transition
// h70  ->  P
    #0 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 0;
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

// h63  ->  c
    #9000;
    #0 RsRx = 1;
    #868 RsRx = 0;

    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;
    #868 RsRx = 0;

    #868 RsRx = 0;
    #868 RsRx = 1;
    #868 RsRx = 1;
    #868 RsRx = 0;

    #868 RsRx = 1;

// h38  ->  8
    #9000;
    #0 RsRx = 1;
    #868 RsRx = 0;

    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 0;
    #868 RsRx = 1;

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

end


initial begin
    #000_001;
    $display("*");
    #030_000; 
    $display("*");
    #030_000; 
    $display("*");
    #030_000; 
    $display("*");
    #030_000; 
    $display("*");
    #030_000; 
    $display("*");
    #030_000; 
    $display("*");
    #030_000; 
    $display("*");
    #030_000; 
    $display("*");
    #030_000; 
    $display("*");
    #030_000; 
    $display("*");
    #030_000; 
    $display("*");
    #030_000; 
    $display("*");
    #030_000; 
    $display("*");
    #030_000; 
    $display("*");
    #030_000; 
    $display("*");
    #030_000; 
    $display("*");
    #030_000; 
    $display("*");
    #030_000; 
    $display("*");
    #030_000; 
    $display("*");

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

endmodule