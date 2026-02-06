`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.02.2026 16:00:02
// Design Name: 
// Module Name: transmitter_tb
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

`timescale 1ns / 1ps

module transmitter_tb;
    reg clk, reset, tx_start, s_tick;
    reg [7:0] din;
    wire tx, tx_done_tick;

    // Connect transmitter
    uart_tx uut (
        .clk(clk), 
        .reset(reset), 
        .tx_start(tx_start), 
        .s_tick(s_tick), 
        .din(din), 
        .tx_done_tick(tx_done_tick), 
        .tx(tx)
    );

    // Clock generation (100 MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    // Correct s_tick generation: 1 pulse every 16 clocks
    reg [3:0] tick_count;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tick_count <= 0;
            s_tick <= 0;
        end 
        else if (tick_count == 4'd15) begin
            tick_count <= 0;
            s_tick <= 1;
        end 
        else begin
            tick_count <= tick_count + 1;
            s_tick <= 0;
        end
    end

    // Task to send one byte (clock-synchronized)
    task send_byte(input [7:0] data);
    begin
        @(posedge clk);
        din = data;
        tx_start = 1;
        @(posedge clk);
        tx_start = 0;
        wait(tx_done_tick);
    end
    endtask

    initial begin
        reset = 1;
        tx_start = 0;
        din = 8'h00;

        #50 reset = 0;

        // Send "AT\r\n"
        send_byte(8'h41); // A
        send_byte(8'h54); // T
        send_byte(8'h0D); // CR
        send_byte(8'h0A); // LF

        #50000;
        $finish;
    end

endmodule
