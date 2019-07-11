`include "7segment.v"

module bin_7segment_tb();

reg clk = 1'b0;
reg [15:0]  sw = 'b0;
wire [6:0]   seg;
wire [3:0]   an;
wire dp;

always #1 clk <= ~clk; 

always #40 sw <= sw + 1;

  initial
  begin
    #1000;
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

bin_7segment test_unit1(
    .clk(clk),
    .sw(sw),
    .seg(seg),
    .an(an),
    .dp(dp)
);



endmodule