module uart_tx #
(
    parameter D_W = 8,
    parameter B_TICK = 16
) 
(
    input wire rst,
    input wire clk,
    input wire baud_clk,
    input wire [D_W-1:0] input_data,
    input wire tx_start,
    output reg baud_en,
    output reg tx_data,
    output reg tx_done
);




reg [$clog2(B_TICK)-1:0] t_counter; // Counting Ticks
reg [$clog2(D_W)-1:0] bit_shifted; // Number of bits Received

// State Encoding //
enum {IDLE,START,DATA,STOP} STATE; // States

always @ (posedge clk or posedge rst) 
begin
    
    // Reset registers and state
    if(rst)begin
        STATE <= IDLE;
        t_counter <= 0;
        bit_shifted <= 0;
        tx_data <= 1; // Default state of tx bit
        baud_en <= 0;
        tx_done <= 0;
    end
    
    // State Machine begin //
    else 
    begin
        case(STATE) 

            IDLE: 
            begin
                if(tx_start) begin
                    STATE <= START;
                    t_counter <= 0;
                    baud_en <= 1;
                end
            end
            
            START: 
            begin
                tx_data <= 0;
                if(baud_clk) begin
                    if(t_counter == (B_TICK-1)) begin
                        t_counter <= 0;
                        STATE <= DATA;
                    end
                    else 
                        t_counter <= t_counter + 1;
                end
            end
            
            DATA:
            begin
                tx_data <= input_data[bit_shifted];
                if (baud_clk) begin
                    if(t_counter == (B_TICK-1)) begin
                        bit_shifted <= bit_shifted + 1;
                        t_counter <= 0;
                        if(bit_shifted == 7) begin
                            STATE <= STOP;
                        end
                    end
                    else 
                        t_counter <= t_counter + 1;
                end
            end
        
            STOP:
            begin
                if(baud_clk) begin
                    if(t_counter == (B_TICK - 1)) begin
                        tx_done <= 1;
                        tx_data <= 1;
                        STATE <= IDLE;
                    end
                    else 
                        t_counter <= t_counter +1;
                end
            end

        endcase
    end


end


endmodule