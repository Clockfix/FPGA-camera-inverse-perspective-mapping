module ov7670_top #(
    parameter   CAM_DATA_WIDTH  = 12,
                CAM_LINE        = 9,
                CAM_PIXEL       = 10
)(
        input       clk,      // 25MHz clk
        
        output [CAM_DATA_WIDTH-1:0]     o_data_wr,
        output                          we,
        output [CAM_LINE-1:0]           o_line,
        output [CAM_PIXEL-1:0]          o_pixel,

        output      config_finished,
        input       btn,
          
        input       ov7670_pclk,
        output      ov7670_mclk,
        input       ov7670_vs,
        input       ov7670_hs,
        input [7:0] ov7670_data,
        output      ov7670_scl,
        inout       ov7670_sda,
        output      ov7670_pwdn,
        output      ov7670_reset 
        );

//-----------internal regiters and wires-----------------

wire resend;
wire w_finished;

//---------------sub modules--------------------------

debounce_switch debounce_switch(
    .clk(clk),
    .i_switch(btn),
    .o_switch(btn_db));

ov7670_capture #(
    .CAM_DATA_WIDTH(CAM_DATA_WIDTH),
    .CAM_LINE(CAM_LINE),
    .CAM_PIXEL(CAM_PIXEL)
) ov7670_capture ( 
    .we(we),
    .reset(btn_db),             
    .o_data_wr(o_data_wr),  
    .o_line(o_line),
    .o_pixel(o_pixel),
    .ov7670_pclk(ov7670_pclk),
    .ov7670_vs(ov7670_vs),
    .ov7670_hs(ov7670_hs),
    .ov7670_data(ov7670_data)
);

ov7670_controller ov7670_controller  ( 
            .clk(clk),       
            .ov7670_sda(ov7670_sda),
            .ov7670_scl(ov7670_scl),    
            .resend(btn_db),
            .config_finished(config_finished),
            .ov7670_pwdn(ov7670_pwdn),
            .ov7670_reset(ov7670_reset),
            .ov7670_mclk(ov7670_mclk) );

endmodule