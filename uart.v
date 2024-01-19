/*
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * Refik Yalcin wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a coffe or ginger ale in return.
 * ----------------------------------------------------------------------------
 *
 * File Name: uart.v
 *
 * Project: UART Communication module 
 *
 * Module Name: UART Top module 
 *
 * Description: <Universal asyncronus send/receive communicaiton protocol module implemented using verilog for gate level synthesis 
 *
 * Functional Description:
 * This file contains the top module construction of the all uart protocol modules
 *
 *
 * Revision History:
 * Rev 1.0 - <Date>, <Your Name> - Initial release
 *
 * Additional Notes:
 * - Note 1: Baud controller created
 *
 */

module uart # 
( 
    parameter D_W = 8 
    parameter B_TICK = 16;
) 
(
    input wire clk,
    input wire reset,

    // -- Input UART -- //
    input wire rxd,
    output reg txd,
);

// internal reg & wires
wire baud_clk;
reg dvsr;
wire baud_gen_en;
wire rx_data[D_W-1:0];

// Initialization of the baud rate generator 
baud_gen # ()
        baud_gen_inst  (.clk(clk), 
                        .reset(reset),
                        .dvsr(dvsr),
                        .tick(baud_clk) );

// UART RX module
uart_rx # (.D_W(D_W), .B_TICK(B_TICK))
        uart_rx_inst  ( .clk(clk),
                        .rst(rst),
                        .tick(baud_clk),
                        .out_data(rx_data),
                        .rx_data(rxd),
                        .en(baud_gen_en) );

endmodule