`timescale 1ns / 1ps
module uart_tx_tb();

    // Parameters
    localparam D_W = 8;
    localparam B_TICK = 16;

    // Inputs
    reg rst;
    reg clk;
    reg [D_W-1:0] input_data;
    reg tx_start;
    reg [15:0] dvsr; // Adjust as per the actual divisor width in baud_gen

    // Outputs
    wire baud_en;
    wire tx_data;
    wire tx_done;
    wire baud_clk;

    // Instantiate the UART TX module
    uart_tx #(
        .D_W(D_W),
        .B_TICK(B_TICK)
    ) uart_tx_inst (
        .rst(rst),
        .clk(clk),
        .baud_clk(baud_clk),
        .input_data(input_data),
        .tx_start(tx_start),
        .baud_en(baud_en),
        .tx_data(tx_data),
        .tx_done(tx_done)
    );

    // Instantiate the baud generator module
    // Update the parameters and ports according to your baud_gen module
    baud_gen #() baud_gen_inst (
        .clk(clk),
        .rst(rst),
        .dvsr(dvsr),
        .baud_clk(baud_clk),
        .baud_en(baud_en)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    // Test stimulus
    initial begin
        // Initialize Inputs
        rst = 1;
        input_data = 0;
        tx_start = 0;
        dvsr = 8'd54; // Example divisor value

        // Apply Reset
        #100;
        rst = 0;

        // Example: Transmit a byte
        #100;
        input_data = 8'b01010101; // Example data
        tx_start = 1;
        #10;
        tx_start = 0;

        // Wait for transmission to complete
        wait(tx_done == 1);

        // Add more test cases as needed

        // Finish the simulation
        #1000;
        $finish;
    end

    // Detailed Monitoring to Observe Ticks
    initial begin
        // Initialize VCD dump
        $dumpfile("behaivoral_tests/vcd/uart_tx.vcd");
        $dumpvars(0, uart_tx_tb);
    end

endmodule
