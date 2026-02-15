`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.01.2026 10:10:19
// Design Name: 
// Module Name: baudgen
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

// BAUD RATE GENERATOR
module baud_gen
#(
    parameter CLK_FREQ = 100_000_000, // FPGA system clock
    parameter BAUD     = 115200       // UART baud rate
)
(
    input  wire clk,
    input  wire reset,
    output reg  s_tick                 // 16x baud tick
);

    localparam integer M = CLK_FREQ / (BAUD * 16);

    // Counter register (size chosen automatically)
    reg [$clog2(M)-1:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count  <= 0;
            s_tick <= 1'b0;
        end
        else if (count == M-1) begin
            count  <= 0;       // wrap around
            s_tick <= 1'b1;    // generate tick
        end
        else begin
            count  <= count + 1;
            s_tick <= 1'b0;
        end
    end

endmodule
