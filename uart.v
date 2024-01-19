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
    parameter D_W = 8,
    parameter B_TICK = 16
) 
(
    input wire clk,
    input wire rst,

    // -- Input UART -- //
    input wire rxd,

    // -- input to baud_gen -- //
    input wire [15:0] dvsr,
    

    // -- uart rx -- //
    output wire [7:0] out_data
);

wire baud_clk;
wire en;

// Initialization of the baud rate generator 
baud_gen baud_gen_inst  (.clk(clk), 
                        .rst(rst),
                        .dvsr(dvsr),
                        .tick(baud_clk),
                        .en(en));

// UART RX module
uart_rx # (.D_W(D_W), .B_TICK(B_TICK))
        uart_rx_inst  ( .clk(clk),
                        .rst(rst),
                        .tick(baud_clk),
                        .out_data(out_data),
                        .rx_data(rxd),
                        .en(en) );

endmodule