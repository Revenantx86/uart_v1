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

    // -- uart tx -- //
    output wire txd;
    input wire [7:0] input_data;
    input wire tx_start;
    output wire tx_done;
);

wire baud_clk;
wire baud_en;

// UART -> Baud Rate Generator
baud_gen # () 
        baud_gen_inst (
            .clk(clk), 
            .rst(rst),
            .dvsr(dvsr),
            .baud_clk(baud_clk),
            .baud_en(baud_en)
            );

// UART -> RX Module
uart_rx # (.D_W(D_W), .B_TICK(B_TICK))
        uart_rx_inst ( 
            .clk(clk),
            .rst(rst),
            .baud_clk(baud_clk),
            .out_data(out_data),
            .rx_data(rxd),
            .baud_en(baud_en)
            );

// UART -> TX Module
uart_tx #( .D_W(D_W), .B_TICK(B_TICK) ) 
        uart_tx_inst (
            .rst(rst),
            .clk(clk),
            .baud_clk(baud_clk),
            .input_data(input_data),
            .tx_start(tx_start),
            .baud_en(baud_en),
            .tx_data(txd),
            .tx_done(tx_done)
            );

endmodule