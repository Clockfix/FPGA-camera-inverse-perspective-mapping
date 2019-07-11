// This file is Test Bench for top_vga_mem module
//  
// 
// 25MHz clock input from top module
// 50% duty cycle 20ns HIGH and 20ns LOW
//`timescale [time unit] / [time precision]
`timescale 10 ns / 10ns

//sub modules
`include "i2c_senderv2.v"
`include "debounce_switch.v"
`include "ov7670_capture.v"
`include "ov7670_registers.v" 
`include "ov7670_controller.v"
//top module
`include "ov7670_top.v"


module ov7670_top_tb();

//--------Internal register-----------

reg clk = 1'b0;

reg reset = 1'b0;
reg send_enable = 1'b0;

// bidirectional test bench 
// source:
// https://stackoverflow.com/questions/31391112/bidirectional-port-in-verilog-testbench
wire  input_value;
wire  bidir_signal;
reg   output_value;
reg   output_value_valid;
reg   btn_reg=0;

assign input_value = bidir_signal;
assign bidir_signal = (output_value_valid==1'b1)? output_value : 1'hZ;

//---------Test script----------------
// 50% duty cycle clock
always #2 clk <= ~clk;

//-----Unit Under test---------------
ov7670_top #(
    
)Test_Unit(
    .clk(clk),
    .btn(btn_reg),
    .ov7670_pclk(),
    .ov7670_mclk(),
    .ov7670_vs(),
    .ov7670_hs(),
    .ov7670_data(),
    .ov7670_scl(),
    .ov7670_sda(bidir_signal),
    .ov7670_pwdn(),
    .ov7670_reset() 
);


// first ACK signal
initial
  begin
    #0 output_value = 0;
    output_value_valid = 0;
    #8902 output_value = 0;
    output_value_valid = 0;
    #600 output_value = 0;
    output_value_valid = 0;
  end
// second ACK signal
initial
  begin
    #16_102 output_value = 0;
    output_value_valid = 0;
    #600 output_value = 0;
    output_value_valid = 0;
  end
// therd ACK signal
initial
  begin
    #23_302 output_value = 0;
    output_value_valid = 0;
    #600 output_value = 0;
    output_value_valid = 0;
  end

initial 
  begin 
    #0 btn_reg = 0;
    #10_000 btn_reg = 1;
    #10000 btn_reg = 0;
    #50000; 
    $display("*");

    #0 btn_reg = 0;
    #10_000 btn_reg = 1;
    #20000000 btn_reg = 0;
    #5000000; 
    $display("*");


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