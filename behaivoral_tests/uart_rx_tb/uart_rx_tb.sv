`timescale 1ns / 1ps

module uart_rx_tb;

    // Parameters
    parameter D_W = 8;
    parameter B_TICK = 16;

    // Testbench Signals
    reg rst;
    reg clk;
    reg tick;
    wire baud;
    wire en;

    wire [D_W-1:0] out_data;
    reg rx_data;

    reg [8-1:0] dvsr;

    // Instantiate the timer module
    baud_gen baud_gen (
        .clk(clk),
        .reset(rst),
        .dvsr(dvsr),
        .tick(baud),
        .en(en)
    );

    // Instantiate the UART RX Module
    uart_rx #(.D_W(D_W), .B_TICK(B_TICK)) uart_rx (
        .rst(rst),
        .clk(clk),
        .tick(baud),
        .out_data(out_data),
        .rx_data(rx_data),
        .en(en)
    );

    // Clock Generation & Initial declarations
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz Clock
    end

    // Test Sequence
    initial begin
        // Initialize
        rst = 1;
        rx_data = 1; // Idle state of UART

        dvsr = 8'd54; // Adjusted for 115200 baud rate

        #10 rst = 0; // Release reset
        
        // Send a byte (for example 0x55)
        // Assuming LSB first transmission
        // Start bit
        #8680 rx_data = 0; // Start bit
        // Byte data
        #8680 rx_data = 1; // Bit 0
        #8680 rx_data = 0; // Bit 1
        #8680 rx_data = 1; // Bit 2
        #8680 rx_data = 0; // Bit 3
        #8680 rx_data = 1; // Bit 4
        #8680 rx_data = 0; // Bit 5
        #8680 rx_data = 1; // Bit 6
        #8680 rx_data = 1; // Bit 7
        // Stop bit
        #8680 rx_data = 1; // Stop bit
        #10000; // Wait for some time after transmission

        // Add more test cases as required

        // Finish simulation
        #100;
        $finish;
    end

    // Detailed Monitoring to Observe Ticks
    initial begin
        // Initialize VCD dump
        $dumpfile("behaivoral_tests/vcd/uart_rx.vcd");
        $dumpvars(0, uart_rx_tb);
    end

endmodule
