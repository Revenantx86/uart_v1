module baud_gen (clk,reset,dvsr,tick,en);

    // Wire and register definitions // 
    input wire clk; 
    input wire reset;
    input wire [8-1:0] dvsr; // 10 bit divisior value
    output reg tick;    // output trigger
    input wire en;

    reg [8-1:0] r_reg;   // 10 bit register to keep counter

    // -- Control Counter -- //
    always @(posedge clk or posedge reset) begin

        if(reset) 
            r_reg <= 0;

        else if(en)begin
            if (r_reg == dvsr) //If counter reaches the dvst, reset counter
                r_reg <= 0;
            else
                r_reg <= r_reg + 1;
        end
    
    end

    // -- Control Tick -- //
    always @(posedge clk or posedge reset) begin
        if(reset)
            tick <= 0;
        else if(r_reg == dvsr) // If counter reaches the DVSR, trigger tick 
            tick <= 1;
        else
            tick <= 0;
    end

endmodule