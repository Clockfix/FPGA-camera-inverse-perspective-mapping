/*
   Module was made using paper:
   Coding And Scripting Techniques For FSM Designs With
   Synthesis-Optimized, Glitch-Free Outputs

   by Clifford E. Cummings    Sunburst Design, Inc.
*/
module bin_7segment(
    input           clk,  // clock working with 10kHz
    input   [15:0]  sw,   // switches (input)
    output  [6:0]   seg,  // individual segments of number
    output  [3:0]   an,   // anode to select character
    output          dp    // dot on 7segment display
    );

//-------------Internal Constants---------------------------
parameter SIZE = 2;
parameter [SIZE-1:0]    ONE     = 2'b00,
                        TWO     = 2'b01,
                        THREE   = 2'b10,
                        FOUR    = 2'b11;

reg [SIZE-1:0] state=ONE, next=TWO;
reg [3:0] nibble = 'b0 ;

//---------State register sequential always block-----------
always @(posedge clk ) begin
    state <= next;
end
//----Next state & outputs, combinational always block------

always@(state or sw)begin
  case(state)
    ONE : begin 
        next <= TWO;
        nibble <= sw[3:0]; 
    end
    TWO : begin
        next <= THREE;
        nibble <= sw[7:4];
    end
    THREE : begin 
        next <= FOUR;
        nibble <= sw[11:8];
    end
    FOUR : begin 
        next <= ONE;
        nibble <= sw[15:12];
    end
  endcase
end

  assign seg[6] = ( nibble == 4'h2 ||
                    nibble == 4'h3 ||
                    nibble == 4'h4 ||
                    nibble == 4'h5 ||
                    nibble == 4'h6 ||
                    nibble == 4'h8 ||
                    nibble == 4'h9 ||
                    nibble == 4'hA ||
                    nibble == 4'hB ||
                    nibble == 4'hD ||
                    nibble == 4'hE ||
                    nibble == 4'hF ) ? 1'b0 : 1'b1;
  assign seg[5] = ( nibble == 4'h0 ||
                    nibble == 4'h4 ||
                    nibble == 4'h5 ||
                    nibble == 4'h6 ||
                    nibble == 4'h8 ||
                    nibble == 4'h9 ||
                    nibble == 4'hA ||
                    nibble == 4'hB ||
                    nibble == 4'hC ||
                    nibble == 4'hE ||
                    nibble == 4'hF ) ? 1'b0 : 1'b1;
  assign seg[4] = ( nibble == 4'h0 ||
                    nibble == 4'h2 ||
                    nibble == 4'h6 ||
                    nibble == 4'h8 ||
                    nibble == 4'hA ||
                    nibble == 4'hB ||
                    nibble == 4'hC ||
                    nibble == 4'hD ||
                    nibble == 4'hE ||
                    nibble == 4'hF ) ? 1'b0 : 1'b1;
  assign seg[3] = ( nibble == 4'h0 ||
                    nibble == 4'h2 ||
                    nibble == 4'h3 ||
                    nibble == 4'h5 ||
                    nibble == 4'h6 ||
                    nibble == 4'h8 ||
                    nibble == 4'h9 ||
                    nibble == 4'hB ||
                    nibble == 4'hC ||
                    nibble == 4'hD ||
                    nibble == 4'hE ) ? 1'b0 : 1'b1;
  assign seg[2] = ( nibble == 4'h0 ||
                    nibble == 4'h1 ||
                    nibble == 4'h3 ||
                    nibble == 4'h4 ||
                    nibble == 4'h5 ||
                    nibble == 4'h6 ||
                    nibble == 4'h7 ||
                    nibble == 4'h8 ||
                    nibble == 4'h9 ||
                    nibble == 4'hA ||
                    nibble == 4'hB ||
                    nibble == 4'hD ) ? 1'b0 : 1'b1;
  assign seg[1] = ( nibble == 4'h0 ||
                    nibble == 4'h1 ||
                    nibble == 4'h2 ||
                    nibble == 4'h3 ||
                    nibble == 4'h4 ||
                    nibble == 4'h7 ||
                    nibble == 4'h8 ||
                    nibble == 4'h9 ||
                    nibble == 4'hA ||
                    nibble == 4'hD ) ? 1'b0 : 1'b1;
  assign seg[0] = ( nibble == 4'h0 ||
                    nibble == 4'h2 ||
                    nibble == 4'h3 ||
                    nibble == 4'h5 ||
                    nibble == 4'h6 ||
                    nibble == 4'h7 ||
                    nibble == 4'h8 ||
                    nibble == 4'h9 ||
                    nibble == 4'hA ||
                    nibble == 4'hC ||
                    nibble == 4'hE ||
                    nibble == 4'hF) ? 1'b0 : 1'b1;
  assign dp = 1'b1;     //dot

  assign an[0] = (state==ONE)   ? 1'b0 : 1'b1;   
  assign an[1] = (state==TWO)   ? 1'b0 : 1'b1;
  assign an[2] = (state==THREE) ? 1'b0 : 1'b1;
  assign an[3] = (state==FOUR)  ? 1'b0 : 1'b1;
  
endmodule