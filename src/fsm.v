module at_fsm(
    input  wire clk,
    input  wire reset,
    input  wire tx_done_tick,
    output reg  tx_start,
    output reg [7:0] tx_data
);
    localparam [1:0] idle=2'b00, send=2'b01, wait1=2'b10, done=2'b11;
    reg [1:0] state_reg, state_next;
    reg [3:0] char_reg, char_next; // 4-bit register

    always @(posedge clk or posedge reset)
        if (reset) begin
            state_reg <= idle;
            char_reg  <= 0;
        end else begin
            state_reg <= state_next;
            char_reg  <= char_next;
        end

    always @* begin
        state_next = state_reg;
        char_next  = char_reg;
        tx_start   = 1'b0;
        tx_data    = 8'h00;

        case (state_reg)
            idle: begin
                char_next = 4'd0;
                state_next = send;
            end
            send: begin
                tx_start = 1'b1;
                case (char_reg)
                    4'd0: tx_data = 8'h41; // 'A'
                    4'd1: tx_data = 8'h54; // 'T'
                    4'd2: tx_data = 8'h0D; // CR
                    4'd3: tx_data = 8'h0A; // LF
                    default: tx_data = 8'h00;
                endcase
                state_next = wait1;
            end
            wait1: begin
                if (tx_done_tick) begin
                    if (char_reg == 4'd3)
                        state_next = done;
                    else begin
                        char_next = char_reg + 1;
                        state_next = send;
                    end
                end
            end
            done: state_next = done; 
        endcase
    end
endmodule