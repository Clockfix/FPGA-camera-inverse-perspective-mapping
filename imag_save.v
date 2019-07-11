module imag_save #(
    parameter   CAM_DATA_WIDTH  = 12,
                CAM_LINE        = 9,
                CAM_PIXEL       = 10
) (
    input           clk,
    input           clk25,
    input           clk50,
    input [2:0]     im_p,         // image processor controls
    // input form camera
    //cam1
    input                           i_we_cam1,
    input [CAM_DATA_WIDTH-1:0]      i_data_cam1,
    input [CAM_LINE-1:0]            i_line_cam1,
    input [CAM_PIXEL-1:0]           i_pixel_cam1,
    input [CAM_LINE-1:0]            i_imag_depth_cam1,
    input [CAM_PIXEL-1:0]           i_imag_width_cam1,
    input                           i_imag_resized_cam1,
    //cam2
    input                           i_we_cam2,
    input [CAM_DATA_WIDTH-1:0]      i_data_cam2,
    input [CAM_LINE-1:0]            i_line_cam2,
    input [CAM_PIXEL-1:0]           i_pixel_cam2,
    input [CAM_LINE-1:0]            i_imag_depth_cam2,
    input [CAM_PIXEL-1:0]           i_imag_width_cam2,
    input                           i_imag_resized_cam2,
    // output
    output                          o_we,
    output [16:0]                   o_addr_wr,
    output [CAM_DATA_WIDTH-1:0]     o_data_wr
);
//------------Internal variables and constants-----------


wire                            w_i_we_ag;
wire [CAM_PIXEL-1:0]            w_i_pixel_ag;
wire [CAM_LINE-1:0]             w_i_line_ag;
wire [CAM_DATA_WIDTH-1:0]       w_i_data_ag;
wire [CAM_LINE-1:0]             w_imag_depth;
wire [CAM_PIXEL-1:0]            w_imag_width;
wire                            w_imag_resized;


wire                            w_we_twocam;
wire [CAM_PIXEL-1:0]            w_pixel_twocam;
wire [CAM_LINE-1:0]             w_line_twocam;
wire [CAM_DATA_WIDTH-1:0]       w_data_twocam;
wire [CAM_LINE-1:0]             w_imag_depth_twocam;
wire [CAM_PIXEL-1:0]            w_imag_width_twocam;

//---------------sub module--------------------------------
address_gen #(
    .CAM_DATA_WIDTH(CAM_DATA_WIDTH),
    .CAM_LINE(CAM_LINE),
    .CAM_PIXEL(CAM_PIXEL)
) address_gen(
    .clk(clk),

    // input
    .i_we(      w_i_we_ag),   
    .i_data(    w_i_data_ag), 
    .i_line(    w_i_line_ag), 
    .i_pixel(   w_i_pixel_ag),
    .i_imag_depth(w_imag_depth),
    .i_imag_width(w_imag_width),

    // output
    .o_we(o_we),
    .o_data(o_data_wr),
    .o_addr(o_addr_wr)
);

overlay #(
    .CAM_DATA_WIDTH(CAM_DATA_WIDTH),
    .CAM_LINE(CAM_LINE),
    .CAM_PIXEL(CAM_PIXEL)
) overlay(
    .clk(clk),
    .enable(im_p[2]),
    // input
    .i_we(w_we_twocam ),
    .i_data(w_data_twocam ),
    .i_line(w_line_twocam ),
    .i_pixel(w_pixel_twocam ),
    .i_imag_depth(w_imag_depth_twocam  ),
    .i_imag_width(w_imag_width_twocam  ),
    .i_imag_resized( 1'b1 ),
    // output
    .o_we(w_i_we_ag),
    .o_data(w_i_data_ag),
    .o_line(w_i_line_ag),
    .o_pixel(w_i_pixel_ag),
    .o_imag_depth(w_imag_depth),
    .o_imag_width(w_imag_width),
    .o_imag_resized(w_imag_resized)   
);

two_cam_one_screen #(
    .CAM_DATA_WIDTH(CAM_DATA_WIDTH),
    .CAM_LINE(CAM_LINE),
    .CAM_PIXEL(CAM_PIXEL)
)  two_cam_one_screen(
    .clk1(clk25 & clk50),
    .clk2(clk50 & ~clk25),
    .clk( clk50 ),
    .im_p(im_p[1:0]),         // image processor controls
    // input form camera
    //cam1
    .i_we_cam0(i_we_cam1),
    .i_data_cam0(i_data_cam1),
    .i_line_cam0(i_line_cam1),
    .i_pixel_cam0(i_pixel_cam1),
    .i_imag_depth_cam0(i_imag_depth_cam1),
    .i_imag_width_cam0(i_imag_width_cam1),
    //input                           i_imag_resized_cam0,
    //cam2
    .i_we_cam1(i_we_cam2),
    .i_data_cam1(i_data_cam2),
    .i_line_cam1(i_line_cam2),
    .i_pixel_cam1(i_pixel_cam2),
    .i_imag_depth_cam1(i_imag_depth_cam2),
    .i_imag_width_cam1(i_imag_width_cam2),
    //input                           i_imag_resized_cam1,
    // output
    .o_line(w_line_twocam),
    .o_pixel(w_pixel_twocam),
    .o_we(w_we_twocam),
    .o_data_wr(w_data_twocam),
    .o_imag_depth(w_imag_depth_twocam),
    .o_imag_width(w_imag_width_twocam)
);



endmodule