`timescale 1ns / 1ps

module at_fsm(
    input  wire clk,
    input  wire reset,
    input  wire tx_done_tick,
    output reg  tx_start,
    output reg [7:0] tx_data
);

    // 1-second delay between commands (Assuming 100MHz FPGA clock)
    localparam DELAY_TICKS = 100_000_000; 

    localparam [1:0] 
        send    = 2'd0, 
        wait_tx = 2'd1, 
        pause   = 2'd2, 
        done    = 2'd3;

    reg [1:0]  state_reg, state_next;
    reg [6:0]  index_reg, index_next; // 7-bit index allows up to 127 characters
    reg [26:0] timer_reg, timer_next; // 27-bit timer for the delay
    
    wire [7:0] current_char; // Driven by the ROM

    // INSTANTIATE THE ROM HERE
    at_rom my_rom (
        .addr(index_reg),
        .data(current_char)
    );

    // FSM Registers
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_reg <= send;
            index_reg <= 0;
            timer_reg <= 0;
        end else begin
            state_reg <= state_next;
            index_reg <= index_next;
            timer_reg <= timer_next;
        end
    end

    // Next-State Logic
    always @* begin
        state_next = state_reg;
        index_next = index_reg;
        timer_next = timer_reg;
        tx_start   = 1'b0;
        tx_data    = current_char; // Feed ROM data directly to TX

        case (state_reg)
            send: begin
                if (current_char == 8'h00) begin
                    state_next = done; 
                end else begin
                    tx_start   = 1'b1;
                    state_next = wait_tx;
                end
            end

            wait_tx: begin
                if (tx_done_tick) begin
                    if (current_char == 8'h0A) begin // Pause on '\n'
                        timer_next = 0;
                        index_next = index_reg + 1;
                        state_next = pause;
                    end else begin
                        index_next = index_reg + 1;
                        state_next = send;
                    end
                end
            end

            pause: begin
                if (timer_reg < DELAY_TICKS) begin
                    timer_next = timer_reg + 1;
                end else begin
                    state_next = send; 
                end
            end

            done: begin
                state_next = done; 
            end
        endcase
    end
endmodule