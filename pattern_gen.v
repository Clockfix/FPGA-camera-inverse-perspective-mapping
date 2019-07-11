// This module generates color patherns and rwite them in 
// BlockRAM memory
//
module pattern_gen #( parameter
    LINES = 480,
    COLUMNS = 640,
    DEPTH =  76_800, //307_200, //
    ADDR_WIDTH = 17,
    DATA_WIDTH = 12,
    SPEED = 2,
    SIZE = 2
)(  
    input clk,
    input i_enable,
 //   input sw,
    output [ADDR_WIDTH-1:0] o_addr,
    output [DATA_WIDTH-1:0] o_data,
    output o_write);

//-------------Internal Constants---------------------------
//reg [ADDR_WIDTH-1:0] counter_reg = 'b0;
reg [31:0] speed_counter_reg = 'b0;
//reg [DATA_WIDTH-1:0] color_reg = 'b0;

reg [3:0] red_reg = 'b0;
reg [3:0] blue_reg = 'b0;
reg [3:0] green_reg = 'b0;

reg [8:0] line_reg = 'b0;
reg [9:0] column_reg = 'b0;

reg write_reg=1'b0;
/*
localparam [SIZE-1:0]   GREEN         = 'h0,
                        RED           = 'h1,
                        BLUE          = 'h2;
reg [SIZE-1:0] state_reg=GREEN, next_reg=GREEN;


//---------state register sequential always block-----------
always @(posedge clk ) begin
    if (i_enable) begin
        state_reg <= next_reg;
    end 
end
*/
//----next state & outputs, combinational always block------

always @(posedge clk) begin
    speed_counter_reg <= speed_counter_reg + 1;
    
    if(speed_counter_reg == SPEED) begin
        write_reg <= 1'b1;
        speed_counter_reg <= 0;
        if(i_enable) begin
        //    counter_reg <= counter_reg + 1;
        if(column_reg < COLUMNS-1) begin 
            column_reg <= column_reg + 1 ;
        end
        else begin
            column_reg <= 0;
            if (line_reg< LINES -1 ) begin
                line_reg <= line_reg + 1;
            end
            else begin
                line_reg <= 0;
            end
        end 
/*
        if (line_reg < 239 ) begin
            green_reg <= 4'b1111;
        end
        else begin
            green_reg <= 4'b0000;
        end
*/

/*
        if (column_reg < 319 || column_reg  == 639) begin
            red_reg <= 4'b1111;
        end
        else begin
            red_reg <= 4'b0000;
        end
*/
        

/*
        case (state_reg)
        GREEN : begin
      
            color_reg <= 12'b111100000000;
            if(counter_reg == DEPTH - 1) begin
                next_reg <= RED;
                counter_reg <= 'b0;
            end
        end
      
        RED : begin
      
            color_reg <= 12'b000011110000;
            if(counter_reg == DEPTH - 1 ) begin
                next_reg <= BLUE;
                counter_reg <= 'b0;
            end
        end
      
        BLUE : begin
      
            color_reg <= 12'b000000001111;
            if(counter_reg == DEPTH - 1) begin
                next_reg <= GREEN;
                counter_reg <= 'b0;
            end
        end
      
        default: begin
                next_reg <= GREEN ;
                counter_reg <= 'b0;
            end
        endcase
*/
        end
    end
    else if (i_enable) write_reg <= 1'b0;
end

always@* begin
        if (line_reg < 239 ) begin
            green_reg <= 4'b1111;
        end
        else begin
            green_reg <= 4'b0000;
        end

        if (column_reg > 319 ) begin
            red_reg <= 4'b1111;
        end
        else begin
            red_reg <= 4'b0000;
        end
end


assign o_addr = (line_reg[8:1] * COLUMNS/2) + column_reg [9:1] ;
assign o_data = {green_reg, red_reg , blue_reg};
//assign o_write = sw ? write_reg : 1'b0 ;              // remowing switch
assign o_write = write_reg;

endmodule