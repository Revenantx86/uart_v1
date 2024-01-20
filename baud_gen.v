module baud_gen #()
(
    input wire clk,
    input wire rst,
    input wire [15:0] dvsr,
    output reg baud_clk,
    input wire baud_en
);

    // Internal Wire and register definitions // 

    reg [15:0] r_reg; // 16 bit register to keep counter

    // -- Control Counter -- //
    always @(posedge clk or posedge rst) begin
        if(rst) 
            r_reg <= 0;
        else if (baud_en)
        begin
            if (r_reg == dvsr) // If counter reaches the dvst, reset counter
                r_reg <= 0;
            else
                r_reg <= r_reg + 1; // Else Keep Counting
        end
    end

    // -- Control Tick -- //
    always @(posedge clk or posedge rst) begin
        if(rst)
            baud_clk <= 0;
        else if(r_reg == dvsr) // If counter reaches the DVSR, trigger baud_clk 
            baud_clk <= 1;
        else
            baud_clk <= 0;
    end

endmodule