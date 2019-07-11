module debounce_switch(
    input clk,
    input i_switch,
    output o_switch);

    parameter c_debounce_limit=250000;// 10ms at 25MHz

reg r_state=1'b0;
reg [17:0] r_count = 0;

    always@(posedge clk)begin
        if (i_switch != r_state && r_count < c_debounce_limit)
            r_count <= r_count +1; //counter
        else if (r_count == c_debounce_limit)begin
            r_count <=0;
            r_state <= i_switch;
        end
        else
            r_count<=0;
    end

assign o_switch=r_state;

endmodule