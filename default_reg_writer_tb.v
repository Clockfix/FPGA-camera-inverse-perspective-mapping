// This file is Test Bench for top_vga_mem module
//  
// 

// 100MHz clock input from top module
// 50% duty cycle 5ns HIGH and 5ns LOW
//`timescale [time unit] / [time precision]
`timescale 10 ns / 1ns

//sub modules
`include "clock_enable_param.v" 
//top module
`include "default_reg_writer.v"

module default_reg_writer_tb();

//--------Internal register-----------

reg clk = 1'b0;
wire w_enable;
reg reset = 0;

//---------Test script----------------
// 50% duty cycle clock
always #0.5 clk <= ~clk;

//-----Unit Under test---------------
default_reg_writer uut_sender(
    .clk(clk),
    .i_enable(w_enable),
    .i_reset(reset)
);

clock_enable_param #(
//    .WAIT(WAIT),
//    .WIDTH(WAIT_WIDTH)
  ) clock_enable1 (
    .clk(clk),
    .enable(w_enable)
);

initial 
  begin 
    #0_500; 
    $display("*");
    reset = 1;
    #0_020;
    reset = 0;
    #0_500; 

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