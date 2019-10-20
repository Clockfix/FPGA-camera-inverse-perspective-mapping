////////////////////////////////////////////////////////////////////
// 
//  This module alow to baypass mechanical swiches to
//  imag_procesor module or automaticly selects 
//  and changes operation and camera select mode 
// 
////////////////////////////////////////////////////////////////// 
module mode_selector#( parameter
    LIMIT = 2_0000_0000
            //counter limit when it shoud change mode
            // 100MHz -> period is 10ns
            // 5s cycle period result in 
            // limit 5/(10*10^-9)= 500*10^6
)(
    input clk,
   // input i_enable,
    input [8:0]     i_im_p,
    input autoselect,
    output [8:0]    o_im_p
);

reg [31:0] counter  = 0;
reg [5:0]  mode = 0;    // camera modes
reg [2:0]  color = 0;   // color modes
reg [1:0]  display = 0; // swiching between cameras

always@(posedge clk) begin
    if (counter < LIMIT) begin
        counter = counter + 1;
    end 
    else begin
        counter = 0;
        mode = mode + 1;
        color = color + 1;
        display = display + 1;
    end

end 

assign o_im_p = autoselect ? {color[2:1],mode[5:2],1'b0,display} 
                            : i_im_p;

endmodule