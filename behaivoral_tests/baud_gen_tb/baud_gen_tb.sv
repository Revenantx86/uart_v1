`timescale 1ns / 1ps

module baud_gen_tb;

    // Testbench Signals
    reg clk;
    reg reset;
    reg [8-1:0] dvsr;
    wire tick;

    // Instantiate the timer module
    baud_gen uut (
        .clk(clk),
        .reset(reset),
        .dvsr(dvsr),
        .tick(tick)
    );

    // Clock Generation (100 MHz clock -> period is 10 ns)
    always #1 clk = ~clk; // 5 ns high and 5 ns low

    // Testbench Logic
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        dvsr = 11'd54; // Adjusted for 9600 baud rate
        #10; // Wait for the reset

        reset = 0;
        
        // Run the simulation for a certain period to observe ticks
        #1000; // Run for 1000 ns (1 us)

        // End the simulation
        $finish;
    end

    // Detailed Monitoring to Observe Ticks
    initial begin
        $monitor("Time = %t ns, DVSR = %d, Tick = %b", $time, dvsr, tick);

        // Initialize VCD dump
        $dumpfile("behaivoral_tests/vcd/baud_gen_tb.vcd");
        $dumpvars(0, baud_gen_tb);

    end

endmodule
