module rgb2gray #(
    parameter   r_koef = 17,      //  0.3   in binary
                g_koef = 37,      //  0.59  in binary
                b_koef = 7 ,      //  0.11  in binary
                CAM_DATA_WIDTH  = 12,
                CAM_LINE        = 9,
                CAM_PIXEL       = 10  
) (
    input           clk,
    input           gray,       // outputs gray if HIGH
    // input form camera
    input                           i_we,
    input [CAM_DATA_WIDTH-1:0]      i_data_wr,
    input [CAM_LINE-1:0]            i_line,
    input [CAM_PIXEL-1:0]           i_pixel,
    // output
    output                          o_we,
    output [CAM_DATA_WIDTH-1:0]     o_data_wr,
    output [CAM_LINE-1:0]           o_line,
    output [CAM_PIXEL-1:0]          o_pixel

);
//------------Internal variables and constants-----------

reg           r_we1 = 0;
reg           r_we2 = 0;
reg           r_we3 = 0;

reg [CAM_LINE-1:0]     r_line1;  
reg [CAM_LINE-1:0]     r_line2; 
reg [CAM_LINE-1:0]     r_line3; 

reg [CAM_PIXEL-1:0]     r_pixel1;  
reg [CAM_PIXEL-1:0]     r_pixel2;
reg [CAM_PIXEL-1:0]     r_pixel3;

reg [10:0]    r_red1 = 0;
reg [10:0]    r_green1 = 0;
reg [10:0]    r_blue1 = 0;
reg [10:0]    r_data2 = 0;
reg [10:0]    r_data3 = 0;


always@(posedge clk) begin
// 3rd cycle
    r_we3 <=    r_we2;
    r_pixel3 <= r_pixel2;
    r_line3 <=  r_line2;
    r_data3 <=  r_data2;
// second cycle
    r_we2 <=    r_we1;
    r_pixel2 <= r_pixel1;
    r_line2 <=  r_line1;
    r_data2 <=  r_red1 + r_green1 + r_blue1;
// first cycle
    r_we1 <=    i_we;
    r_pixel1 <= i_pixel;
    r_line1 <=  i_line;
    r_red1 <=   i_data_wr[11:8] * r_koef;
    r_green1 <= i_data_wr[7:4] * g_koef;
    r_blue1 <=  i_data_wr[3:0] * r_koef;

end

assign o_we =       ~gray ? i_we        :   r_we3;
assign o_line =     ~gray ? i_line      :   r_line3;
assign o_pixel =    ~gray ? i_pixel     :   r_pixel3;
assign o_data_wr =  ~gray ? i_data_wr   :   
                            r_data3[10] ? 
                            12'hfff     : {r_data3[9:6],r_data3[9:6],r_data3[9:6]}; // if overflow send all 1

endmodule