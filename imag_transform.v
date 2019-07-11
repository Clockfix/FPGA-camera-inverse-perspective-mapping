module imag_transform #(
    parameter   CAM_DATA_WIDTH  = 12,
                CAM_LINE        = 9,
                CAM_PIXEL       = 10//,
// TRA_IMG_WIDTH   = 'd160,
// TRA_IMG_DEPTH   = 'd160,
// T11 = 25'sb0_000000000001_011001100111,
// T12 = 25'sb0_000000000000_001011001110,
// T13 = 25'sb0_000000000000_000000001100,
// T21 = 25'sb0_000000000000_000000000000,
// T22 = 25'sb0_000000000000_111011101011,
// T23 = 25'sb0_000000000000_000000000000,
// T31 = 25'sb1_111000111111_111100111111,
// T32 = 25'sb1_111110001111_111011100000,
// T33 = 25'sb0_000000000001_000000000000

) (
    input           clk,
    input [1:0]     im_p,         // image processor controls
    // input form camera
    input                           i_we,
    input  [CAM_DATA_WIDTH-1:0]      i_data,
    input  [CAM_LINE-1:0]            i_line,
    input  [CAM_PIXEL-1:0]           i_pixel,
    // output
    output                          o_we,
    output [CAM_DATA_WIDTH-1:0]     o_data,
    output [CAM_LINE-1:0]           o_line,
    output [CAM_PIXEL-1:0]          o_pixel,
    // image parameter output for address generator
    output [CAM_LINE-1:0]           o_imag_depth,
    output [CAM_PIXEL-1:0]          o_imag_width,
    output                          o_imag_resized,
    // parrameters of imag transform
    input  [CAM_PIXEL-1:0]       TRA_IMG_WIDTH ,
    input  [CAM_LINE-1:0]        TRA_IMG_DEPTH ,
    input   [24:0]               T11 ,
    input   [24:0]               T12 ,
    input   [24:0]               T13 ,
    input   [24:0]               T21 ,
    input   [24:0]               T22 ,
    input   [24:0]               T23 ,
    input   [24:0]               T31 ,
    input   [24:0]               T32 ,
    input   [24:0]               T33 
);
//------------Internal variables and constants-----------

(* KEEP = "TRUE" *) reg r_we1 = 0,
    r_we2 = 0,
    r_we3 = 0,
    r_we4 = 0,
    r_we5 = 0,
    r_we6 = 0,
    r_we7 = 0;

(* KEEP = "TRUE" *) reg [CAM_DATA_WIDTH-1:0]      
    r_data1 = 0,
    r_data2 = 0,
    r_data3 = 0,
    r_data4 = 0,
    r_data5 = 0,
    r_data6 = 0,
    r_data7 = 0;

(* KEEP = "TRUE" *) reg signed [24:0] 
    r_T11 = 0,
    r_T12 = 0,
    r_T13 = 0,
    r_T21 = 0,
    r_T22 = 0,
    r_T23 = 0,
    r_T31 = 0,
    r_T32 = 0,
    r_T33 = 0;

(* KEEP = "TRUE" *) wire signed [11:0] w_w_inv;

(* KEEP = "TRUE" *) reg [CAM_PIXEL-1:0]  r_new_x = 0;
(* KEEP = "TRUE" *) reg [CAM_LINE-1:0]   r_new_y = 0;

(* KEEP = "TRUE" *) reg signed [37:0]  
    r_temp_x3 = 0,
    r_temp_y3 = 0;

(* KEEP = "TRUE" *) reg signed [24:0]  
    r_temp_w2 = 0,
    r_temp_x2 = 0,
    r_temp_y2 = 0;

(* KEEP = "TRUE" *) reg signed [29:0] 
    r_temp_x1 = 0,
    r_temp_y1 = 0,
    r_temp_w1 = 0;

(* KEEP = "TRUE" *) reg signed [29:0] 
    r_temp_summ11= 0,
    r_temp_summ21= 0,
    r_temp_summ31= 0;

(* KEEP = "TRUE" *) reg signed [29:0] 
    r_temp_summ12= 0,
    r_temp_summ22= 0,
    r_temp_summ32= 0;

(* KEEP = "TRUE" *) reg signed [47:0]  
    r_temp_11 = 0,
    r_temp_12 = 0,
    r_temp_13 = 0,
    r_temp_21 = 0,
    r_temp_22 = 0,
    r_temp_23 = 0,
    r_temp_31 = 0,
    r_temp_32 = 0,
    r_temp_33 = 0;

(* KEEP = "TRUE" *) reg signed [CAM_PIXEL:0]    r_x = 0;
(* KEEP = "TRUE" *) reg signed [CAM_LINE :0]    r_y = 0;
(* KEEP = "TRUE" *) reg signed [1 :0]           r_w = 0;

//---------------pipeline--------------------------------
always@(posedge clk) begin
    //----------------------------------7th cycle
    if (r_temp_x3 < 0 || r_temp_x3[37:20] >= TRA_IMG_WIDTH) begin
        r_new_x <= 0;
    end else begin
        r_new_x <= r_temp_x3[20+CAM_PIXEL-1:20];
    end 

    if (r_temp_y3 < 0 || r_temp_y3[37:20] >= TRA_IMG_DEPTH) begin
        r_new_y <= 0;
    end else begin
        r_new_y <= r_temp_y3[20 + CAM_LINE-1:20];
    end  

    r_data7 <= r_data6;

    if (r_temp_y3 < 0 || r_temp_y3[37:20] >= TRA_IMG_DEPTH ||
        r_temp_x3 < 0 || r_temp_x3[37:20] >= TRA_IMG_WIDTH) begin
        r_we7 <= 0;
    end else begin
        r_we7 <= r_we6;
    end

    //----------------------------------sixth cycle
    r_temp_x3 <= r_temp_x2 * w_w_inv;     // 35bit 
    r_temp_y3 <= r_temp_y2 * w_w_inv;      

    r_data6 <= r_data5;
    r_we6 <= r_we5;
    //----------------------------------- fifth cycle
    r_temp_x2 <= r_temp_x1[24:0];      // resizing x value to fit 25x18bit multiplier
    r_temp_y2 <= r_temp_y1[24:0];      // resizing y value to fit 25x18bit multiplier
    r_temp_w2 <= r_temp_w1[24:0] ;     // 

    r_data5 <= r_data4;
    r_we5 <= r_we4;
    //----------------------------------- fourth cycle
    r_temp_x1 <= r_temp_summ11 + r_temp_summ12;
    r_temp_y1 <= r_temp_summ21 + r_temp_summ22;
    r_temp_w1 <= r_temp_summ31 + r_temp_summ32;

    r_data4 <= r_data3;
    r_we4 <= r_we3;
    //------------------------------------third cycle
    r_temp_summ11 <= r_temp_11 + r_temp_21;
    r_temp_summ12 <= r_temp_31;
    r_temp_summ21 <= r_temp_12 + r_temp_22;
    r_temp_summ22 <= r_temp_32;
    r_temp_summ31 <= r_temp_13 + r_temp_23;
    r_temp_summ32 <= r_temp_33;

    r_data3 <= r_data2;
    r_we3 <= r_we2;
    //-------------------------------------second cycle
    r_temp_11 <= r_x * r_T11;
    r_temp_21 <= r_y * r_T21;
    r_temp_31 <= r_w * r_T31;

    r_temp_12 <= r_x * r_T12;
    r_temp_22 <= r_y * r_T22;
    r_temp_32 <= r_w * r_T32;

    r_temp_13 <= r_x * r_T13;
    r_temp_23 <= r_y * r_T23;
    r_temp_33 <= r_w * r_T33;

    r_data2 <= r_data1;
    r_we2   <= r_we1;
    //-------------------------------------first cycle
    r_x     <=  i_pixel;     // saves pixel coordinates in signed register
    r_y     <=  i_line;
    r_w     <= 2'sd1;
    r_data1 <= i_data;
    r_we1   <= i_we;
    r_T11 <= T11;
    r_T12 <= T12;
    r_T13 <= T13;
    r_T21 <= T21;
    r_T22 <= T22;
    r_T23 <= T23;
    r_T31 <= T31;
    r_T32 <= T32;
    r_T33 <= T33;
    //-------------------------------------
    // matrix multiplication and new point coordinate calculation
    // 
    //                                   | T11 T12 T13 |
    // P [x,y,1] * T [3x3] = | x y 1 | * | T21 T22 T23 | = | x' y' w' | 
    //                                   | T31 T32 T33 |
    //                  | x'  y'|    
    // Pnew [x'',y''] = |---,---|
    //                  | w'  w'|
end

//--------------------sub module------------------------
lookuptable lookuptable(
    .clk(clk),
    .w(r_temp_w2[15:4]),      // inputs calculated w value
    .r_w_inv(w_w_inv)         // outputs inverted value from look up  table
);

//------------ output logic------------------------------
// assign o_we =       (im_p == 2'b00)? i_we   :   r_we7;
// assign o_data =     (im_p == 2'b00)? i_data :   r_data7;
//
// assign o_line =     (im_p == 2'b00)? i_line :   r_new_y;
// assign o_pixel =    (im_p == 2'b00)? i_pixel:   r_new_x;
//
//
// assign o_imag_depth = (im_p == 2'b00)? 'd480 : TRA_IMG_DEPTH;
// assign o_imag_width = (im_p == 2'b00)? 'd640 : TRA_IMG_WIDTH;
// assign o_imag_resized = (im_p == 2'b00)? 1'b0 : 1'b1;
// output always resized and unsing transformation matrix.
assign o_we =           r_we7;
assign o_data =         r_data7;

assign o_line =         r_new_y;
assign o_pixel =        r_new_x;

assign o_imag_depth =   TRA_IMG_DEPTH;
assign o_imag_width =   TRA_IMG_WIDTH;
assign o_imag_resized = 1'b1;

endmodule