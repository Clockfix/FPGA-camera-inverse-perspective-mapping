//      TOP module 
//       
//      
// `include "clock_divider_param.v"
// `include "clock_enable_param.v"
// `include "blockram2.v"
// `include "pattern_gen.v"
// `include "vga_module.v"
// `include "horizontal_counter.v"
// `include "vertical_counter.v"
// `include "UART_Loopback_module.v"
// `include "UART_TX.v"
// `include "UART_RX.v"
// `include "7segment_v2.v"
// `include "com_to_mem_FSM_hex.v" 
// `include "com_to_mem_module.v"
// `include "ov7670_top.v"
// `include "debounce_switch.v"
// `include "ov7670_capture.v"
// `include "ov7670_controller.v"
// `include "imag_procesor.v"
// `include "default_reg_writer.v"
// `include "i2c_senderv2.v"
// `include "ov7670_registers.v"
// `include "imag_save.v" 
// `include "rgb2gray.v" 
// `include "rgb2gray2.v" 
// `include "imag_transform.v"
// `include "reg_reader.v"
// `include "address_gen.v"
// `include "overlay.v"
// `include "two_cam_one_screen2.v"
// `include "lookuptable.v"


module top #( parameter
    //pattern generator paremater
    SPEED = 300,
    //enable signal parameters
    WAIT = 1,
    WAIT_WIDTH = 2,
    //memory parameters
    ADDR_WIDTH = 17, // 19, //
    DATA_WIDTH = 12, 
    DEPTH =  76_800, // 307_200,//
    //VGA parameters
    HSYNC_CLKS = 800,
    HSYNC_DISPLAY = 640,
    HSYNC_PULSE = 96,
    HSYNC_FRONT_PORCH = 16,
    HSYNC_BACK_PORCH = 48,
    VSYNC_LINES = 521,
    VSYNC_DISPLAY = 480,
    VSYNC_PULSE = 2,
    VSYNC_FRONT_PORCH = 10,
    VSYNC_BACK_PORCH = 29,
    // CAM buss
    CAM_DATA_WIDTH  = 12,
    CAM_LINE        = 9,
    CAM_PIXEL       = 10
)(
    input           clk,
    output  [11:0]  led,
    output  [1:0]   ledc,   // led camera configuration indicator
    //VGA  inputs outputs
    output [3:0]    vgaRed,
    output [3:0]    vgaBlue,
    output [3:0]    vgaGreen,
    output          Hsync,
    output          Vsync,
    input [2:0]     sw,
    input [8:0]     im_p,
    //UART 
    input           RsRx,         // UART RX Data
    output          RsTx,        // UART TX Data
    // 7 segment
    output  [6:0]   seg, 
    output  [3:0]   an,   

    // camera inputs outputs
    input           ov7670_cam1_pclk,
    output          ov7670_cam1_mclk,
    input           ov7670_cam1_vs,
    input           ov7670_cam1_hs,
    input  [7:0]    ov7670_cam1_data,
    output          ov7670_cam1_scl,
    inout           ov7670_cam1_sda,
    output          ov7670_cam1_pwdn,
    output          ov7670_cam1_reset,

    input           ov7670_cam2_pclk,
    output          ov7670_cam2_mclk,
    input           ov7670_cam2_vs,
    input           ov7670_cam2_hs,
    input  [7:0]    ov7670_cam2_data,
    output          ov7670_cam2_scl,
    inout           ov7670_cam2_sda,
    output          ov7670_cam2_pwdn,
    output          ov7670_cam2_reset,

    input btnC,     // reconfigure camera
    input btnU      // reset button for registers blobk RAM
    );

//------internal wires and registers--------
 wire w_enable;
 wire pixel_clk;

 wire clk50;    

 wire w_write;

 wire [ADDR_WIDTH-1:0] w_addr_wr;
 wire [DATA_WIDTH-1:0] w_data_wr;

 wire [ADDR_WIDTH-1:0] w_com_addr_wr;
 wire [DATA_WIDTH-1:0] w_com_data_wr;
 wire w_com_write;
 wire [ADDR_WIDTH-1:0] w_com_addr_rd;

//  wire [ADDR_WIDTH-1:0] w_addrb;

 wire [ADDR_WIDTH-1:0] w_addr_rd;
 wire [DATA_WIDTH-1:0] w_data_rd;

 wire [DATA_WIDTH-1:0]   w_camera_cam1_data_wr;
 wire                    w_camera_cam1_we;
 wire [CAM_LINE-1:0]     w_line_cam1;
  wire [CAM_PIXEL-1:0]    w_pixel_cam1;

  wire [DATA_WIDTH-1:0]   w_camera_cam2_data_wr;
  wire                    w_camera_cam2_we;
  wire [CAM_LINE-1:0]     w_line_cam2;
  wire [CAM_PIXEL-1:0]    w_pixel_cam2;

  wire [ADDR_WIDTH-1:0]   w_proces_addr_wr;
  wire [DATA_WIDTH-1:0]   w_proces_data_wr;
  wire                    w_proces_we;

  wire [DATA_WIDTH-1:0]   w_doa_bram;
  wire                    w_wea_bram;
  wire [ADDR_WIDTH-1:0]   w_addra_bram;
  wire [DATA_WIDTH-1:0]   w_dia_bram;

  reg  [DATA_WIDTH-1:0]   r_led = 0;

  wire                    w_config_default ;
  wire [6:0]              w_addr_default ;
  wire [24:0]             w_data_default ;
  wire                    w_we_default ;
  wire                    w_reset_default;

  wire [DATA_WIDTH-1:0]   w_doa_bram_old;

  wire [24:0]             w_data_reg;
  wire [6:0]              w_addr_rd_reg;

  wire [6:0]              w_addr_com_wr_reg ;
  wire [24:0]             w_data_com_reg ;
  wire                    w_we_com_reg ;

//-----sub modules--------------------------
clock_enable_param #(
    .WAIT(WAIT),
    .WIDTH(WAIT_WIDTH)
  ) clock_enable1 (
    .clk(clk),
    .enable(w_enable)
);

clock_divider #(
    .DIVIDER(2),
    .WIDTH(3)
) clk25mhz_gen (
    .clk(clk),
    .clk_out(pixel_clk)
);

clock_divider #(
    .DIVIDER(1),
    .WIDTH(3)
) clk50mhz_gen (
    .clk(clk),
    .clk_out(clk50)
);

pattern_gen #( 
    .DEPTH(DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .SPEED(SPEED)
) pattern_gen1 (
    .clk(clk),
//    .sw(sw[1]),
    .i_enable(w_enable),
    .o_addr(w_addr_wr),
    .o_data(w_data_wr),
    .o_write(w_write)
);

rams_tdp_rf_rf #( 
    .DEPTH(DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH), 
    .DATA_WIDTH(DATA_WIDTH)) 
bram3(
    // -------------------------PORT A
    .clka(clk),
    .ena(  1'b1  /*w_enable*/),
    .wea( w_wea_bram ),
    .addra( w_addra_bram ),
    .dia( w_dia_bram ),
    .doa( w_doa_bram ),

    //---------------------------PORT B
    .clkb(clk),
    .addrb( w_addr_rd ),
    .enb(w_enable),
    //.web(),
    //.dib(),
    .dob(w_data_rd));


vga_module #(  
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH),
        .HSYNC_CLKS(HSYNC_CLKS),
        .HSYNC_DISPLAY(HSYNC_DISPLAY),
        .HSYNC_PULSE(HSYNC_PULSE),
        .HSYNC_FRONT_PORCH(HSYNC_FRONT_PORCH),
        .HSYNC_BACK_PORCH(HSYNC_BACK_PORCH),
        .VSYNC_LINES(VSYNC_LINES) ,
        .VSYNC_DISPLAY(VSYNC_DISPLAY) ,
        .VSYNC_PULSE(VSYNC_PULSE) ,
        .VSYNC_FRONT_PORCH(VSYNC_FRONT_PORCH) ,
        .VSYNC_BACK_PORCH(VSYNC_BACK_PORCH) 
) vga_module1 (
    .clk(pixel_clk),
    .o_vgaRed(vgaRed),
    .o_vgaBlue(vgaBlue),
    .o_vgaGreen(vgaGreen),
    .o_Hsync(Hsync),
    .o_Vsync(Vsync),
    .o_display(),
    .o_addr_rd(w_addr_rd),
    .o_data_rd(w_data_rd)
   );

com_to_mem #( 
    .WAIT(WAIT),
    .WAIT_WIDTH(WAIT_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH), 
    .DEPTH(DEPTH)
) com_to_mem1 (
    .clk(clk),
    .sw(sw[0]),
    //.i_data_rd(w_doa_bram),
    .i_enable(w_enable),
    .o_addr_wr(w_com_addr_wr),
    .o_addr_rd(w_com_addr_rd),
    .o_data_wr(w_com_data_wr),
    .o_write(w_com_write),
    .RsRx(RsRx),         // UART RX Data
    .RsTx(RsTx),        // UART TX Data
    .seg(seg), 
    .an(an),
    .o_addr_wr_reg(w_addr_com_wr_reg),
    .o_data_reg(w_data_com_reg),
    .o_we_reg(w_we_com_reg)
    );

ov7670_top #(
    .CAM_DATA_WIDTH(CAM_DATA_WIDTH),
    .CAM_LINE(CAM_LINE),
    .CAM_PIXEL(CAM_PIXEL)
) ov7670_cam1(
    .clk(pixel_clk),
    .btn(btnC),
    .config_finished(ledc[0]),              // configuration finished
    .o_data_wr(w_camera_cam1_data_wr),
    .o_line(w_line_cam1),
    .o_pixel(w_pixel_cam1),
    .we(w_camera_cam1_we),      
    .ov7670_pclk(ov7670_cam1_pclk),
    .ov7670_mclk(ov7670_cam1_mclk),
    .ov7670_vs(ov7670_cam1_vs),
    .ov7670_hs(ov7670_cam1_hs),
    .ov7670_data(ov7670_cam1_data),
    .ov7670_scl(ov7670_cam1_scl),
    .ov7670_sda(ov7670_cam1_sda),
    .ov7670_pwdn(ov7670_cam1_pwdn),
    .ov7670_reset(ov7670_cam1_reset) 
);

ov7670_top #(
    .CAM_DATA_WIDTH(CAM_DATA_WIDTH),
    .CAM_LINE(CAM_LINE),
    .CAM_PIXEL(CAM_PIXEL)
) ov7670_cam2(
    .clk(pixel_clk),
    .btn(btnC),
    .config_finished(ledc[1]),
    .o_data_wr(w_camera_cam2_data_wr),
    .o_line(w_line_cam2),
    .o_pixel(w_pixel_cam2),
    .we(w_camera_cam2_we),      
    .ov7670_pclk(ov7670_cam2_pclk),
    .ov7670_mclk(ov7670_cam2_mclk),
    .ov7670_vs(ov7670_cam2_vs),
    .ov7670_hs(ov7670_cam2_hs),
    .ov7670_data(ov7670_cam2_data),
    .ov7670_scl(ov7670_cam2_scl),
    .ov7670_sda(ov7670_cam2_sda),
    .ov7670_pwdn(ov7670_cam2_pwdn),
    .ov7670_reset(ov7670_cam2_reset) 
);

imag_procesor #(
    .CAM_DATA_WIDTH(CAM_DATA_WIDTH),
    .CAM_LINE(CAM_LINE),
    .CAM_PIXEL(CAM_PIXEL)
) imag_procesor(
    .im_p(im_p),
    .clk(clk),
    .clk25(pixel_clk),
    .clk50(clk50),
    .i_enable(w_enable),
    .i_data_reg(w_data_reg),
    .o_addr_rd_reg(w_addr_rd_reg),
    .i_we_cam2(w_camera_cam2_we),
    .i_data_cam2_wr(w_camera_cam2_data_wr),
    .i_line_cam2(w_line_cam2),
    .i_pixel_cam2(w_pixel_cam2),
    .i_we_cam1(w_camera_cam1_we),
    .i_data_cam1_wr(w_camera_cam1_data_wr),
    .i_line_cam1(w_line_cam1),
    .i_pixel_cam1(w_pixel_cam1),
    .o_we(w_proces_we),
    .o_addr_wr(w_proces_addr_wr),
    .o_data_wr(w_proces_data_wr)
);

rams_tdp_rf_rf #( 
    .DEPTH(88),             
    .ADDR_WIDTH(7),         
    .DATA_WIDTH(25)) 
bram_reg(
    // -------------------------PORT A
    .clka(  clk),
    .ena( 1'b1  /*w_enable*/   ),
    .wea(  ),
    .addra(w_addr_rd_reg),
    .dia(  ),
    .doa(w_data_reg),

    //---------------------------PORT B
    .clkb(  clk),
    .addrb( w_config_default ? w_addr_com_wr_reg : w_addr_default ),
    .enb(   w_enable),
    .web(   w_config_default ? w_we_com_reg : w_we_default),
    .dib(   w_config_default ? w_data_com_reg : w_data_default),
    .dob()  // not connected
    );

default_reg_writer default_reg_writer1(
    .clk(clk),
    .i_enable(w_enable),
    .i_reset(w_reset_default),
    .o_configured(w_config_default),
    .o_addr(w_addr_default),
    .o_data(w_data_default) ,
    .o_we(w_we_default) 
);

debounce_switch debounce_switch_reset(
    .clk(clk),
    .i_switch(btnU),
    .o_switch(w_reset_default)
);


always@(posedge clk) begin
        if (~w_wea_bram) begin
                r_led <= w_doa_bram;
                // r_doa_bram_old <= w_doa_bram;
        end
        else begin
                r_led <= w_doa_bram_old;
        end

end

assign led[11:0] = r_led ;      
assign w_doa_bram_old = r_led;                 

assign w_addra_bram =  ~w_wea_bram ? w_com_addr_rd :            // if we LOW port A address connected to com_to_mem module
                        (sw[2:1] == 2'b00) ? w_com_addr_wr :
                        (sw[2:1] == 2'b01) ? w_addr_wr :
                        (sw[2:1] == 2'b10) ? w_proces_addr_wr : 
                                             w_proces_addr_wr ;   // sw[2:1] == 2'b11

assign w_wea_bram =     (sw[2:1] == 2'b00) ? w_com_write :
                        (sw[2:1] == 2'b01) ? w_write :
                        (sw[2:1] == 2'b10) ? w_proces_we : 
                                             w_proces_we ;   // sw[2:1] == 2'b11

assign w_dia_bram =     (sw[2:1] == 2'b00) ? w_com_data_wr :
                        (sw[2:1] == 2'b01) ? w_data_wr :
                        (sw[2:1] == 2'b10) ? w_proces_data_wr : 
                                             w_proces_data_wr ;


endmodule