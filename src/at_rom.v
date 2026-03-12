`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.03.2026 17:08:10
// Design Name: 
// Module Name: at_rom
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


`timescale 1ns / 1ps

// ROM MODULE using your .mem file
module at_rom(
    input  wire [6:0] addr,
    output reg  [7:0] data
);

    // Declare a memory array: 128 rows, each 8 bits wide
    reg [7:0] rom_array [0:127];

    // Initialize the memory from your external file
    initial begin
        $readmemh("commands.mem", rom_array);
    end

    // Asynchronous read to feed the FSM
    always @* begin
        // If the address goes beyond initialized memory, output 0x00 to stop the FSM
        if (rom_array[addr] === 8'bx) 
            data = 8'h00;
        else
            data = rom_array[addr];
    end

endmodule
