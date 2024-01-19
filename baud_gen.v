module baud_gen (clk,rst,dvsr,tick,en);

    // Wire and register definitions // 
    input wire clk; 
    input wire rst;
    input wire [15:0] dvsr; // 16 bit divisior value
    output reg tick;    // output trigger
    input wire en;

    reg [15:0] r_reg;   // 16 bit register to keep counter

    // -- Control Counter -- //
    always @(posedge clk or posedge rst) begin
        if(rst) 
            r_reg <= 0;
        else if (en)begin
            if (r_reg == dvsr) //If counter reaches the dvst, reset counter
                r_reg <= 0;
            else
                r_reg <= r_reg + 1;
        end
    end

    // -- Control Tick -- //
    always @(posedge clk or posedge rst) begin
        if(rst)
            tick <= 0;
        else if(r_reg == dvsr) // If counter reaches the DVSR, trigger tick 
            tick <= 1;
        else
            tick <= 0;
    end

endmodule