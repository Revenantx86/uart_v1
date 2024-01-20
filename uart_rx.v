module uart_rx 
# 
(
    parameter D_W = 8,
    parameter B_TICK = 16
)
(
    input rst,
    input clk,
    input baud_clk,
    output reg[D_W-1:0] out_data,
    input rx_data,
    output reg baud_en
);

reg [$clog2(B_TICK)-1:0] t_counter; // Counting Ticks
reg [$clog2(D_W)-1:0] bit_received; // Number of bits Received


//state encoding

enum {IDLE,START,DATA,STOP} STATE; // States

// -- -- State Machine -- -- //
// Cases -> IDLE, START, DATA, STOP
always @(posedge clk) 
begin    
    // reset registers and state
    if(rst) begin
        STATE <= IDLE;
        t_counter <= 0;
        bit_received <= 0;
        out_data <= 0;
        baud_en <= 0;
    end
    
    else
    // State machine begin // 
    begin
        case(STATE)     
            
            IDLE: 
            begin
                if(rx_data == 0) begin // wait for the data low
                    STATE <= START; // change starting state
                    t_counter <= 0; // init counter
                    baud_en <= 1; // enable baud_clk generator
                end
            end

            START: 
            begin
                if(baud_clk) begin
                    if(t_counter == (((B_TICK)/2)-1) ) begin // Half baud_clk cycle reached
                        STATE <= DATA; // start data acquisition
                        t_counter <= 0; 
                        bit_received <= 0;
                    end                        
                    else
                        t_counter <= t_counter + 1;
                end        
            end

            DATA: begin
                if(baud_clk) begin
                    if(t_counter == (B_TICK-1) ) begin // Sample at the middle of the data 
                        t_counter <= 0; // Reset baud_clk counter
                        
                        out_data <= {rx_data,out_data[7:1]}; // add data to     
                        if(bit_received == (D_W-1)) // If bit size reached
                            STATE <= STOP; // stop sequence
                        else
                            bit_received <= bit_received + 1; // else increase number of bit read
                    end
                    else
                        t_counter <= t_counter + 1; // count ticks
                end
            end

            STOP: 
            begin
                if(baud_clk) begin
                    if(t_counter == (B_TICK-1) ) // If counter reached to end
                        STATE <= IDLE; // return back to idle state
                    else
                        t_counter <= t_counter + 1; // countinue count baud_clk for the stop bit
                end
            end
        endcase
    end
end

endmodule