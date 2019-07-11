module imag_procesor #(
    parameter   CAM_DATA_WIDTH  = 12,
                CAM_LINE        = 9,
                CAM_PIXEL       = 10
) (
    // control signals and clk --------
    input [8:0]     im_p,          // image processor controls
    input           clk,
    input           clk25,
    input           clk50,
    input           i_enable,
    // cam2 input-----------------------
    input                           i_we_cam2,
    input [CAM_DATA_WIDTH-1:0]      i_data_cam2_wr,
    input [CAM_LINE-1:0]            i_line_cam2,
    input [CAM_PIXEL-1:0]           i_pixel_cam2,
    // cam1 input-----------------------
    input                           i_we_cam1,
    input [CAM_DATA_WIDTH-1:0]      i_data_cam1_wr,
    input [CAM_LINE-1:0]            i_line_cam1,
    input [CAM_PIXEL-1:0]           i_pixel_cam1,
    // output---------------------------
    output                          o_we,
    output [16:0]                   o_addr_wr,
    output [CAM_DATA_WIDTH-1:0]     o_data_wr,

    // to register RAM for imag transform
    input [24:0]                    i_data_reg,
    output [6:0]                    o_addr_rd_reg
);

//------- wire for rgb2gray----------------
    // cam1
wire                            w_we_gray_cam1;
wire [CAM_DATA_WIDTH-1:0]       w_data_gray_cam1;
wire [CAM_LINE-1:0]             w_line_gray_cam1;
wire [CAM_PIXEL-1:0]            w_pixel_gray_cam1;
    // cam2
wire                            w_we_gray_cam2;
wire [CAM_DATA_WIDTH-1:0]       w_data_gray_cam2;
wire [CAM_LINE-1:0]             w_line_gray_cam2;
wire [CAM_PIXEL-1:0]            w_pixel_gray_cam2;
//------- wire for imag_transform------------
    // cam1
wire                            w_we_it_cam1;
wire [CAM_DATA_WIDTH-1:0]       w_data_it_cam1;
wire [CAM_LINE-1:0]             w_line_it_cam1;
wire [CAM_PIXEL-1:0]            w_pixel_it_cam1;
wire [CAM_LINE-1:0]             w_imag_depth_cam1;
wire [CAM_PIXEL-1:0]            w_imag_width_cam1;
wire                            w_imag_resized_cam1;
    // cam2
wire                            w_we_it_cam2;
wire [CAM_DATA_WIDTH-1:0]       w_data_it_cam2;
wire [CAM_LINE-1:0]             w_line_it_cam2;
wire [CAM_PIXEL-1:0]            w_pixel_it_cam2;
wire [CAM_LINE-1:0]             w_imag_depth_cam2;
wire [CAM_PIXEL-1:0]            w_imag_width_cam2;
wire                            w_imag_resized_cam2;

//-----------wire for reg reader module
    // 1st camera
    wire [CAM_PIXEL-1:0]  w_cam0_WIDTH;
    wire [CAM_LINE-1:0]   w_cam0_DEPTH;
    wire [24:0]           w_cam0_T11;
    wire [24:0]           w_cam0_T12;
    wire [24:0]           w_cam0_T13;
    wire [24:0]           w_cam0_T21;
    wire [24:0]           w_cam0_T22;
    wire [24:0]           w_cam0_T23;
    wire [24:0]           w_cam0_T31;
    wire [24:0]           w_cam0_T32;
    wire [24:0]           w_cam0_T33;

    // 2nd camera
    wire [CAM_PIXEL-1:0]  w_cam1_WIDTH;
    wire [CAM_LINE-1:0]   w_cam1_DEPTH;
    wire [24:0]           w_cam1_T11;
    wire [24:0]           w_cam1_T12;
    wire [24:0]           w_cam1_T13;
    wire [24:0]           w_cam1_T21;
    wire [24:0]           w_cam1_T22;
    wire [24:0]           w_cam1_T23;
    wire [24:0]           w_cam1_T31;
    wire [24:0]           w_cam1_T32;
    wire [24:0]           w_cam1_T33;

//---------- wire for save module -----------------

wire [CAM_DATA_WIDTH-1:0]       w_o_data_sw;
wire                            w_o_we_sw;    
wire [16:0]                     w_o_addr_sw;

//----------------------sub modules-------------------------------

imag_save #(
    .CAM_DATA_WIDTH(CAM_DATA_WIDTH),
    .CAM_LINE(CAM_LINE),
    .CAM_PIXEL(CAM_PIXEL)
)  imag_save(
    .clk(clk),
    .clk25(clk25),
    .clk50(clk50),
    .im_p(im_p[2:0]),         // image processor controls
        //input
        //cam1
    .i_we_cam1(          w_we_it_cam1),
    .i_data_cam1(        w_data_it_cam1),
    .i_line_cam1(        w_line_it_cam1),
    .i_pixel_cam1(       w_pixel_it_cam1),
    .i_imag_depth_cam1(w_imag_depth_cam1),
    .i_imag_width_cam1(w_imag_width_cam1),
    .i_imag_resized_cam1(w_imag_resized_cam1),
        //cam2
    .i_we_cam2(          w_we_it_cam2),
    .i_data_cam2(        w_data_it_cam2),
    .i_line_cam2(        w_line_it_cam2),
    .i_pixel_cam2(       w_pixel_it_cam2),
    .i_imag_depth_cam2(w_imag_depth_cam2),
    .i_imag_width_cam2(w_imag_width_cam2),
    .i_imag_resized_cam2(w_imag_resized_cam2),
        //output
    .o_we(              w_o_we_sw),
    .o_addr_wr(         w_o_addr_sw),
    .o_data_wr(         w_o_data_sw)
);

//------------------- gray or color-------------------------------
rgb2gray  #(
    .CAM_DATA_WIDTH(CAM_DATA_WIDTH),
    .CAM_LINE(CAM_LINE),
    .CAM_PIXEL(CAM_PIXEL)
) rgb2gray_cam1(
    .clk(clk),
    .gray(im_p[7]),                    // TRUE output gray
    .i_we(          i_we_cam1),
    .i_data_wr(     i_data_cam1_wr),
    .i_line(        i_line_cam1),
    .i_pixel(       i_pixel_cam1),
    .o_we(          w_we_gray_cam1),
    .o_data_wr(     w_data_gray_cam1),
    .o_line(        w_line_gray_cam1),
    .o_pixel(       w_pixel_gray_cam1)
);

rgb2gray  #(
    .CAM_DATA_WIDTH(CAM_DATA_WIDTH),
    .CAM_LINE(CAM_LINE),
    .CAM_PIXEL(CAM_PIXEL)
) rgb2gray_cam2(
    .clk(clk),
    .gray(im_p[8]),                    // TRUE output gray
    .i_we(          i_we_cam2),
    .i_data_wr(     i_data_cam2_wr),
    .i_line(        i_line_cam2),
    .i_pixel(       i_pixel_cam2),
    .o_we(          w_we_gray_cam2),
    .o_data_wr(     w_data_gray_cam2),
    .o_line(        w_line_gray_cam2),
    .o_pixel(       w_pixel_gray_cam2)
);

//--------------------- original or transformed-------------------------
imag_transform  #(
    .CAM_DATA_WIDTH(CAM_DATA_WIDTH),
    .CAM_LINE(CAM_LINE),
    .CAM_PIXEL(CAM_PIXEL)
) imag_transform_cam1(
    .clk(clk),
    .im_p(im_p[4:3]),         // image processor controls
    //input
    .i_we(          w_we_gray_cam1),
    .i_data(        w_data_gray_cam1),
    .i_line(        w_line_gray_cam1),
    .i_pixel(       w_pixel_gray_cam1),
    //output
    .o_we(          w_we_it_cam1),
    .o_data(        w_data_it_cam1),
    .o_line(        w_line_it_cam1),
    .o_pixel(       w_pixel_it_cam1),
    .o_imag_depth(w_imag_depth_cam1),
    .o_imag_width(w_imag_width_cam1),
    .o_imag_resized(w_imag_resized_cam1),
    // imag transform parmeters
    .TRA_IMG_WIDTH  (w_cam0_WIDTH),
    .TRA_IMG_DEPTH  (w_cam0_DEPTH),
    .T11 (w_cam0_T11),
    .T12 (w_cam0_T12),
    .T13 (w_cam0_T13),
    .T21 (w_cam0_T21),
    .T22 (w_cam0_T22),
    .T23 (w_cam0_T23),
    .T31 (w_cam0_T31),
    .T32 (w_cam0_T32),
    .T33 (w_cam0_T33)
);

imag_transform  #(
    .CAM_DATA_WIDTH(CAM_DATA_WIDTH),
    .CAM_LINE(CAM_LINE),
    .CAM_PIXEL(CAM_PIXEL)
) imag_transform_cam2(
    .clk(clk),
    .im_p(im_p[6:5]),         // image processor controls
    //input
    .i_we(          w_we_gray_cam2),
    .i_data(        w_data_gray_cam2),
    .i_line(        w_line_gray_cam2),
    .i_pixel(       w_pixel_gray_cam2),
    //output
    .o_we(          w_we_it_cam2),
    .o_data(        w_data_it_cam2),
    .o_line(        w_line_it_cam2),
    .o_pixel(       w_pixel_it_cam2),
    .o_imag_depth(w_imag_depth_cam2),
    .o_imag_width(w_imag_width_cam2),
    .o_imag_resized(w_imag_resized_cam2),
    // imag transform parmeters
    .TRA_IMG_WIDTH  (w_cam1_WIDTH),
    .TRA_IMG_DEPTH  (w_cam1_DEPTH),
    .T11 (w_cam1_T11),
    .T12 (w_cam1_T12),
    .T13 (w_cam1_T13),
    .T21 (w_cam1_T21),
    .T22 (w_cam1_T22),
    .T23 (w_cam1_T23),
    .T31 (w_cam1_T31),
    .T32 (w_cam1_T32),
    .T33 (w_cam1_T33)
);

reg_reader #(
    .CAM_LINE(CAM_LINE),
    .CAM_PIXEL(CAM_PIXEL)
) reg_reader1 (
    .clk(clk),
    .i_enable(i_enable),
    .i_cam0_mode(im_p[4:3]),
    .i_cam1_mode(im_p[6:5]),
    .i_data(i_data_reg),
    .o_addr_rd(o_addr_rd_reg),
    // 1st camera
    .o_cam0_WIDTH(w_cam0_WIDTH),
    .o_cam0_DEPTH(w_cam0_DEPTH),
    .o_cam0_T11(w_cam0_T11),
    .o_cam0_T12(w_cam0_T12),
    .o_cam0_T13(w_cam0_T13),
    .o_cam0_T21(w_cam0_T21),
    .o_cam0_T22(w_cam0_T22),
    .o_cam0_T23(w_cam0_T23),
    .o_cam0_T31(w_cam0_T31),
    .o_cam0_T32(w_cam0_T32),
    .o_cam0_T33(w_cam0_T33),

    // 2nd camera
    .o_cam1_WIDTH(w_cam1_WIDTH),
    .o_cam1_DEPTH(w_cam1_DEPTH),
    .o_cam1_T11(w_cam1_T11),
    .o_cam1_T12(w_cam1_T12),
    .o_cam1_T13(w_cam1_T13),
    .o_cam1_T21(w_cam1_T21),
    .o_cam1_T22(w_cam1_T22),
    .o_cam1_T23(w_cam1_T23),
    .o_cam1_T31(w_cam1_T31),
    .o_cam1_T32(w_cam1_T32),
    .o_cam1_T33(w_cam1_T33)
);




//------------------- output logic -----------------------------------
assign o_data_wr    =   w_o_data_sw ;
assign o_we         =   w_o_we_sw ;    
assign o_addr_wr    =   w_o_addr_sw;

endmodule

