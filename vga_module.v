module vga_module#( 
    parameter
        ADDR_WIDTH = 17, 
        DATA_WIDTH = 12, 
        DEPTH =  76_800, // 307_200,//
        HSYNC_CLKS = 800,
        HSYNC_DISPLAY = 640,
        HSYNC_PULSE = 96,
        HSYNC_FRONT_PORCH = 16,
        HSYNC_BACK_PORCH = 48,
        VSYNC_LINES = 521,
        VSYNC_DISPLAY = 480,
        VSYNC_PULSE = 2,
        VSYNC_FRONT_PORCH = 10,
        VSYNC_BACK_PORCH = 29
    )(
        input clk,
        output [3:0] o_vgaRed,
        output [3:0] o_vgaBlue,
        output [3:0] o_vgaGreen,
        output o_Hsync,
        output o_Vsync,
        output o_display,
        output [ADDR_WIDTH-1:0] o_addr_rd,
        input [DATA_WIDTH-1:0] o_data_rd
        );

//-------Internal registers and wires--------------
wire w_v_display;
wire w_h_display;
wire [9:0] pixel;
wire [8:0] line;

//-------sub modules-------------------------------

horizontal_counter #( 
        .HSYNC_CLKS(HSYNC_CLKS) ,
        .HSYNC_DISPLAY(HSYNC_DISPLAY) ,
        .HSYNC_PULSE(HSYNC_PULSE) ,
        .HSYNC_FRONT_PORCH(HSYNC_FRONT_PORCH) ,
        .HSYNC_BACK_PORCH(HSYNC_BACK_PORCH) 
    ) horizontal_counter1 (
        .clk(clk),
        .o_Hsync(o_Hsync),
        .o_h_display(w_h_display),
        .o_h_pixel(pixel)
        );

vertical_counter #( 
        .VSYNC_LINES(VSYNC_LINES) ,
        .VSYNC_DISPLAY(VSYNC_DISPLAY) ,
        .VSYNC_PULSE(VSYNC_PULSE) ,
        .VSYNC_FRONT_PORCH(VSYNC_FRONT_PORCH) ,
        .VSYNC_BACK_PORCH(VSYNC_BACK_PORCH) 
    ) vertical_counter1 (
        //.clk(clk),
        .i_Hsync(o_Hsync),
        .o_Vsync(o_Vsync),
        .o_v_display(w_v_display),
        .o_v_line(line)
        );

assign o_display = (w_v_display && w_h_display) ;
assign o_vgaRed = o_display ? o_data_rd[11:8] : 4'h0;
assign o_vgaBlue = o_display ? o_data_rd[3:0] : 4'h0; 
assign o_vgaGreen = o_display ? o_data_rd[7:4] : 4'h0;

/*
assign o_addr_rd = (((line*HSYNC_DISPLAY) + pixel + 1) == HSYNC_DISPLAY * VSYNC_DISPLAY ) ?
                        'h0 : ((line[8:1]) * HSYNC_DISPLAY/2 ) + pixel[9:1] + 1 ;   // get next pixel
*/
assign o_addr_rd =  
                    ((line[8:1]) * 'd320 ) + pixel[9:1];// + 1;


endmodule