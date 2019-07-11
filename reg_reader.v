// Default parameters for image transform module
// Four MSB are actual registers
// next two bits are one of modes selected by swishes. 4 modes are avilable
// LSB are camera bit. avilable two cameras. Camera 0 and camera 1.
//  
//
module reg_reader #(parameter
                CAM_LINE        = 9,
                CAM_PIXEL       = 10//,
)(
    input                   clk,
    input                   i_enable,
    input  [24:0]           i_data,
    output [6:0]            o_addr_rd,
    // camera modes from input swiches
    input  [1:0]            i_cam0_mode,
    input  [1:0]            i_cam1_mode,

    // 1st camera
    output [CAM_PIXEL-1:0]  o_cam0_WIDTH,
    output [CAM_LINE-1:0]   o_cam0_DEPTH,
    output [24:0]           o_cam0_T11,
    output [24:0]           o_cam0_T12,
    output [24:0]           o_cam0_T13,
    output [24:0]           o_cam0_T21,
    output [24:0]           o_cam0_T22,
    output [24:0]           o_cam0_T23,
    output [24:0]           o_cam0_T31,
    output [24:0]           o_cam0_T32,
    output [24:0]           o_cam0_T33,

    // 2nd camera
    output [CAM_PIXEL-1:0]  o_cam1_WIDTH,
    output [CAM_LINE-1:0]   o_cam1_DEPTH,
    output [24:0]           o_cam1_T11,
    output [24:0]           o_cam1_T12,
    output [24:0]           o_cam1_T13,
    output [24:0]           o_cam1_T21,
    output [24:0]           o_cam1_T22,
    output [24:0]           o_cam1_T23,
    output [24:0]           o_cam1_T31,
    output [24:0]           o_cam1_T32,
    output [24:0]           o_cam1_T33
);

// Internal variables and registers

reg [6:0]   r_count = 'b0;
reg [24:0]  r_data = 'b0;

reg [CAM_PIXEL-1:0]         r_cam0_WIDTH   = 'b0;// 'd320;
reg [CAM_LINE-1:0]          r_cam0_DEPTH   = 'b0;// 'd240;
reg [24:0]                  r_cam0_T11 = 'b0;// 25'b0_000000000000_100000000000;
reg [24:0]                  r_cam0_T12 = 'b0;// 25'b0_000000000000_000000000000;
reg [24:0]                  r_cam0_T13 = 'b0;// 25'b0_000000000000_000000000000;
reg [24:0]                  r_cam0_T21 = 'b0;// 25'b0_000000000000_000000000000;
reg [24:0]                  r_cam0_T22 = 'b0;// 25'b0_000000000000_100000000000;
reg [24:0]                  r_cam0_T23 = 'b0;// 25'b0_000000000000_000000000000;
reg [24:0]                  r_cam0_T31 = 'b0;// 25'b0_000000000000_000000000000;
reg [24:0]                  r_cam0_T32 = 'b0;// 25'b0_000000000000_000000000000;
reg [24:0]                  r_cam0_T33 = 'b0;// 25'b0_000000000001_000000000000;

reg [CAM_PIXEL-1:0]         r_cam1_WIDTH   = 'b0;// 'd320;
reg [CAM_LINE-1:0]          r_cam1_DEPTH   = 'b0;// 'd240;
reg [24:0]                  r_cam1_T11 = 'b0;// 25'b0_000000000000_100000000000;
reg [24:0]                  r_cam1_T12 = 'b0;// 25'b0_000000000000_000000000000;
reg [24:0]                  r_cam1_T13 = 'b0;// 25'b0_000000000000_000000000000;
reg [24:0]                  r_cam1_T21 = 'b0;// 25'b0_000000000000_000000000000;
reg [24:0]                  r_cam1_T22 = 'b0;// 25'b0_000000000000_100000000000;
reg [24:0]                  r_cam1_T23 = 'b0;// 25'b0_000000000000_000000000000;
reg [24:0]                  r_cam1_T31 = 'b0;// 25'b0_000000000000_000000000000;
reg [24:0]                  r_cam1_T32 = 'b0;// 25'b0_000000000000_000000000000;
reg [24:0]                  r_cam1_T33 = 'b0;// 25'b0_000000000001_000000000000;



//--------------------------- synchonus logic------------------
always @ (posedge clk) begin
    if(i_enable)begin
        r_count <= r_count + 1;
    end

if(i_enable) begin
     case (r_count[0])
        'b0 :   begin
         case (r_count[6:3])
            'd0   : r_cam0_WIDTH <= i_data[CAM_PIXEL-1:0];
            'd1   : r_cam0_DEPTH <= i_data[CAM_LINE-1:0];
            'd2   : r_cam0_T11 <= i_data;
            'd3   : r_cam0_T12 <= i_data;
            'd4   : r_cam0_T13 <= i_data;
            'd5   : r_cam0_T21 <= i_data;
            'd6   : r_cam0_T22 <= i_data;
            'd7   : r_cam0_T23 <= i_data;
            'd8   : r_cam0_T31 <= i_data;  
            'd9   : r_cam0_T32 <= i_data;
            'd10  : r_cam0_T33 <= i_data;           
            default:  ;
        endcase
            end
        'b1 :   begin
         case (r_count[6:3])
            'd0   : r_cam1_WIDTH <= i_data[CAM_PIXEL-1:0];
            'd1   : r_cam1_DEPTH <= i_data[CAM_LINE-1:0];
            'd2   : r_cam1_T11 <= i_data;
            'd3   : r_cam1_T12 <= i_data;
            'd4   : r_cam1_T13 <= i_data;
            'd5   : r_cam1_T21 <= i_data;
            'd6   : r_cam1_T22 <= i_data;
            'd7   : r_cam1_T23 <= i_data;
            'd8   : r_cam1_T31 <= i_data;  
            'd9   : r_cam1_T32 <= i_data;
            'd10  : r_cam1_T33 <= i_data;         
            default:  ;
        endcase
            end
    endcase


end
end

//------------------ combinational logic ----------------------

assign o_addr_rd = {r_count[6:3], (r_count[0])? i_cam1_mode : i_cam0_mode , r_count[0] };

// 1st camera
assign o_cam0_WIDTH = r_cam0_WIDTH;
assign o_cam0_DEPTH = r_cam0_DEPTH;
assign o_cam0_T11 = r_cam0_T11;
assign o_cam0_T12 = r_cam0_T12;
assign o_cam0_T13 = r_cam0_T13;
assign o_cam0_T21 = r_cam0_T21;
assign o_cam0_T22 = r_cam0_T22;
assign o_cam0_T23 = r_cam0_T23;
assign o_cam0_T31 = r_cam0_T31;
assign o_cam0_T32 = r_cam0_T32;
assign o_cam0_T33 = r_cam0_T33;

// 2nd camera
assign o_cam1_WIDTH = r_cam1_WIDTH;
assign o_cam1_DEPTH = r_cam1_DEPTH;
assign o_cam1_T11 = r_cam1_T11;
assign o_cam1_T12 = r_cam1_T12;
assign o_cam1_T13 = r_cam1_T13;
assign o_cam1_T21 = r_cam1_T21;
assign o_cam1_T22 = r_cam1_T22;
assign o_cam1_T23 = r_cam1_T23;
assign o_cam1_T31 = r_cam1_T31;
assign o_cam1_T32 = r_cam1_T32;
assign o_cam1_T33 = r_cam1_T33;


endmodule