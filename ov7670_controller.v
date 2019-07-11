
module ov7670_controller  ( 
            input       clk,            // 25MHz input clk
            inout       ov7670_sda,
            output      ov7670_scl,    
            input       resend,
            output      config_finished,
            output      ov7670_pwdn,
            output      ov7670_reset,
            output      ov7670_mclk );

//--------------wires and registers----------------------
   
wire [15:0] command;
wire finished;
wire taken;


localparam CAMERA_ADDR = 8'h42; // or 8'h21

//------------controls of camera-------------------------

assign ov7670_reset = 1'b1;                   // Normal mode
assign ov7670_pwdn  = 1'b0;                   // Power device up
assign ov7670_mclk  = clk;
assign config_finished = finished;

//-----------sub modules---------------------------------
i2c_sender i2c_sender ( 
            .clk(clk),            
            .ov7670_sda(ov7670_sda),
            .ov7670_scl(ov7670_scl),
            .taken(taken),
            .send(~finished),
            .id(CAMERA_ADDR),
            .register(command[15:8]),
            .value(command[7:0]) );

ov7670_registers ov7670_registers (
            .clk(clk),      
            .resend(resend),   
            .advance(taken),  
            .command(command), 
            .finished(finished) );
endmodule