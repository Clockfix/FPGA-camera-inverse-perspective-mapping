// This module generate address for main memmory, where pixel data will be saved.
//
module address_gen#(
    parameter   CAM_DATA_WIDTH  = 12,
                CAM_LINE        = 9,
                CAM_PIXEL       = 10
)  (
    input                           clk,
    // inputs from camera (or transdormed image)
    input                           i_we,
    input [CAM_DATA_WIDTH-1:0]      i_data,
    input [CAM_LINE-1:0]            i_line,
    input [CAM_PIXEL-1:0]           i_pixel,
    // image size and does it need to be resized
    input [CAM_LINE-1:0]            i_imag_depth,
    input [CAM_PIXEL-1:0]           i_imag_width,
    // input                           i_imag_resized,
    // outputs
    output                          o_we,
    output [CAM_DATA_WIDTH-1:0]     o_data,
    output [16:0]                   o_addr
    );

//------------Internal variables and constants-----------

reg           r_we1 = 0;
reg           r_we2 = 0;

reg [16:0]    r_addr_wr1 = 0;
reg [16:0]    r_addr_wr2 = 0;

reg [CAM_DATA_WIDTH-1:0]    r_data1 = 0;
reg [CAM_DATA_WIDTH-1:0]    r_data2 = 0;

reg [CAM_PIXEL-1:0]    r_pixel1 = 0;
// reg [CAM_PIXEL-1:0]    r_pixel2 = 0;

reg [CAM_LINE-1:0]    r_line1 = 0;
// reg [CAM_LINE-1:0]    r_line2 = 0;

//---------------------------------------------------------
always @(posedge clk) begin

        // second cycle
        if (r_pixel1 < i_imag_width  && r_line1 < i_imag_depth  ) begin
            r_we2 <= r_we1;
            // r_line2 <= r_line1;
            // r_pixel2 <= r_pixel1;
            r_data2 <= r_data1;
            r_addr_wr2 <= r_addr_wr1 + r_pixel1[CAM_PIXEL-1:0];
        end
        else begin
                r_we2 <= 'h0;
                // r_line2 <= 'h0;
                // r_pixel2 <= 'h0;
                r_data2 <= 'h0;
                r_addr_wr2 <= 'h0;
            end 
        // first cycle
        if (i_pixel < i_imag_width && i_line < i_imag_depth ) begin

            r_we1 <= i_we;
            r_line1 <= i_line;
            r_pixel1 <= i_pixel;
            r_data1 <= i_data;
            r_addr_wr1 <= i_line[CAM_LINE-1:0] * 'd320;
        end
        else begin
                r_we1 <= 'h0;
                r_line1 <= 'h0;
                r_pixel1 <= 'h0;
                r_data1 <= 'h0;
                r_addr_wr1 <= 'h0;
            end 
   
end

assign o_we =  r_we2 ;
assign o_data =  r_data2  ;
assign o_addr =  r_addr_wr2 ;

endmodule