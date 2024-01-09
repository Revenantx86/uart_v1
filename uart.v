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
    //parameter DATA_WIDTH = 8 
    //parameter DVSR_WIDTH = 8;
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

// Initialization of the baud rate generator 
baud_gen # ( 
    //.DVSR_WIDTH(DVSR_WIDTH) 
            ) 
        baud_gen_inst  (.clk(clk), 
                        .reset(reset),
                        .dvsr(dvsr),
                        .tick(baud_clk),   
                        );

endmodule