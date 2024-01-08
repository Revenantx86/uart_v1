`timescale 1ns / 1ps

module timer_testbench;

    // Testbench Signals
    reg clk;
    reg reset;
    reg [10:0] DVSR;
    wire tick;

    // Instantiate the timer module
    timer uut (
        .clk(clk),
        .reset(reset),
        .DVSR(DVSR),
        .tick(tick)
    );

    // Clock Generation (100 MHz clock -> period is 10 ns)
    always #1 clk = ~clk; // 5 ns high and 5 ns low

    // Testbench Logic
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        DVSR = 11'd54; // Adjusted for 9600 baud rate
        #10; // Wait for the reset

        reset = 0;
        
        // Run the simulation for a certain period to observe ticks
        #1000; // Run for 1000 ns (1 us)

        // End the simulation
        $finish;
    end

    // Detailed Monitoring to Observe Ticks
    initial begin
        $monitor("Time = %t ns, DVSR = %d, Tick = %b", $time, DVSR, tick);

        // Initialize VCD dump
        $dumpfile("timer_testbench.vcd");
        $dumpvars(0, timer_testbench);

    end

endmodule
