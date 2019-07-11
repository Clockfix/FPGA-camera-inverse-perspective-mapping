// `timescale [time unit] / [time precision]
`timescale 10 ps / 1 ps

`include "clock_divider_param.v"

module clock_divider_param_tb ();

reg clk = 1'b0;
wire enable;

always #1 clk <= ~clk; 

  initial
  begin
    #100;
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

clock_divider #(
    .DIVIDER(2),
    .WIDTH(2)
  ) test_unit1 (
    .clk(clk),
    .enable(enable)
);



endmodule