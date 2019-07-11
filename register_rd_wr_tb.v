// This file is Test Bench for top_vga_mem module
//  
// 

// 100MHz clock input from top module
// 50% duty cycle 5ns HIGH and 5ns LOW
//`timescale [time unit] / [time precision]
`timescale 10 ns / 1ns

//sub modules
`include "clock_enable_param.v" 
//test modulea
`include "default_reg_writer.v"
`include "blockram.v"
`include "reg_reader.v"

module register_rd_wr_tb #(parameter
    CAM_LINE        = 9,
    CAM_PIXEL       = 10,
    DEPTH =  88,
    ADDR_WIDTH = 7, 
    DATA_WIDTH = 25 
  )();

//--------Internal register-----------

reg clk = 1'b0;
wire w_enable;
reg reset = 0;

wire [24:0]             w_data_reg;
wire [6:0]              w_addr_rd_reg;
wire                    w_config_default ;
wire [6:0]              w_addr_default ;
wire [24:0]             w_data_default ;
wire                    w_we_default ;

//---------Test script----------------
// 50% duty cycle clock
always #0.5 clk <= ~clk;

//-----Unit Under test---------------
default_reg_writer #(
    .CAM_LINE(CAM_LINE),
    .CAM_PIXEL(CAM_PIXEL)
) default_reg_writer1(
    .clk(clk),
    .i_enable(w_enable),
    .i_reset(reset),
    .o_configured(w_config_default),
    .o_addr(w_addr_default),
    .o_data(w_data_default) ,
    .o_we(w_we_default) 
);

reg_reader #(
    .CAM_LINE(CAM_LINE),
    .CAM_PIXEL(CAM_PIXEL)
) reg_reader1 (
    .clk(clk),
    .i_enable(w_enable),
    .i_cam0_mode(2'b00),
    .i_cam1_mode(2'b00),
    .i_data(w_data_reg),
    .o_addr_rd(w_addr_rd_reg)
);

rams_tdp_rf_rf #( 
    .DEPTH(DEPTH),             
    .ADDR_WIDTH(ADDR_WIDTH),         
    .DATA_WIDTH(DATA_WIDTH)
    ) 
bram_reg(
    // -------------------------PORT A
    .clka(  clk),
    .ena(1'b1),
    .wea(  ),
    .addra(w_addr_rd_reg),
    .dia(  ),
    .doa(w_data_reg),

    //---------------------------PORT B
    .clkb(  clk),
    .addrb( w_config_default ? w_addr_default : w_addr_default ),
    .enb(   w_enable),
    .web(   w_config_default ? w_we_default : w_we_default),
    .dib(   w_config_default ? w_data_default : w_data_default),
    .dob()  // not connected
    );

//------sub modules-------------------
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
    #3_500; 

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