// Default parameters for image transform module
// Four MSB are actual registers
// next two bits are one of modes selected by swishes. 4 modes are avilable
// LSB are camera bit. avilable two cameras. Camera 0 and camera 1.
//  
//
module default_reg_writer #(parameter

    CAM_LINE        = 9,
    CAM_PIXEL       = 10,

    TRA_IMG_WIDTH   = 'd320,
    TRA_IMG_DEPTH   = 'd240,
    T11 = 25'sb0_000000000000_100000000000,
    T12 = 25'sb0_000000000000_000000000000,
    T13 = 25'sb0_000000000000_000000000000,
    T21 = 25'sb0_000000000000_000000000000,
    T22 = 25'sb0_000000000000_100000000000,
    T23 = 25'sb0_000000000000_000000000000,
    T31 = 25'sb0_000000000000_000000000000,
    T32 = 25'sb0_000000000000_000000000000,
    T33 = 25'sb0_000000000001_000000000000
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

        case (r_count[6:3])
            'd0   : r_data[CAM_PIXEL-1:0] <= TRA_IMG_WIDTH;
            'd1   : r_data[CAM_LINE-1:0] <= TRA_IMG_DEPTH;
            'd2   : r_data <= T11;
            'd3   : r_data <= T12;
            'd4   : r_data <= T13;
            'd5   : r_data <= T21;
            'd6   : r_data <= T22;
            'd7   : r_data <= T23;
            'd8   : r_data <= T31;  
            'd9   : r_data <= T32;
            'd10  : r_data <= T33;          
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