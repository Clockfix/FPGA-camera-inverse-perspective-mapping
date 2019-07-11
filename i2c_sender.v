//
//  i2c sender based on VHDL code:
//  http://hamsterworks.co.nz/mediawiki/index.php/OV7670_camera
//  
//  main input clk for module 25MHz like other 
//  oc7670 top module modules of my design.
//
module i2c_sender  ( 
            input           clk,            // 25MHz input clk
            inout           ov7670_sda,
            output  reg     ov7670_scl,
            output  reg     taken,
            input           send,
            input [7:0]     id,
            input [7:0]     register,
            input [7:0]     value);

//------------- reg/wire declarations ------------------

reg [6:0]   divider = 7'b0000001; // this value gives a 127 cycle pause before the initial frame is sent
reg [31:0]  busy_sr = 32'h00000000;   
reg [31:0]  data_sr = 32'hffffffff; 

reg [15:0]  r_wait = 16'h0000;  
reg         r_wait_done = 0;

//----------- combinational logic ----------------------

assign ov7670_sda = (   busy_sr[11:10] == 2'b10 ||
                        busy_sr[20:19] == 2'b10 ||
                        busy_sr[29:28] == 2'b10 )?
                        1'bz : data_sr[31];

//---------- synchronous logic -------------------------

always@(posedge clk) begin
    
    taken <= 1'b0;
    if (busy_sr[31] == 1'b0) begin
        ov7670_scl <= 1'b1;
        if (send == 1) begin
            if (divider == 7'b0000000 && r_wait_done == 1) begin
                data_sr <= {3'b100 ,  id , 1'b0   , register , 1'b0 , value , 1'b0 , 2'b01};
                busy_sr <= {3'b111 , 9'b111111111 , 9'b111111111    , 9'b111111111 , 2'b11};
                taken <= 1;
            end
            else begin
              if (r_wait <  16'hffff) begin
                r_wait <= r_wait + 1; end // this only happens on powerup
              else begin 
                  r_wait_done <= 1; 
                  divider <= 7'b0000000;
              end
            end 
        end
    end
    else begin
        case ({busy_sr[(32-1):(32-3)] , busy_sr[2:0]}) 
                {3'b111,3'b111} : // start seq #1
                  case (divider[6 : 5])
                    2'b00 : ov7670_scl <= 1'b1;
                    2'b01 : ov7670_scl <= 1'b1;
                    2'b10 : ov7670_scl <= 1'b1;
                    default :  ov7670_scl <= 1'b1;
                  endcase
                {3'b111,3'b110} : // start seq #2
                  case (divider[6 : 5])
                    2'b00 : ov7670_scl <= 1'b1;
                    2'b01 : ov7670_scl <= 1'b1;
                    2'b10 : ov7670_scl <= 1'b1;
                    default :  ov7670_scl <= 1'b1;
                  endcase
                {3'b111,3'b100} : // start seq #3
                  case (divider[6 : 5])
                    2'b00 : ov7670_scl <= 1'b0;
                    2'b01 : ov7670_scl <= 1'b0;
                    2'b10 : ov7670_scl <= 1'b0;
                    default :  ov7670_scl <= 1'b0;
                  endcase
                {3'b110,3'b000} : // end seq #1
                  case (divider[6 : 5])
                    2'b00 : ov7670_scl <= 1'b0;
                    2'b01 : ov7670_scl <= 1'b1;
                    2'b10 : ov7670_scl <= 1'b1;
                    default :  ov7670_scl <= 1'b1;
                  endcase
                {3'b100,3'b000} : // end seq #2
                  case (divider[6 : 5])
                    2'b00 : ov7670_scl <= 1'b1;
                    2'b01 : ov7670_scl <= 1'b1;
                    2'b10 : ov7670_scl <= 1'b1;
                    default :  ov7670_scl <= 1'b1;
                  endcase
                {3'b000,3'b000} : // Idle
                  case (divider[6 : 5])
                    2'b00 : ov7670_scl <= 1'b1;
                    2'b01 : ov7670_scl <= 1'b1;
                    2'b10 : ov7670_scl <= 1'b1;
                    default :  ov7670_scl <= 1'b1;
                  endcase
                default : 
                  case (divider[6 : 5])
                    2'b00 : ov7670_scl <= 1'b0;
                    2'b01 : ov7670_scl <= 1'b1;
                    2'b10 : ov7670_scl <= 1'b1;
                    default :  ov7670_scl <= 1'b0;
                endcase 
        endcase
        if (divider == 7'b1111111 ) begin
               busy_sr <= {busy_sr[(32-2) : 0] , 1'b0};
               data_sr <= {data_sr[(32-2) : 0] , 1'b1};
               divider <= 7'b0000000;
        end
        else begin
               divider <= divider + 1;
        end
    end
end
endmodule