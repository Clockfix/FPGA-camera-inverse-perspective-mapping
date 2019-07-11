module horizontal_counter #( 
    parameter
        HSYNC_CLKS = 800,
        HSYNC_DISPLAY = 640,
        HSYNC_PULSE = 96,
        HSYNC_FRONT_PORCH = 16,
        HSYNC_BACK_PORCH = 48
    )(
        input clk,
        output o_Hsync,
        output o_h_display,
        output [9:0] o_h_pixel
        );
//----------Internal registers, constants and wariables-----
reg hsync_reg = 1'b1;
reg [9:0] counter_reg = 'h0;
reg [9:0] counter_pixel_reg = 'h0;
reg [2:0] r_state=HS_FRONT_PORCH, r_next=HS_FRONT_PORCH;
localparam [2:0]        HS_FRONT_PORCH  = 'h0,
                        HS_PULSE        = 'h1,
                        HS_BACK_PORCH   = 'h2,
                        HS_DISPLAY      = 'h3;

//---------state register sequential always block-----------
always @(posedge clk ) begin
        r_state <= r_next; 
end
//----next state & outputs, combinational always block------


always@(posedge clk) begin
  counter_reg <= counter_reg + 1;

    case (r_state)
      HS_FRONT_PORCH: begin
        hsync_reg <= 1'b1;
        if(counter_reg ==   HSYNC_FRONT_PORCH - 2)
            r_next <= HS_PULSE;
      end
      HS_PULSE:begin
        hsync_reg <= 1'b0;
        if(counter_reg ==   HSYNC_FRONT_PORCH +
                            HSYNC_PULSE - 2)
            r_next <= HS_BACK_PORCH;
      end
      HS_BACK_PORCH:begin
        hsync_reg <= 1'b1;
        if(counter_reg ==   HSYNC_FRONT_PORCH +
                            HSYNC_PULSE +
                            HSYNC_BACK_PORCH - 2) begin
            r_next <= HS_DISPLAY;
            counter_pixel_reg <= 'h0;
            end
      end
      HS_DISPLAY:begin
        hsync_reg <= 1'b1;
        counter_pixel_reg <= counter_pixel_reg + 1;
        if(counter_reg ==   HSYNC_FRONT_PORCH +
                            HSYNC_PULSE +
                            HSYNC_BACK_PORCH +
                            HSYNC_DISPLAY - 1) begin
            r_next <= HS_FRONT_PORCH;
            counter_reg <= 'h0;
        end
      end
    endcase
end

assign o_Hsync = hsync_reg;
assign o_h_display = (counter_pixel_reg >= 1 && counter_pixel_reg <= HSYNC_DISPLAY) ? 1'b1 : 1'b0 ;
assign o_h_pixel = counter_pixel_reg - 1 ;

endmodule