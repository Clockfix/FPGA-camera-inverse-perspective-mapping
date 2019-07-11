// This module devide FPGA input clock 
// by DIVIDER. 
//
//
module clock_enable_param #(
    parameter WAIT =1,
    parameter WIDTH =1
) (
    input clk,
    output enable);

reg state=1'b0;
reg [WIDTH-1:0] counter = 1'b0 ; 

always@(posedge clk)begin  
    if(counter == 0)begin
      if (state == 1) begin
        state <= 0;
        counter <= WAIT - 1;
      end
      else begin
        state <= 1;
        counter <= 0;
      end
    end
    else counter <= counter -1;
end

assign enable = state;

endmodule