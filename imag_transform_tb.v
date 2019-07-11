// This file is Test Bench for top_vga_mem module
//  
// 

// 100MHz clock input from top module
// 50% duty cycle 5ns HIGH and 5ns LOW
//`timescale [time unit] / [time precision]
`timescale 10 ns / 1ns

//sub modules
`include "imag_transform.v" 
//top module
`include "lookuptable.v"

module imag_transform_tb#(
    parameter   CAM_DATA_WIDTH  = 12,
                CAM_LINE        = 9,
                CAM_PIXEL       = 10
)();

//--------Internal register-----------

reg clk = 1'b0;
reg [CAM_LINE-1:0]            r_line_cam = 0;
reg [CAM_PIXEL-1:0]           r_pixel_cam = 0;
wire [CAM_LINE-1:0]            r_line_out ;
wire [CAM_PIXEL-1:0]           r_pixel_out ;

//---------Test script----------------
// 50% duty cycle clock
always #0.5 clk <= ~clk;

//-----Unit Under test---------------
imag_transform #(
    .CAM_DATA_WIDTH(CAM_DATA_WIDTH),
    .CAM_LINE(CAM_LINE),
    .CAM_PIXEL(CAM_PIXEL)
) test_module (
    .clk(clk),
    .i_we(1'b1),
    .i_data(12'h0f0),
    .im_p(2'b01),
    .i_line(r_line_cam),
    .i_pixel(r_pixel_cam),
    .o_line(r_line_out),
    .o_pixel(r_pixel_out)
);


initial 
  begin 
    #0_000;
    r_line_cam = 'd203;
    r_pixel_cam = 'd403;
    #0_010;
    r_line_cam = 'd250;
    r_pixel_cam = 'd470;
    #0_010;
    r_line_cam = 'd40;
    r_pixel_cam = 'd120;
    #0_010;
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