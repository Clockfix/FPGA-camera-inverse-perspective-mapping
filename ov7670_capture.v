module ov7670_capture #(
    parameter   CAM_DATA_WIDTH = 12,
                CAM_LINE = 9,
                CAM_PIXEL = 10
)(
        output                          we,
        output [CAM_DATA_WIDTH-1:0]     o_data_wr,
        output [CAM_LINE-1:0]           o_line,
        output [CAM_PIXEL-1:0]          o_pixel,
        input           reset,
        input           ov7670_pclk,
        input           ov7670_vs,
        input           ov7670_hs,
        input  [7:0]    ov7670_data  
        );

//-----------internal regiters and wires-----------------

reg [1:0] pixel_counter = 'h0;
/* //   YUV grayscale mode
reg [7:0] u;        // U=B-Y
reg [7:0] v;        // V=R-Y
reg [7:0] y0;       // Y=0.59G + 0.31R + 0.11B
reg [7:0] y1;       // Y=0.59G + 0.31R + 0.11B
*/
    // Color mode RGB 565
reg [7:0] byte1 = 'h0;
reg [7:0] byte2 = 'h0;
reg [7:0] byte3 = 'h0;
reg [7:0] byte4 = 'h0;

reg [CAM_LINE-1:0]  line = 'h0;
reg [CAM_PIXEL-1:0] pixel = 'h0;
reg                 vsync_old_reg = 'h0;
reg                 hsync_old_reg = 'h0;


//-------------------------------------------------------
always@(posedge ov7670_pclk)begin
    vsync_old_reg <= ov7670_vs;
    hsync_old_reg <= ov7670_hs;
end

//-------------------------------------------------------

always@(posedge ov7670_pclk ||  reset)begin
    if (ov7670_hs== 0 || reset == 1) begin
      pixel_counter <= 0;
    end

    if (ov7670_hs == 1 && ov7670_vs== 0 ) begin

        case (pixel_counter)
      /*    // YUV grayscale mode
            2'b00: u    <= ov7670_data;
            2'b01: y0   <= ov7670_data;
            2'b10: v    <= ov7670_data;
            2'b11: y1   <= ov7670_data;
      */    // RGB color mode               
            2'b00: byte1   <= ov7670_data;
            2'b01: byte2   <= ov7670_data;
            2'b10: byte3   <= ov7670_data;
            2'b11: byte4   <= ov7670_data;  
        endcase

        if ( pixel_counter[0] == 1 ) begin
            if (pixel < 639 ) 
                pixel <= pixel +1;
        end
    
        pixel_counter <= pixel_counter + 1;
    end

    if(hsync_old_reg==1 && ov7670_hs==0) begin
            pixel <= 0;
            line <= line + 1;
    end

    if(vsync_old_reg==1 && ov7670_vs == 0) begin
        line <= 0;
    end
end

assign o_pixel  = pixel;//[9:1];
assign o_line   = line;//[8:1];
assign we = (pixel_counter[0]==1'b1) ? 1'b1 : 1'b0;
//assign we = (pixel_counter==2'b11) ? 1'b1 : 1'b0;

// -------------- grayscale image from YUV ------------------------
/*
assign o_data_wr =  {y0[7:4],
                     y0[7:4],
                     y0[7:4]
                     };
*/
//--------------- color RGB mode ---------------------------------

assign o_data_wr = pixel_counter[1]  ? 
                    { byte1[7:4],
                    { byte1[2:0],byte2[7] },
                      byte2[4:1]
                     }
                     :
                    { byte3[7:4],
                    { byte3[2:0],byte4[7] },
                      byte4[4:1]
                     };

endmodule