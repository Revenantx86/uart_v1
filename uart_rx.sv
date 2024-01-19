module uart_rx 
# 
(
    parameter D_W = 8,
    parameter B_TICK = 16
)
(
    input rst,
    input clk,
    input tick,
    output reg[D_W-1:0] out_data,
    input rx_data,
    output reg en
);

reg [$clog2(B_TICK)-1:0] t_counter; // Counting Ticks
reg [$clog2(D_W)-1:0] nbits; // Number of bits Received


//state encoding

enum {IDLE,START,DATA,STOP} STATE; // States

// -- -- State Machine -- -- //
// Cases -> IDLE, START, DATA, STOP
always @(posedge clk) begin
    if(rst) begin
        STATE <= IDLE;
        t_counter <= 0;
        nbits <= 0;
        out_data <= 0;
        en <= 0;
    end
    else begin
        case(STATE)     
            IDLE: begin
                if(rx_data == 0) begin
                    STATE <= START;
                    t_counter <= 0;
                    en <= 1;
                end
            end
            START: begin
                if(tick) begin
                    if(t_counter == 7) begin
                        STATE <= DATA;
                        t_counter <= 0;
                        nbits <= 0;
                    end                        
                    else
                        t_counter <= t_counter + 1;
                end        
            end
            DATA: begin
                if(tick) begin
                    if(t_counter == 15) begin
                        t_counter <= 0;
                        out_data <= {rx_data,out_data[7:1]};
                        if(nbits == (D_W-1))
                            STATE <= STOP;
                        else
                            nbits <= nbits + 1;
                    end
                    else
                        t_counter <= t_counter + 1;
                end
            end
            STOP: begin
                if(tick) begin
                    if(t_counter == 15)
                        STATE <= IDLE;
                    else
                        t_counter <= t_counter + 1;
                end
            end
        endcase
    end
end

endmodule