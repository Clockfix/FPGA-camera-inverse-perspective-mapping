module overlay #(
    parameter   CAM_DATA_WIDTH  = 12,
                CAM_LINE        = 9,
                CAM_PIXEL       = 10
)  (
    input           clk,
    input                           enable,         
    // input form camera
    input                           i_we,
    input [CAM_DATA_WIDTH-1:0]      i_data,
    input [CAM_LINE-1:0]            i_line,
    input [CAM_PIXEL-1:0]           i_pixel,
    // image size and does it need to be resized
    input [CAM_LINE-1:0]            i_imag_depth,
    input [CAM_PIXEL-1:0]           i_imag_width,
    input                           i_imag_resized,
    output [CAM_LINE-1:0]           o_imag_depth,
    output [CAM_PIXEL-1:0]          o_imag_width,
    output                          o_imag_resized,
    // output
    output                          o_we,
    output [CAM_DATA_WIDTH-1:0]     o_data,
    output [CAM_LINE-1:0]           o_line,
    output [CAM_PIXEL-1:0]          o_pixel
);
//------------Internal variables and constants-----------

reg [CAM_LINE-1:0] r_line = 0;
reg [CAM_PIXEL-1:0] r_pixel = 0;
reg [CAM_DATA_WIDTH-1:0] r_data = 0;
reg r_we = 0;

//------------ syncronus logic----------------------------
always@(posedge clk) begin
    if(i_imag_resized) begin
        if (enable) begin
            if (i_line == 40 ||
                i_line == 80 ||
                i_line == 120 ||
                i_line == 160 ||
                i_line == 200 ||
                i_pixel == 40 ||
                i_pixel == 80 ||
                i_pixel == 120 ||
                i_pixel == 160 ||
                i_pixel == 200 ||
            i_pixel == 240 ||
                i_pixel == 280 ) begin
                r_line <= i_line;
                r_pixel <= i_pixel;
                r_data <= 12'h0f0;
                r_we <= i_we;
            end else begin
                r_line <= i_line;
                r_pixel <= i_pixel;
                r_data <= i_data;
                r_we <= i_we;
            end
        end else begin
            r_line <= i_line;
            r_pixel <= i_pixel;
            r_data <= i_data;
            r_we <= i_we;
        end
    end
    else begin
        if (enable) begin
            if (i_line == 80 ||
                i_line == 160 ||
                i_line == 240 ||
                i_line == 320 ||
                i_line == 400 ||
                i_pixel == 80 ||
                i_pixel == 160 ||
                i_pixel == 240 ||
                i_pixel == 320 ||
                i_pixel == 400 ||
                i_pixel == 480 ||
                i_pixel == 560 
                ) begin
                r_line <= i_line;
                r_pixel <= i_pixel;
                r_data <= 12'h0f0;
                r_we <= i_we;
            end else begin
                r_line <= i_line;
                r_pixel <= i_pixel;
                r_data <= i_data;
                r_we <= i_we;
            end
        end else begin
            r_line <= i_line;
            r_pixel <= i_pixel;
            r_data <= i_data;
            r_we <= i_we;
        end
    end
end

//------------ output logic -----------------------------
assign o_we =       r_we;
assign o_line =     r_line;
assign o_pixel =    r_pixel;
assign o_data =     r_data;

assign  o_imag_depth = i_imag_depth;
assign  o_imag_width = i_imag_width;
assign  o_imag_resized = i_imag_resized;

endmodule