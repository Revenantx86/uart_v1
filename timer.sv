module timer(clk,reset,DVSR,tick);

    // Wire and register definitions // 
    input wire clk; 
    input wire reset;
    input wire [10:0] DVSR; // 10 bit divisior value
    output reg tick;    // output trigger

    reg [10:0] r_reg;   // 10 bit register to keep counter

    // -- Control Counter -- //
    always @(posedge clk or negedge reset) begin
        if(reset) 
            r_reg <= 0;
        else if (r_reg == DVSR) //If counter reaches the dvst, reset counter
            r_reg <= 0;
        else
            r_reg <= r_reg + 1;
    end

    // -- Control Tick -- //
    always @(posedge clk or negedge reset) begin
        if(reset)
            tick <= 0;
        else if(r_reg == DVSR) // If counter reaches the DVSR, trigger tick 
            tick <= 1;
        else
            tick <= 0;
    end

endmodule