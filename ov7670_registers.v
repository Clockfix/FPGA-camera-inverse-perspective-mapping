// VHDL code: http://hamsterworks.co.nz/mediawiki/index.php/OV7670_camera
//
// Description: Register settings for the OV7670 Caamera (partially from OV7670.c
//              in the Linux Kernel
//
module ov7670_registers(
    input   clk,      //: in  STD_LOGIC;
    input   resend,   //: in  STD_LOGIC;
    input   advance,  //: in  STD_LOGIC;
    output [15:0] command, //: out  std_logic_vector(15 downto 0);
    output  finished //: out  STD_LOGIC
);

reg [15:0] sreg;    //  : std_logic_vector(15 downto 0);
reg [8:0] address = 'h0;    //: std_logic_vector(7 downto 0) := (others => '0');

reg r_resend_old = 0;

always@(posedge clk) begin
    r_resend_old <= resend;
end


always@(posedge clk) begin
    if (r_resend_old == 1 && resend == 0 ) begin 
        address <= 'h0;
    end
    else if (advance == 1) begin
        address <= address + 1;
    end

        case (address)
// // new settings
//             	8'h00 : sreg <= 16'h1280; // COM7   Reset
// 				8'h01 : sreg <= 16'h1280; // COM7   Reset
                
// 				8'h02 : sreg <= 16'h1204; // COM7   Size & RGB output
// 				8'h03 : sreg <= 16'h1100; // CLKRC  Prescaler - Fin/(1+1)
// 				8'h04 : sreg <= 16'h0C00; // COM3   Lots of stuff, enable scaling, all others off
// 				8'h05 : sreg <= 16'h3E00; // COM14  PCLK scaling off
				
//    			    8'h06 : sreg <= 16'h8C00; // RGB444 Set RGB format
//    			    8'h07 : sreg <= 16'h0400; // COM1   no CCIR601
//  				8'h08 : sreg <= 16'h4010; // COM15  Full 0-255 output, RGB 565
// 				8'h09 : sreg <= 16'h3a04; // TSLB   Set UV ordering,  do not auto-reset window
// 				8'h0A : sreg <= 16'h1438; // COM9  - AGC Celling
// 				8'h0B : sreg <= 16'h4fb3; // MTX1  - colour conversion matrix
// 				8'h0C : sreg <= 16'h50b3; // MTX2  - colour conversion matrix
// 				8'h0D : sreg <= 16'h5100; // MTX3  - colour conversion matrix
// 				8'h0E : sreg <= 16'h523d; // MTX4  - colour conversion matrix
// 				8'h0F : sreg <= 16'h53a7; // MTX5  - colour conversion matrix
// 				8'h10 : sreg <= 16'h54e4; // MTX6  - colour conversion matrix
// 				8'h11 : sreg <= 16'h589e; // MTXS  - Matrix sign and auto contrast
// 				8'h12 : sreg <= 16'h3dc0; // COM13 - Turn on GAMMA and UV Auto adjust
// 				8'h13 : sreg <= 16'h1100; // CLKRC  Prescaler - Fin/(1+1)
				
// 				8'h14 : sreg <= 16'h1713; // HSTART HREF start (high 8 bits)
// 				8'h15 : sreg <= 16'h1801; // HSTOP  HREF stop (high 8 bits)
// 				8'h16 : sreg <= 16'h32b6; // HREF   Edge offset and low 3 bits of HSTART and HSTOP
				
// 				8'h17 : sreg <= 16'h1902; // VSTART VSYNC start (high 8 bits)
// 				8'h18 : sreg <= 16'h1A7a; // VSTOP  VSYNC stop (high 8 bits) 
// 				8'h19 : sreg <= 16'h030a; // VREF   VSYNC low two bits
         
//             8'h1A : sreg <= 16'h0e61; // COM5(0x0E) 0x61
//             8'h1B : sreg <= 16'h0f4b; // COM6(0x0F) 0x4B 
            
//             8'h1C : sreg <= 16'h1602; //
//             8'h1D : sreg <= 16'h1e37; // MVFP (0x1E) 0x07  -- FLIP AND MIRROR IMAGE 0x3x

//             8'h1E : sreg <= 16'h2102;
//             8'h1F : sreg <= 16'h2291;
            
//             8'h20 : sreg <= 16'h2907;
//             8'h21 : sreg <= 16'h330b;
                                  
//             8'h22 : sreg <= 16'h350b;
//             8'h23 : sreg <= 16'h371d;
                                  
//             8'h24 : sreg <= 16'h3871;
//             8'h25 : sreg <= 16'h392a;
                                   
//             8'h26 : sreg <= 16'h3c78; // COM12 (0x3C) 0x78
//             8'h27 : sreg <= 16'h4d40; 
                                  
//             8'h28 : sreg <= 16'h4e20;
//             8'h29 : sreg <= 16'h6900; // GFIX (0x69) 0x00
                                   
//             8'h2A : sreg <= 16'h6b4a;
//             8'h2B : sreg <= 16'h7410;
                                  
//             8'h2C : sreg <= 16'h8d4f;
//             8'h2D : sreg <= 16'h8e00;
                                   
//             8'h2E : sreg <= 16'h8f00;
//             8'h2F : sreg <= 16'h9000;
                                  
//             8'h30 : sreg <= 16'h9100;
//             8'h31 : sreg <= 16'h9600;
                                  
//             8'h32 : sreg <= 16'h9a00;
//             8'h33 : sreg <= 16'hb084;
                                  
//             8'h34 : sreg <= 16'hb10c;
//             8'h35 : sreg <= 16'hb20e;
                                  
//             8'h36 : sreg <= 16'hb382;
//             8'h37 : sreg <= 16'hb80a;
//             // settings added by me
//             8'h38 : sreg <= 16'h13e7; // enable AWB                 from sw aplication notes
//             8'h39 : sreg <= 16'h6f9f; // Simple White Balance       from sw aplication notes
            
//             8'h40 : sreg <= 16'h411A; // De-noise auto-adjustment +  AWB gain enable + Color matrix coefficient double option 0: Original matrix
//             8'h41 : sreg <= 16'h7700; // Register 77  Bit[7:0]:Offset, de-noise range control

// // old settings

            8'd00 :  sreg <= 16'h1280;  // COM7   Reset
            8'd01 :  sreg <= 16'h1280;  // COM7   Reset
            8'd02 :  sreg <= 16'h1204;  // COM7   Size & RGB output
            8'd03 :  sreg <= 16'h1100;  // CLKRC  Prescaler - Fin/(1+1)
            8'd04 :  sreg <= 16'h0C00;  // COM3   Lots of stuff, enable scaling, all others off
            8'd05 :  sreg <= 16'h3E00;  // COM14  PCLK scaling off
            
            8'd06 :  sreg <= 16'h8C00;  // RGB444 Set RGB format
            8'd07 :  sreg <= 16'h0400;  // COM1   no CCIR601
            8'd08 :  sreg <= 16'h4010;  // COM15  Full 0-255 output, RGB 565
            8'd09 :  sreg <= 16'h3a04;  // TSLB   Set UV ordering,  do not auto-reset window
            8'd10 :  sreg <= 16'h1438;  // COM9  - AGC Celling
            	8'd11 : sreg <= 16'h4fb3; // MTX1  - colour conversion matrix
				8'd12 : sreg <= 16'h50b3; // MTX2  - colour conversion matrix
				8'd13 : sreg <= 16'h5100; // MTX3  - colour conversion matrix
				8'd14 : sreg <= 16'h523d; // MTX4  - colour conversion matrix
				8'd15 : sreg <= 16'h53a7; // MTX5  - colour conversion matrix
				8'd16 : sreg <= 16'h54e4; // MTX6  - colour conversion matrix

            8'd17 :  sreg <= 16'h581e;  // 16'h589e;  // MTXS  - Matrix sign and auto contrast
            8'd18 :  sreg <= 16'h3dc0;  // COM13 - Turn on GAMMA and UV Auto adjust
            
            8'd19 :  sreg <= 16'h1713;  // HSTART HREF start (high 8 bits)
            8'd20 :  sreg <= 16'h1801;  // HSTOP  HREF stop (high 8 bits)
            8'd21 :  sreg <= 16'h32b6;  // HREF   Edge offset and low 3 bits of HSTART and HSTOP
            
            8'd22 :  sreg <= 16'h1902;  // VSTART VSYNC start (high 8 bits)
            8'd23 :  sreg <= 16'h1A7a;  // VSTOP  VSYNC stop (high 8 bits) 
            8'd24 :  sreg <= 16'h030a;  // VREF   VSYNC low two bits
 //
            // 8'd26 :  sreg <= 16'h0e61;  // COM5(0x0E) 0x61
            // 8'd27 :  sreg <= 16'h0f4b;  // COM6(0x0F) 0x4B 
            
            // 8'd28 :  sreg <= 16'h1602;  // 
            // 8'd29 :  sreg <= 16'h1e37;  // MVFP (0x1E) 0x07  // FLIP AND MIRROR IMAGE 0x3x

            // 8'd30 :  sreg <= 16'h2102;  
            // 8'd31 :  sreg <= 16'h2291;  
            
            // 8'd32 :  sreg <= 16'h2907;  
            // 8'd33 :  sreg <= 16'h330b;  
                                  
            // 8'd34 :  sreg <= 16'h350b;  
            // 8'd35 :  sreg <= 16'h371d;  
                                  
            // 8'd36 :  sreg <= 16'h3871;  
            // 8'd37 :  sreg <= 16'h392a; 
            // 8'd26 :  sreg <= 16'h3c78;
          
//

            // 8'd38 :  sreg <= 16'h3c78;  // COM12 (0x3C) 0x78
            // 8'd39 :  sreg <= 16'h4d40;  
                                  
            // 8'd40 :  sreg <= 16'h4e20;  
            // 8'd41 :  sreg <= 16'h6900;  // GFIX (0x69) 0x00
                                   
            // 8'd42 :  sreg <= 16'h6b4a;  
            // 8'd43 :  sreg <= 16'h7410;  
                                  
            // 8'd44 :  sreg <= 16'h8d4f;  
            // 8'd45 :  sreg <= 16'h8e00;  
                                   
            // 8'd26 :  sreg <= 16'h8f00;  
            // 8'd27 :  sreg <= 16'h9000;  
 //                                 
            8'd25 :  sreg <= 16'h9100;  
            8'd26 :  sreg <= 16'h9600;  
                                  
            8'd27 :  sreg <= 16'h9a00;  
            8'd28 :  sreg <= 16'hb084;  
                                  
            8'd29 :  sreg <= 16'hb10c;  
            8'd30 :  sreg <= 16'hb20e;  
                                  
            8'd31 :  sreg <= 16'hb382;  
            8'd32 :  sreg <= 16'hb80a;  
 

// setings form fpga4students
//             	8'd00 : sreg <= 16'h1280; // COM7   Reset
// 				8'd01 : sreg <= 16'h1280; // COM7   Reset
                
// 				8'd02 : sreg <= 16'h1206; // COM7   Size & RGB output
// // 				8'd03 : sreg <= 16'h1100; // CLKRC  Prescaler - Fin/(1+1)
// // 				8'd04 : sreg <= 16'h0C00; // COM3   Lots of stuff, enable scaling, all others off
// // 				8'h05 : sreg <= 16'h3E00; // COM14  PCLK scaling off
				
//    			    8'd06 : sreg <= 16'h8C00; // RGB444 Set RGB format
// //    			    8'd07 : sreg <= 16'h0400; // COM1   no CCIR601
// //  				8'd08 : sreg <= 16'h4010; // COM15  Full 0-255 output, RGB 565
// // 				8'd09 : sreg <= 16'h3a04; // TSLB   Set UV ordering,  do not auto-reset window
// // 				8'd10 : sreg <= 16'h1438; // COM9  - AGC Celling
// // 				// 8'h0B : sreg <= 16'h4fb3; // MTX1  - colour conversion matrix
// // 				// 8'h0C : sreg <= 16'h50b3; // MTX2  - colour conversion matrix
// // 				// 8'd11 : sreg <= 16'h5100; // MTX3  - colour conversion matrix
// // 				// 8'd11 : sreg <= 16'h523d; // MTX4  - colour conversion matrix
// // 				// 8'h0F : sreg <= 16'h53a7; // MTX5  - colour conversion matrix
// // 				// 8'h10 : sreg <= 16'h54e4; // MTX6  - colour conversion matrix
// // 				// 8'd11 : sreg <= 16'h589e; // MTXS  - Matrix sign and auto contrast
// // 				8'd11 : sreg <= 16'h3dc0; // COM13 - Turn on GAMMA and UV Auto adjust
// // 				8'd12 : sreg <= 16'h1100; // CLKRC  Prescaler - Fin/(1+1)
				
// 				8'd13 : sreg <= 16'h1713; // HSTART HREF start (high 8 bits)
// 				8'd14 : sreg <= 16'h1801; // HSTOP  HREF stop (high 8 bits)
// 				8'd15 : sreg <= 16'h32b6; // HREF   Edge offset and low 3 bits of HSTART and HSTOP
				
// 				8'd16 : sreg <= 16'h1902; // VSTART VSYNC start (high 8 bits)
// 				8'd17 : sreg <= 16'h1A7a; // VSTOP  VSYNC stop (high 8 bits) 
// 				8'd18 : sreg <= 16'h030a; // VREF   VSYNC low two bits
         
//             // 8'h1A : sreg <= 16'h0e61; // COM5(0x0E) 0x61
//             // 8'h1B : sreg <= 16'h0f4b; // COM6(0x0F) 0x4B 
            
//             // 8'h1C : sreg <= 16'h1602; //
//             // 8'h1D : sreg <= 16'h1e37; // MVFP (0x1E) 0x07  // FLIP AND MIRROR IMAGE 0x3x

//             // 8'h1E : sreg <= 16'h2102;
//             // 8'h1F : sreg <= 16'h2291;
            
//             // 8'h20 : sreg <= 16'h2907;
//             // 8'h21 : sreg <= 16'h330b;
                                  
//             // 8'h22 : sreg <= 16'h350b;
//             // 8'h23 : sreg <= 16'h371d;
                                  
//             // 8'h24 : sreg <= 16'h3871;
//             // 8'h25 : sreg <= 16'h392a;
                                   
//             // 8'h26 : sreg <= 16'h3c78; // COM12 (0x3C) 0x78
//             // 8'h27 : sreg <= 16'h4d40; 
                                  
//             // 8'h28 : sreg <= 16'h4e20;
//             // 8'h29 : sreg <= 16'h6900; // GFIX (0x69) 0x00
                                   
//             // 8'h2A : sreg <= 16'h6b4a;
//             // 8'h2B : sreg <= 16'h7410;
                                  
//             // 8'h2C : sreg <= 16'h8d4f;
//             // 8'h2D : sreg <= 16'h8e00;
                                   
//             // 8'h2E : sreg <= 16'h8f00;
//             // 8'h2F : sreg <= 16'h9000;
                                  
//             // 8'h30 : sreg <= 16'h9100;
//             // 8'h31 : sreg <= 16'h9600;
                                  
//             // 8'h32 : sreg <= 16'h9a00;
//             // 8'h33 : sreg <= 16'hb084;
                                  
//             // 8'h34 : sreg <= 16'hb10c;
//             // 8'h35 : sreg <= 16'hb20e;
                                  
//             // 8'h36 : sreg <= 16'hb382;
//             // 8'h37 : sreg <= 16'hb80a;
// // settings added by me
            // 8'd19 : sreg <= 16'h13e7; // enable AWB                 from sw aplication notes
            // 8'd20 : sreg <= 16'h6f9f; // Simple White Balance       from sw aplication notes
            
            // 8'd21 : sreg <= 16'h411A; // De-noise auto-adjustment +  AWB gain enable + Color matrix coefficient double option 0: Original matrix
            // 8'd22 : sreg <= 16'h7700; // Register 77  Bit[7:0]:Offset, de-noise range control

// // Saturation + 2
// // i2c_salve_Address = 0x42;
// // write_i2c(0x4f, 0xc0);
// // write_i2c(0x50, 0xc0);
// // write_i2c(0x51, 0x00);
// // write_i2c(0x52, 0x33);
// // write_i2c(0x53, 0x8d);
// // write_i2c(0x54, 0xc0);
// // write_i2c(0x58, 0x9e);

//                 8'd23 : sreg <= 16'h4fb3; // MTX1  - colour conversion matrix
// 				8'd24 : sreg <= 16'h50b3; // MTX2  - colour conversion matrix
// 				8'd25 : sreg <= 16'h5100; // MTX3  - colour conversion matrix
// 				8'd26 : sreg <= 16'h523d; // MTX4  - colour conversion matrix
// 				8'd27 : sreg <= 16'h53a7; // MTX5  - colour conversion matrix
// 				8'd28 : sreg <= 16'h54e4; // MTX6  - colour conversion matrix
// 				8'd29 : sreg <= 16'h589e; // MTXS  - Matrix sign and auto contrast

// // setings from : http://hamsterworks.co.nz/mediawiki/index.php/OV7670_camera
        //    8'h00 :  sreg <= 16'h1280;    //COM7   Reset
        //     8'h01 :  sreg <= 16'h1280;    //COM7   Reset
        //     8'h02 :  sreg <= 16'h1100;    //CLKRC  Prescaler - Fin/(1+1)
        //     8'h03 :  sreg <= 16'h1204;    //COM7   QIF + RGB output
        //     8'h04 :  sreg <= 16'h0C04;    //COM3  Lots of stuff, enable scaling, all others off
        //     8'h05 :  sreg <= 16'h3E19;    //COM14  PCLK scaling = 0
            
        //     8'h06 :  sreg <= 16'h4010;    //COM15  Full 0-255 output, RGB 565
        //     8'h07 :  sreg <= 16'h3a04;    //TSLB   Set UV ordering,  do not auto-reset window
        //     8'h08 :  sreg <= 16'h8C00;    //RGB444 Set RGB format
            
        //     8'h09 :  sreg <= 16'h1714;    //HSTART HREF start (high 8 bits)
        //     8'h0a :  sreg <= 16'h1802;    //HSTOP  HREF stop (high 8 bits)
        //     8'h0b :  sreg <= 16'h32A4;    //HREF   Edge offset and low 3 bits of HSTART and HSTOP
        //     8'h0c :  sreg <= 16'h1903;    //VSTART VSYNC start (high 8 bits)
        //     8'h0d :  sreg <= 16'h1A7b;    //VSTOP  VSYNC stop (high 8 bits) 
        //     8'h0e :  sreg <= 16'h030a;    //VREF   VSYNC low two bits
            
        //     8'h0f :  sreg <= 16'h703a;    //SCALING_XSC
        //     8'h10 :  sreg <= 16'h7135;    //SCALING_YSC
        //     8'h11 :  sreg <= 16'h7211;    //SCALING_DCWCTR
        //     8'h12 :  sreg <= 16'h73f1;    //SCALING_PCLK_DIV
        //     8'h13 :  sreg <= 16'ha202;    //SCALING_PCLK_DELAY  PCLK scaling = 4, must match COM14
            
               default : sreg <= 16'hffff;
        endcase;

end

assign command = sreg;
assign finished = (sreg == 16'hffff) ? 1'b1 : 1'b0;

endmodule