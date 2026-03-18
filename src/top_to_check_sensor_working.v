`timescale 1ns / 1ps

module top(
    input  wire clk,
    input  wire reset,
    input  wire sensor_in,
    output wire led0,
    output wire led1
);

    wire dust_done_tick;
    wire [31:0] dust_val;

    reg [25:0] blink_reg;
    reg pulse_detected;

    assign led0 = pulse_detected;
    assign led1 = (blink_reg != 0);

    dust_sensor_reader #(
        .CLK_FREQ(100_000_000),
        .SAMPLE_TIME(1)
    ) dust_unit (
        .clk(clk),
        .reset(reset),
        .sensor_in(sensor_in),
        .done_tick(dust_done_tick),
        .dust_val(dust_val)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            blink_reg      <= 0;
            pulse_detected <= 0;
        end
        else begin
            if (dust_done_tick) begin
                blink_reg      <= 50_000_000;
                pulse_detected <= (dust_val != 0);
            end
            else if (blink_reg != 0) begin
                blink_reg <= blink_reg - 1;
            end
        end
    end

endmodule
