`timescale 1ns / 1ps

module top(
    input  wire clk,
    input  wire reset,
    input  wire rx,
    input  wire sensor_in,   // dust sensor input
    output wire tx,
    output wire usb_tx,
    output wire led0         // ✅ ADD THIS
);

    // --------------------------------
    // internal signals
    // --------------------------------
    wire s_tick;
    wire tx_start;
    wire tx_done_tick;
    wire [7:0] tx_data;

    wire rx_done_tick;
    wire [7:0] rx_data;

    // --------------------------------
    // DEBUG: SENSOR → LED
    // --------------------------------
    assign led0 = sensor_in;   // ✅ DIRECT TEST

    // --------------------------------
    // forward ESP32 response to PC
    // --------------------------------
    assign usb_tx = rx;

    // --------------------------------
    // baud rate generator
    // --------------------------------
    baud_gen baud_unit (
        .clk(clk),
        .reset(reset),
        .s_tick(s_tick)
    );

    // --------------------------------
    // AT command FSM
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
