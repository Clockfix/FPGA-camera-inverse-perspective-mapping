// 100MHz clock on Basys3 -> 10ns period
// 50% duty cycle 5ns HIGH and 5ns LOW
//`timescale [time unit] / [time precision]
`timescale 10 ns / 1ns

`include "pattern_gen.v"
`include "clock_enable_param.v"


module pattern_gen_tb#( parameter 
    ADDR_WIDTH = 17,
    DATA_WIDTH = 8
) ();

// for clock_divider
reg clk = 1'b0;
wire enable;
wire [ADDR_WIDTH-1:0] addr ;
wire [DATA_WIDTH-1:0] data ;

// generate clk 
always #0.5 clk <= ~clk; 

initial
begin

    #76_800;
    #76_800;
    #76_800;
    #76_800;
    #76_800;
    #76_800;
    #76_800;
    #76_800;
    #76_800;
    #76_800;

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

clock_enable_param #(
    .WAIT(1),
    .WIDTH(2)
  ) clock_enable1 (
    .clk(clk),
    .enable(enable));

address_gen #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
) test_unit (
    .clk(clk),
    .i_enable(enable),
    .o_addr(addr),
    .o_data(data));

endmodule