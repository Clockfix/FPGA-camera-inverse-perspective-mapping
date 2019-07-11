module two_cam_one_screen#(
    parameter   CAM_DATA_WIDTH  = 12,
                CAM_LINE        = 9,
                CAM_PIXEL       = 10
) (
    input           clk1,
    input           clk2,
    input           clk,
    input [1:0]     im_p,         // image processor controls
    // input form camera
    //cam1
    input                           i_we_cam0,
    input [CAM_DATA_WIDTH-1:0]      i_data_cam0,
    input [CAM_LINE-1:0]            i_line_cam0,
    input [CAM_PIXEL-1:0]           i_pixel_cam0,
    input [CAM_LINE-1:0]            i_imag_depth_cam0,
    input [CAM_PIXEL-1:0]           i_imag_width_cam0,
    //input                           i_imag_resized_cam0,
    //cam2
    input                           i_we_cam1,
    input [CAM_DATA_WIDTH-1:0]      i_data_cam1,
    input [CAM_LINE-1:0]            i_line_cam1,
    input [CAM_PIXEL-1:0]           i_pixel_cam1,
    input [CAM_LINE-1:0]            i_imag_depth_cam1,
    input [CAM_PIXEL-1:0]           i_imag_width_cam1,
    //input                           i_imag_resized_cam1,
    // output
    output [CAM_LINE-1:0]           o_line,
    output [CAM_PIXEL-1:0]          o_pixel,
    output                          o_we,
    output [CAM_DATA_WIDTH-1:0]     o_data_wr,
    output [CAM_LINE-1:0]           o_imag_depth,
    output [CAM_PIXEL-1:0]          o_imag_width
);
//------------Internal variables and constants-----------
//  reg [CAM_LINE-1:0]            r_offset_y;
//  reg [CAM_PIXEL-1:0]           r_offset_x;

//  reg [CAM_LINE:0]              r_imag_depth_summ;
//  reg [CAM_PIXEL:0]             r_imag_width_summ;

//  reg [CAM_PIXEL-1:0]            
//     r_imag_width1 = 0,
//     r_imag_width2 = 0,
//     r_imag_width3 = 0;

//  reg [CAM_LINE-1:0]            
//     r_imag_depth1 = 0,
//     r_imag_depth2 = 0,
//     r_imag_depth3 = 0;

// reg [CAM_LINE-1:0]
//     r_imag_depth1_cam0,
//     r_imag_depth2_cam0,
//     r_imag_depth1_cam1,
//     r_imag_depth2_cam1  ;

// reg [CAM_PIXEL-1:0]           
//     r_imag_width1_cam0,
//     r_imag_width2_cam0,
//     r_imag_width1_cam1,
//     r_imag_width2_cam1 ;


 reg [CAM_PIXEL-1:0]            
    r_pixel1_cam1 = 0,
    r_pixel2_cam1 = 0,
    r_pixel3_cam1 = 0,
    r_pixel4_cam1 = 0;

 reg [CAM_PIXEL-1:0]            
    r_pixel1_cam0 = 0,
    r_pixel2_cam0 = 0,
    r_pixel3_cam0 = 0,
    r_pixel4_cam0 = 0;

 reg [CAM_LINE-1:0]            
    r_line1_cam1 = 0,
    r_line2_cam1 = 0,
    r_line3_cam1 = 0,
    r_line4_cam1 = 0;

 reg [CAM_LINE-1:0]            
    r_line1_cam0 = 0,
    r_line2_cam0 = 0,
    r_line3_cam0 = 0,
    r_line4_cam0 = 0;

 reg [CAM_DATA_WIDTH-1:0]      
    r_data1_cam0 = 0,
    r_data2_cam0 = 0,
    r_data3_cam0 = 0,
    r_data4_cam0 = 0;

 reg [CAM_DATA_WIDTH-1:0]      
    r_data1_cam1 = 0,
    r_data2_cam1 = 0,
    r_data3_cam1 = 0,
    r_data4_cam1 = 0;

 reg 
    r_we1_cam0 = 0,
    r_we2_cam0 = 0,
    r_we3_cam0 = 0,
    r_we4_cam0 = 0;

 reg 
    r_we1_cam1 = 0,
    r_we2_cam1 = 0,
    r_we3_cam1 = 0,
    r_we4_cam1 = 0;

 reg [0:0]
    cam_select = 0;

 reg 
    r_we_out = 0;
 reg [CAM_DATA_WIDTH-1:0]      
    r_data_out = 0;
 reg [CAM_LINE-1:0]            
    r_line_out = 0;
 reg [CAM_PIXEL-1:0]            
    r_pixel_out = 0;


//------------Syncronus logic---------------------------


always@(negedge clk1)begin
    // -------------------1st cycle
    //if(clk50==1)begin
        if (i_pixel_cam0 < 'd159 ) begin
            r_pixel1_cam0 <= i_pixel_cam0;
        end else begin
            r_pixel1_cam0 <= 'd159;
        end

        if (i_pixel_cam1 < 'd159 ) begin
            r_pixel1_cam1 <= i_pixel_cam1;
        end else begin
            r_pixel1_cam1 <= 'd159;
        end

        r_data1_cam0 <= i_data_cam0;
        r_we1_cam0 <= i_we_cam0;
        r_line1_cam0 <= i_line_cam0;

        r_data1_cam1 <= i_data_cam1;
        r_we1_cam1 <= i_we_cam1;
        r_line1_cam1 <= i_line_cam1;

    //end
end

always@(negedge clk2)begin
    //if(clk50==0)begin
        // -------------------2nd cycle
        r_data2_cam0 <= r_data1_cam0;
        r_data2_cam1 <= r_data1_cam1;
        r_we2_cam0 <= r_we1_cam0;
        r_we2_cam1 <= r_we1_cam1;

        r_pixel2_cam1 <= r_pixel1_cam1;   
        r_pixel2_cam0 <= r_pixel1_cam0 + 'd160;
    
        r_line2_cam0 <= r_line1_cam0;
        r_line2_cam1 <= r_line1_cam1;
    //end
end


always@(negedge clk1)begin
    //if(clk50==1)begin
        //------------------3rd cycle
    /*    
        r_data_out <= r_data2_cam0;
        r_we_out <= r_we2_cam0;
        r_pixel_out <= r_pixel2_cam0;
        r_line_out <= r_line2_cam0;
    */
    
        r_data3_cam0 <= r_data2_cam0;
        r_we3_cam0 <= r_we2_cam0;
        r_pixel3_cam0 <= r_pixel2_cam0;
        r_line3_cam0 <= r_line2_cam0;
    
        r_data3_cam1 <= r_data2_cam1;
        r_we3_cam1 <= r_we2_cam1;
        r_pixel3_cam1 <= r_pixel2_cam1;
        r_line3_cam1 <= r_line2_cam1;

        
    //end
end

always@(negedge clk2)begin
    //if(clk50==0)begin
        //------------------4th cycle
    /*
        r_data_out <= r_data3_cam1;
        r_we_out <= r_we3_cam1;
        r_pixel_out <= r_pixel3_cam1;
        r_line_out <= r_line3_cam1;
    
  
        r_data4_cam0 <= r_data3_cam0;
        r_line4_cam0 <= r_line3_cam0;
        r_we4_cam0 <= r_we3_cam0;
        r_pixel4_cam0 <= r_pixel3_cam0;
    */
        r_we4_cam1 <= r_we3_cam1;
        r_pixel4_cam1 <= r_pixel3_cam1;
        r_data4_cam1 <= r_data3_cam1;
        r_line4_cam1 <= r_line3_cam1; 

        
    //end
end

always@(negedge clk )begin
    cam_select <= ~cam_select;
end

// assign o_line = r_line_out[CAM_LINE-1:0]; //~counter[0] ? r_line4_cam1 : r_line3_cam0;
// assign o_pixel = r_pixel_out[CAM_PIXEL-1:0]; //~counter[0] ? r_pixel4_cam1 : r_pixel3_cam0;
// assign o_we = r_we_out; // 1'b1; //~counter[0] ? r_we4_cam1 : r_we3_cam0;
// assign o_data_wr = r_data_out;// ~counter[0] ? r_data4_cam1 : r_data3_cam0;

// assign o_imag_depth = 240;//~counter[0] ? r_imag_depth3 : r_imag_depth2;
// assign o_imag_width = 320;//~counter[0] ? r_imag_width3 : r_imag_width2;

assign o_line =     im_p[1]? cam_select ? r_line4_cam1 : r_line3_cam0
                            : im_p[0] ? i_line_cam0 : i_line_cam1 ;

assign o_pixel =    im_p[1]? cam_select ? r_pixel4_cam1 : r_pixel3_cam0
                            : im_p[0] ? i_pixel_cam0 : i_pixel_cam1 ;

assign o_we =       im_p[1]? cam_select ? r_we4_cam1 : r_we3_cam0
                            : im_p[0] ? i_we_cam0 : i_we_cam1 ;

assign o_data_wr =  im_p[1]? cam_select ? r_data4_cam1 : r_data3_cam0
                            : im_p[0] ? i_data_cam0 : i_data_cam1 ;

// assign o_line =     r_line3_cam0;
// assign o_pixel =     r_pixel3_cam0;
// assign o_we =        r_we3_cam0;
// assign o_data_wr =   r_data3_cam0;

assign o_imag_depth = im_p[1]? 240  
                            : im_p[0] ? i_imag_depth_cam0 : i_imag_depth_cam1 ;
assign o_imag_width = im_p[1]? 320  
                            : im_p[0] ? i_imag_width_cam0 : i_imag_width_cam1 ;

endmodule