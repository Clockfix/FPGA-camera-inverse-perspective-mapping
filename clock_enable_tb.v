`include "clock_enable_param.v"

module clock_enable_tb();

reg clk = 1'b0;
wire enable0;
wire enable1;
wire enable2;
wire enable3;

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

clock_enable_param test_unit0(
    .clk(clk),
    .enable(enable0)
);

clock_enable_param #(
    .WAIT(2),
    .WIDTH(4)
   ) test_unit1(
    .clk(clk),
    .enable(enable1)
);

clock_enable_param #(
    .WAIT(3),
    .WIDTH(8)
   )test_unit2(
    .clk(clk),
    .enable(enable2)
);

clock_enable_param #(
    .WAIT(9),
    .WIDTH(8)
   )test_unit3(
    .clk(clk),
    .enable(enable3)
);



endmodule