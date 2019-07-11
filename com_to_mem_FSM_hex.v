//  Address are in decimal
//  value of memory in hex
// 
// 
module com_to_mem_FSM#( parameter
    ADDR_WIDTH = 17, 
    DATA_WIDTH = 12, 
    DEPTH =  76_800,
    SIZE = 4           // size for for registers FSM
)(
    input clk,
    input i_enable,
    input [7:0] din,
    input TX_Done,
    input i_RX_DV,
    output [3:0] o_state,
    output [3:0] o_byte,
    output [ADDR_WIDTH-1:0] addr_wr,
    output [ADDR_WIDTH-1:0] addr_rd,   
    output [DATA_WIDTH-1:0] data_wr,
    output write,
    // output for writing to register memory
    output [6:0]            o_addr_wr_reg,
    output [24:0]           o_data_reg,
    output                  o_we_reg
    
    );

//-------------Internal Constants---------------------------
localparam [SIZE-1:0]   IDLE            = 'h0,
                        GET_ADDR_W      = 'h1,
                        GET_VALUE_W     = 'h2,
                        WRITE_MEM       = 'h3,
                        GET_ADDR_R      = 'h4,
                        READ_MEM        = 'h5,
                        GET_ADDR_W_REG  = 'h6,
                        GET_VALUE_W_REG = 'h7,
                        WRITE_MEM_REG   = 'h8;

reg [SIZE-1:0]          r_state=IDLE, 
                        r_next=IDLE;
reg [2:0]               r_addr_byte     = 3'h0;
reg [2:0]               r_value_byte    = 3'h0;
reg                     r_RX_DV         = 1'b0;
reg                     r_RX_DV_OLD     = 1'b0;
reg                     r_RX_DV_done    = 1'b0;
//  reg for main memory
reg [ADDR_WIDTH-1:0]    r_addr_wr       = 'b0;
reg [ADDR_WIDTH-1:0]    r_addr_rd       = 'b0;
reg [DATA_WIDTH-1:0]    r_data_wr       = 'b0;
reg                     r_write         = 1'b0;
//  reg for register memory
reg [6:0]               r_addr_wr_reg   = 'b0;
reg [24:0]              r_data_reg      = 'b0;
reg                     r_we_reg        = 1'b0;

//---------state register sequential always block-----------
always @(posedge clk ) begin
    if (i_enable) begin
        r_state <= r_next;
    end 
end
//----next state & outputs, combinational always block------

always@(posedge clk) begin

   if ( r_RX_DV == 0 ) begin
        r_RX_DV <= i_RX_DV;
   end

if (r_RX_DV || r_state == READ_MEM || r_state == WRITE_MEM || r_state == WRITE_MEM_REG ) begin
if (i_enable) begin
  case(r_state)
    IDLE :  begin
                if (din==8'h70  && r_RX_DV_OLD == 1'b0   )      // if  p
                    begin
                        r_next <= GET_ADDR_W;
                        r_addr_byte <= 'h0;
                        r_data_wr <= 'h0;
                        r_addr_wr <= 'h0;                       
                    end
                else if (din==8'h72 && r_RX_DV_OLD == 1'b0   )  // if  r
                    begin
                        r_next <= GET_ADDR_R;
                        r_addr_byte <= 'h0;
                        r_addr_rd <= 'h0;
                    end
                else if (din==8'h50 && r_RX_DV_OLD == 1'b0   )  // if  P
                    begin
                        r_next <= GET_ADDR_W_REG;
                        r_addr_byte <= 'h0;
                        r_addr_wr_reg <= 'h0;
                        r_data_reg <= 'h0;
                    end
            end
    GET_ADDR_W : begin
                if (r_RX_DV_OLD == 1'b0   &&
                    ((din >= 8'h30 && din < 8'h3A) ||          // if 0-9
                    (din >= 8'h61 && din <= 8'h66) )           // if a-f
                    && r_addr_byte < 'h4 )
                    begin
                        if (din >= 8'h30 && din < 8'h3A) begin             // if 0-9
                            r_addr_wr = r_addr_wr * 'd10 + din - 'h30 ;
                            r_addr_byte <= r_addr_byte + 1;
                        end
                        
                    end
                else if
                   (r_RX_DV_OLD == 1'b0   &&
                    ((din >= 8'h30 && din < 8'h3A) ||          // if 0-9
                    (din >= 8'h61 && din <= 8'h66) )           // if a-f
                    && r_addr_byte == 'h4)
                    begin
                        if (din >= 8'h30 && din < 8'h3A) begin             // if 0-9
                            r_addr_wr = r_addr_wr * 'd10 + din - 'h30 ;
                            r_value_byte <= 'b0;
                            r_next <= GET_VALUE_W;
                        end
                                            
                    end
            end
    GET_VALUE_W : begin
                if (r_RX_DV_OLD == 1'b0    &&
                    ((din >= 8'h30 && din < 8'h3A) ||          // if 0-9
                    (din >= 8'h61 && din <= 8'h66) )           // if a-f
                    && r_value_byte < 'd2 )
                    begin
                        if (din >= 8'h30 && din < 8'h3A) begin             // if 0-9
                            r_data_wr = r_data_wr * 'h10 + din - 'h30 ;
                            r_value_byte <= r_value_byte + 1;
                        end
                        else if (din >= 8'h61 && din <= 8'h66) begin       // if a-f
                            r_data_wr = r_data_wr * 'h10 + din - 'h57 ;
                            r_value_byte <= r_value_byte + 1;
                        end
                    end
                else if
                   (r_RX_DV_OLD == 1'b0    &&
                    ((din >= 8'h30 && din < 8'h3A) ||          // if 0-9
                    (din >= 8'h61 && din <= 8'h66) )           // if a-f
                    && r_value_byte == 'd2)
                    begin
                        if (din >= 8'h30 && din < 8'h3A) begin             // if 0-9
                            r_data_wr = r_data_wr * 'h10 + din - 'h30 ;
                            r_write <= 1'b1;
                            r_next <= WRITE_MEM;
                        end
                        else if (din >= 8'h61 && din <= 8'h66) begin       // if a-f
                            r_data_wr = r_data_wr * 'h10 + din - 'h57 ;
                            r_write <= 1'b1;
                            r_next <= WRITE_MEM;
                        end
                    end
            end
    WRITE_MEM : begin
                    r_write <= 1'b0;
                    r_addr_byte <= 0;
                    r_value_byte <= 0;
                    r_next <= IDLE;
                end

    GET_ADDR_R : begin 
                if (r_RX_DV_OLD == 1'b0    &&
                    ((din >= 8'h30 && din < 8'h3A) ||          // if 0-9
                    (din >= 8'h61 && din <= 8'h66) )           // if a-f
                    && r_addr_byte < 'h4 )
                    begin
                        if (din >= 8'h30 && din < 8'h3A) begin             // if 0-9
                            r_addr_rd = r_addr_rd * 'd10 + din - 'h30 ;
                            r_addr_byte <= r_addr_byte + 1;
                        end
                       
                    end
                else if
                   (r_RX_DV_OLD == 1'b0   &&
                    ((din >= 8'h30 && din < 8'h3A) ||          // if 0-9
                    (din >= 8'h61 && din <= 8'h66) )           // if a-f
                    && r_addr_byte == 'h4)
                    begin
                        if (din >= 8'h30 && din < 8'h3A) begin             // if 0-9
                            r_addr_rd = r_addr_rd * 'd10 + din - 'h30 ;
                            r_next <= READ_MEM;
                        end
                        
                    end
            end
        
    READ_MEM : begin
        r_next <= IDLE;
        r_addr_byte <= 0;
    end
// wrinting in register memory
    GET_ADDR_W_REG : begin
                if (r_RX_DV_OLD == 1'b0   &&
                    ((din >= 8'h30 && din < 8'h3A) ||          // if 0-9
                    (din >= 8'h61 && din <= 8'h66) )           // if a-f
                    && r_addr_byte < 'h1 )
                    begin
                        if (din >= 8'h30 && din < 8'h3A) begin             // if 0-9
                            r_addr_wr_reg = r_addr_wr_reg * 'h10 + din - 'h30 ;
                            r_addr_byte <= r_addr_byte + 1;
                        end
                        else if (din >= 8'h61 && din <= 8'h66) begin       // if a-f
                            r_addr_wr_reg = r_addr_wr_reg * 'h10 + din - 'h57 ;
                            r_value_byte <= r_value_byte + 1;
                        end
                    end
                else if
                   (r_RX_DV_OLD == 1'b0   &&
                    ((din >= 8'h30 && din < 8'h3A) ||          // if 0-9
                    (din >= 8'h61 && din <= 8'h66) )           // if a-f
                    && r_addr_byte == 'h1)
                    begin
                        if (din >= 8'h30 && din < 8'h3A) begin             // if 0-9
                            r_addr_wr_reg = r_addr_wr_reg * 'h10 + din - 'h30 ;
                            r_value_byte <= 'b0;
                            r_next <= GET_VALUE_W_REG;
                        end
                        else if (din >= 8'h61 && din <= 8'h66) begin       // if a-f
                            r_addr_wr_reg = r_addr_wr_reg * 'h10 + din - 'h57 ;
                            r_value_byte <= 'b0;
                            r_next <= GET_VALUE_W_REG;
                        end                    
                    end
            end
    GET_VALUE_W_REG : begin
                if (r_RX_DV_OLD == 1'b0    &&
                    ((din >= 8'h30 && din < 8'h3A) ||          // if 0-9
                    (din >= 8'h61 && din <= 8'h66) )           // if a-f
                    && r_value_byte < 'd6 )
                    begin
                        if (din >= 8'h30 && din < 8'h3A) begin             // if 0-9
                            r_data_reg = r_data_reg * 'h10 + din - 'h30 ;
                            r_value_byte <= r_value_byte + 1;
                        end
                        else if (din >= 8'h61 && din <= 8'h66) begin       // if a-f
                            r_data_reg = r_data_reg * 'h10 + din - 'h57 ;
                            r_value_byte <= r_value_byte + 1;
                        end
                    end
                else if
                   (r_RX_DV_OLD == 1'b0    &&
                    ((din >= 8'h30 && din < 8'h3A) ||          // if 0-9
                    (din >= 8'h61 && din <= 8'h66) )           // if a-f
                    && r_value_byte == 'd6)
                    begin
                        if (din >= 8'h30 && din < 8'h3A) begin             // if 0-9
                            r_data_reg = r_data_reg * 'h10 + din - 'h30 ;
                            r_we_reg <= 1'b1;
                            r_next <= WRITE_MEM_REG;
                        end
                        else if (din >= 8'h61 && din <= 8'h66) begin       // if a-f
                            r_data_reg = r_data_reg * 'h10 + din - 'h57 ;
                            r_we_reg <= 1'b1;
                            r_next <= WRITE_MEM_REG;
                        end
                    end
            end
    WRITE_MEM_REG : begin
                    r_we_reg <= 1'b0;
                    r_addr_wr_reg <= 1'b0;
                    r_value_byte <= 1'b0;
                    r_next <= IDLE;
                end
    default: r_next <= IDLE;          // on error
  endcase
r_RX_DV <= 'b0;
end
end
end
//-------------------- assignning combionational logic----------------------------
    assign write = r_write;
    assign addr_wr = r_addr_wr  ;
    assign data_wr = r_data_wr ;
    assign addr_rd = r_addr_rd ;
    assign o_state = r_state;
    assign o_byte = (r_state == 'h1 || r_state == 'h4 ) ? r_addr_byte : r_value_byte;

    assign o_addr_wr_reg = r_addr_wr_reg;
    assign o_data_reg = r_data_reg;
    assign o_we_reg = r_we_reg;

endmodule