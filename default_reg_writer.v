// Default parameters for image transform module
// Four MSB are actual registers
// next two bits are one of modes selected by swishes. 4 modes are avilable
// LSB are camera bit. avilable two cameras. Camera 0 and camera 1.
//  
//
module default_reg_writer #(parameter

    CAM_LINE        = 9,
    CAM_PIXEL       = 10,

// default settings for mode 0 camera 0
    TRA_IMG_WIDTH_0_0   = 'd320,
    TRA_IMG_DEPTH_0_0   = 'd240,
    T11_0_0 = 25'sb0_000000000000_100000000000,
    T12_0_0 = 25'sb0_000000000000_000000000000,
    T13_0_0 = 25'sb0_000000000000_000000000000,
    T21_0_0 = 25'sb0_000000000000_000000000000,
    T22_0_0 = 25'sb0_000000000000_100000000000,
    T23_0_0 = 25'sb0_000000000000_000000000000,
    T31_0_0 = 25'sb0_000000000000_000000000000,
    T32_0_0 = 25'sb0_000000000000_000000000000,
    T33_0_0 = 25'sb0_000000000001_000000000000,
// default settings for mode 0 camera 1 
    TRA_IMG_WIDTH_0_1   = 'd320,
    TRA_IMG_DEPTH_0_1   = 'd240,
    T11_0_1 = 25'sb0_000000000000_100000000000,
    T12_0_1 = 25'sb0_000000000000_000000000000,
    T13_0_1 = 25'sb0_000000000000_000000000000,
    T21_0_1 = 25'sb0_000000000000_000000000000,
    T22_0_1 = 25'sb0_000000000000_100000000000,
    T23_0_1 = 25'sb0_000000000000_000000000000,
    T31_0_1 = 25'sb0_000000000000_000000000000,
    T32_0_1 = 25'sb0_000000000000_000000000000,
    T33_0_1 = 25'sb0_000000000001_000000000000,
// default settings for mode 1 camera 0 
    TRA_IMG_WIDTH_1_0   = 'd320,
    TRA_IMG_DEPTH_1_0   = 'd240,
    T11_1_0 = 25'sh0000000,
    T12_1_0 = 25'sh1fffa04,
    T13_1_0 = 25'sh0000000,
    T21_1_0 = 25'sh0000aa8,
    T22_1_0 = 25'sh0000000,
    T23_1_0 = 25'sh0000000,
    T31_1_0 = 25'sh0000000,
    T32_1_0 = 25'sh00ef000,
    T33_1_0 = 25'sh0001000,
// default settings for mode 1 camera 1 
    TRA_IMG_WIDTH_1_1   = 'd320,
    TRA_IMG_DEPTH_1_1   = 'd240,
    T11_1_1 = 25'sh0000000,
    T12_1_1 = 25'sh1fffa04,
    T13_1_1 = 25'sh0000000,
    T21_1_1 = 25'sh0000aa8,
    T22_1_1 = 25'sh0000000,
    T23_1_1 = 25'sh0000000,
    T31_1_1 = 25'sh0000000,
    T32_1_1 = 25'sh00ef000,
    T33_1_1 = 25'sh0001000,
// default settings for mode 2 camera 0 
    TRA_IMG_WIDTH_2_0   = 'd320,
    TRA_IMG_DEPTH_2_0   = 'd240,
    T11_2_0 = 25'sh1fff803,
    T12_2_0 = 25'sh0000000,
    T13_2_0 = 25'sh0000000,
    T21_2_0 = 25'sh0000000,
    T22_2_0 = 25'sh1fff804,
    T23_2_0 = 25'sh0000000,
    T31_2_0 = 25'sh013f000,
    T32_2_0 = 25'sh00ef000,
    T33_2_0 = 25'sh0001000,
// default settings for mode 2 camera 1 
    TRA_IMG_WIDTH_2_1   = 'd320,
    TRA_IMG_DEPTH_2_1   = 'd240,
    T11_2_1 = 25'sh1fff803,
    T12_2_1 = 25'sh0000000,
    T13_2_1 = 25'sh0000000,
    T21_2_1 = 25'sh0000000,
    T22_2_1 = 25'sh1fff804,
    T23_2_1 = 25'sh0000000,
    T31_2_1 = 25'sh013f000,
    T32_2_1 = 25'sh00ef000,
    T33_2_1 = 25'sh0001000,
// default settings for mode 3 camera 0 
    TRA_IMG_WIDTH_3_0   = 'd320,
    TRA_IMG_DEPTH_3_0   = 'd240,
    T11_3_0 = 25'sh0000000,
    T12_3_0 = 25'sh00005fc,
    T13_3_0 = 25'sh0000000,
    T21_3_0 = 25'sh1fff558,
    T22_3_0 = 25'sh0000000,
    T23_3_0 = 25'sh0000000,
    T31_3_0 = 25'sh013f000,
    T32_3_0 = 25'sh0000000,
    T33_3_0 = 25'sh0001000,
// default settings for mode 3 camera 1 
    TRA_IMG_WIDTH_3_1   = 'd320,
    TRA_IMG_DEPTH_3_1   = 'd240,
    T11_3_1 = 25'sh0000000,
    T12_3_1 = 25'sh00005fc,
    T13_3_1 = 25'sh0000000,
    T21_3_1 = 25'sh1fff558,
    T22_3_1 = 25'sh0000000,
    T23_3_1 = 25'sh0000000,
    T31_3_1 = 25'sh013f000,
    T32_3_1 = 25'sh0000000,
    T33_3_1 = 25'sh0001000
)(
    input           clk,
    input           i_enable,
    input           i_reset,
    output          o_configured,
    output [6:0]    o_addr ,
    output [24:0]   o_data ,
    output          o_we 
);

// Internal variables and registers

reg         r_configured = 0;
reg [6:0]   r_divider = 7'b0000001; // this value gives a 127 cycle pause before the initial frame is sent
reg [6:0]   r_count = 'b0;
reg [24:0]  r_data = 'b0;
reg         r_we = 'b0;



//------------------ synchonus logic------------------
always @ (posedge clk) begin
if(i_enable)begin
    if (i_reset || r_divider != 0 ) begin
        r_count <= 0;
        r_divider <= r_divider + 1;
        r_configured <= 0;
            if (r_divider == 'd127) r_we <= 1;
            else                    r_we <= 0;
    end
    else if ( r_count < 88 ) begin  
        r_count <= r_count + 1;
        r_we <= 1;
    end
end

        case (r_count[6:3]) // select parameter
            'd0   : begin
                        case (r_count[2:1]) // select mode
                            'd0 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data[CAM_PIXEL-1:0] <= TRA_IMG_WIDTH_0_0;
                                            'd1 :   r_data[CAM_PIXEL-1:0] <= TRA_IMG_WIDTH_0_1;
                                        endcase
                                    end
                            'd1 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data[CAM_PIXEL-1:0] <= TRA_IMG_WIDTH_1_0;
                                            'd1 :   r_data[CAM_PIXEL-1:0] <= TRA_IMG_WIDTH_1_1;
                                        endcase
                                    end
                            'd2 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data[CAM_PIXEL-1:0] <= TRA_IMG_WIDTH_2_0;
                                            'd1 :   r_data[CAM_PIXEL-1:0] <= TRA_IMG_WIDTH_2_1;
                                        endcase
                                    end
                            'd3 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data[CAM_PIXEL-1:0] <= TRA_IMG_WIDTH_3_0;
                                            'd1 :   r_data[CAM_PIXEL-1:0] <= TRA_IMG_WIDTH_3_1;
                                        endcase
                                    end
                        endcase
                    end
            'd1   : begin
                        case (r_count[2:1]) // select mode
                            'd0 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data[CAM_LINE-1:0] <= TRA_IMG_DEPTH_0_0;
                                            'd1 :   r_data[CAM_LINE-1:0] <= TRA_IMG_DEPTH_0_1;
                                        endcase
                                    end
                            'd1 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data[CAM_LINE-1:0] <= TRA_IMG_DEPTH_1_0;
                                            'd1 :   r_data[CAM_LINE-1:0] <= TRA_IMG_DEPTH_1_1;
                                        endcase
                                    end
                            'd2 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data[CAM_LINE-1:0] <= TRA_IMG_DEPTH_2_0;
                                            'd1 :   r_data[CAM_LINE-1:0] <= TRA_IMG_DEPTH_2_1;
                                        endcase
                                    end
                            'd3 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data[CAM_LINE-1:0] <= TRA_IMG_DEPTH_3_0;
                                            'd1 :   r_data[CAM_LINE-1:0] <= TRA_IMG_DEPTH_3_1;
                                        endcase
                                    end
                        endcase
                    end
            'd2   : begin
                        case (r_count[2:1]) // select mode
                            'd0 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T11_0_0;
                                            'd1 :   r_data <= T11_0_1;
                                        endcase
                                    end
                            'd1 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T11_1_0;
                                            'd1 :   r_data <= T11_1_1;
                                        endcase
                                    end
                            'd2 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T11_2_0;
                                            'd1 :   r_data <= T11_2_1;
                                        endcase
                                    end
                            'd3 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T11_3_0;
                                            'd1 :   r_data <= T11_3_1;
                                        endcase
                                    end
                        endcase
                    end
            'd3   : begin
                        case (r_count[2:1]) // select mode
                            'd0 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T12_0_0;
                                            'd1 :   r_data <= T12_0_1;
                                        endcase
                                    end
                            'd1 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T12_1_0;
                                            'd1 :   r_data <= T12_1_1;
                                        endcase
                                    end
                            'd2 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T12_2_0;
                                            'd1 :   r_data <= T12_2_1;
                                        endcase
                                    end
                            'd3 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T12_3_0;
                                            'd1 :   r_data <= T12_3_1;
                                        endcase
                                    end
                        endcase
                    end
            'd4   : begin
                        case (r_count[2:1]) // select mode
                            'd0 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T13_0_0;
                                            'd1 :   r_data <= T13_0_1;
                                        endcase
                                    end
                            'd1 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T13_1_0;
                                            'd1 :   r_data <= T13_1_1;
                                        endcase
                                    end
                            'd2 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T13_2_0;
                                            'd1 :   r_data <= T13_2_1;
                                        endcase
                                    end
                            'd3 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T13_3_0;
                                            'd1 :   r_data <= T13_3_1;
                                        endcase
                                    end
                        endcase
                    end
            'd5   : begin
                        case (r_count[2:1]) // select mode
                            'd0 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T21_0_0;
                                            'd1 :   r_data <= T21_0_1;
                                        endcase
                                    end
                            'd1 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T21_1_0;
                                            'd1 :   r_data <= T21_1_1;
                                        endcase
                                    end
                            'd2 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T21_2_0;
                                            'd1 :   r_data <= T21_2_1;
                                        endcase
                                    end
                            'd3 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T21_3_0;
                                            'd1 :   r_data <= T21_3_1;
                                        endcase
                                    end
                        endcase
                    end
            'd6   : begin
                        case (r_count[2:1]) // select mode
                            'd0 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T22_0_0;
                                            'd1 :   r_data <= T22_0_1;
                                        endcase
                                    end
                            'd1 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T22_1_0;
                                            'd1 :   r_data <= T22_1_1;
                                        endcase
                                    end
                            'd2 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T22_2_0;
                                            'd1 :   r_data <= T22_2_1;
                                        endcase
                                    end
                            'd3 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T22_3_0;
                                            'd1 :   r_data <= T22_3_1;
                                        endcase
                                    end
                        endcase
                    end
            'd7   : begin
                        case (r_count[2:1]) // select mode
                            'd0 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T23_0_0;
                                            'd1 :   r_data <= T23_0_1;
                                        endcase
                                    end
                            'd1 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T23_1_0;
                                            'd1 :   r_data <= T23_1_1;
                                        endcase
                                    end
                            'd2 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T23_2_0;
                                            'd1 :   r_data <= T23_2_1;
                                        endcase
                                    end
                            'd3 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T23_3_0;
                                            'd1 :   r_data <= T23_3_1;
                                        endcase
                                    end
                        endcase
                    end
            'd8   : begin
                        case (r_count[2:1]) // select mode
                            'd0 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T31_0_0;
                                            'd1 :   r_data <= T31_0_1;
                                        endcase
                                    end
                            'd1 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T31_1_0;
                                            'd1 :   r_data <= T31_1_1;
                                        endcase
                                    end
                            'd2 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T31_2_0;
                                            'd1 :   r_data <= T31_2_1;
                                        endcase
                                    end
                            'd3 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T31_3_0;
                                            'd1 :   r_data <= T31_3_1;
                                        endcase
                                    end
                        endcase
                    end  
            'd9   : begin
                        case (r_count[2:1]) // select mode
                            'd0 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T32_0_0;
                                            'd1 :   r_data <= T32_0_1;
                                        endcase
                                    end
                            'd1 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T32_1_0;
                                            'd1 :   r_data <= T32_1_1;
                                        endcase
                                    end
                            'd2 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T32_2_0;
                                            'd1 :   r_data <= T32_2_1;
                                        endcase
                                    end
                            'd3 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T32_3_0;
                                            'd1 :   r_data <= T32_3_1;
                                        endcase
                                    end
                        endcase
                    end
            'd10  : begin
                        case (r_count[2:1]) // select mode
                            'd0 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T33_0_0;
                                            'd1 :   r_data <= T33_0_1;
                                        endcase
                                    end
                            'd1 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T33_1_0;
                                            'd1 :   r_data <= T33_1_1;
                                        endcase
                                    end
                            'd2 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T33_2_0;
                                            'd1 :   r_data <= T33_2_1;
                                        endcase
                                    end
                            'd3 :   begin
                                        case (r_count[0]) // select camera
                                            'd0 :   r_data <= T33_3_0;
                                            'd1 :   r_data <= T33_3_1;
                                        endcase
                                    end
                        endcase
                    end          
            default: begin  
                    r_configured <= 1; // default case just in case do nothing
                    r_we <= 0;
                    end
        endcase
end
//----------- combinational logic ----------------------

assign o_configured = r_configured;
assign o_addr = r_count;
assign o_data = r_data;
assign o_we = r_we;
endmodule