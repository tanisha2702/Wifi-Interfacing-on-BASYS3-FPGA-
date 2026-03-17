`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2026 19:26:03
// Design Name: 
// Module Name: dust_sensor_reader
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


module dust_sensor_reader
#(
    parameter CLK_FREQ = 100_000_000,
    parameter SAMPLE_TIME = 1
)
(
    input wire clk,
    input wire reset,
    input wire sensor_in,

    output reg done_tick,
    output wire [31:0] dust_val
);

localparam SAMPLE_COUNT = CLK_FREQ * SAMPLE_TIME;

reg [31:0] sample_cnt_reg;
reg [31:0] low_cnt_reg;

always @(posedge clk or posedge reset)
begin
    if(reset) begin
        sample_cnt_reg <= 0;
        low_cnt_reg <= 0;
        done_tick <= 0;
    end
    else begin
        done_tick <= 0;

        if(sample_cnt_reg < SAMPLE_COUNT) begin
            sample_cnt_reg <= sample_cnt_reg + 1;

            if(sensor_in == 1'b0)
                low_cnt_reg <= low_cnt_reg + 1;
        end
        else begin
            done_tick <= 1;
            sample_cnt_reg <= 0;
        end
    end
end

assign dust_val = low_cnt_reg;

endmodule
