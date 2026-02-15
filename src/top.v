`timescale 1ns / 1ps
// TOP MODULE (to just check the AT command)
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.01.2026 10:10:19
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// TOP MODULE (to just check the AT command)
module top(
    input  wire clk,
    input  wire reset,
    input  wire rx,
    output wire tx,
    output wire usb_tx // To PC (Telnet)
);
   


    // internal signals
    wire s_tick;
    wire tx_start;
    wire tx_done_tick;
    wire [7:0] tx_data;

    wire rx_done_tick;
    wire [7:0] rx_data;
    
    assign usb_tx = rx; // This forwards everything the ESP32 says to your PC
   
    // --------------------------------
    // baud rate generator
    // --------------------------------
    baud_gen baud_unit (
        .clk(clk),
        .reset(reset),
        .s_tick(s_tick)
    );

    // --------------------------------
    // AT-command FSM
    // --------------------------------
    at_fsm fsm_unit (
        .clk(clk),
        .reset(reset),
        .tx_done_tick(tx_done_tick),
        .tx_start(tx_start),
        .tx_data(tx_data)
    );

    // --------------------------------
    // UART transmitter
    // --------------------------------
    uart_tx tx_unit (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .s_tick(s_tick),
        .din(tx_data),
        .tx_done_tick(tx_done_tick),
        .tx(tx)
    );

    // --------------------------------
    // UART receiver
    // --------------------------------
    uart_rx rx_unit (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .s_tick(s_tick),
        .rx_done_tick(rx_done_tick),
        .dout(rx_data)
    );

endmodule