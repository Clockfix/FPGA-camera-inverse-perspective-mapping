module vertical_counter #( 
    parameter
        VSYNC_LINES = 521,
        VSYNC_DISPLAY = 480,
        VSYNC_PULSE = 2,
        VSYNC_FRONT_PORCH = 10,
        VSYNC_BACK_PORCH = 29
    )(
        //input clk,
        input i_Hsync,
        output o_Vsync,
        output o_v_display,
        output [8:0] o_v_line
        );
//----------Internal registers, constants and wariables-----
reg vsync_reg = 1'b1;
reg [9:0] counter_reg = 'h0;
reg [8:0] counter_line_reg = 'h0;
reg [2:0] r_state=VS_FRONT_PORCH, r_next=VS_FRONT_PORCH;
localparam [2:0]        VS_FRONT_PORCH  = 'h0,
                        VS_PULSE        = 'h1,
                        VS_BACK_PORCH   = 'h2,
                        VS_DISPLAY      = 'h3;

//---------state register sequential always block-----------
always @(posedge i_Hsync ) begin
        r_state <= r_next; 
end

//----next state & outputs, combinational always block------
always@(posedge i_Hsync) begin
  counter_reg <= counter_reg + 1;

    case (r_state)
      VS_FRONT_PORCH: begin
        vsync_reg <= 1'b1;
        if(counter_reg ==   VSYNC_FRONT_PORCH - 2)
            r_next <= VS_PULSE;
      end
      VS_PULSE:begin
        vsync_reg <= 1'b0;
        if(counter_reg ==   VSYNC_FRONT_PORCH +
                            VSYNC_PULSE - 2)
            r_next <= VS_BACK_PORCH;
      end
      VS_BACK_PORCH:begin
        vsync_reg <= 1'b1;
        if(counter_reg ==   VSYNC_FRONT_PORCH +
                            VSYNC_PULSE +
                            VSYNC_BACK_PORCH - 2) begin
            r_next <= VS_DISPLAY;
            counter_line_reg <= 'h0;
            end
      end
      VS_DISPLAY:begin
        vsync_reg <= 1'b1;
        counter_line_reg <= counter_line_reg + 1;
        if(counter_reg ==   VSYNC_FRONT_PORCH +
                            VSYNC_PULSE +
                            VSYNC_BACK_PORCH +
                            VSYNC_DISPLAY - 1) begin
            r_next <= VS_FRONT_PORCH;
            counter_reg <= 'h0;
        end
      end
    endcase
end

assign o_Vsync = vsync_reg;
assign o_v_display = (counter_line_reg >= 1 && counter_line_reg <= VSYNC_DISPLAY) ? 1'b1 : 1'b0 ;
assign o_v_line = counter_line_reg  - 1 ;

endmodule