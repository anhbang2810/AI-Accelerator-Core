// =============================================================================
// Module:      instruction_memory
// Description: ROM (Firmware).
// =============================================================================
`timescale 1ns/1ps

module instruction_memory #(parameter WIDTH=16, parameter DEPTH=64) (
    input  logic [$clog2(DEPTH)-1:0] addr,
    output logic [WIDTH-1:0] instruction
);
    logic [WIDTH-1:0] rom [0:DEPTH-1];

    localparam CMD_CALC = 4'b0011; 
    localparam CMD_HALT = 4'b1111; 

    initial begin
        // --- FIRMWARE ---
        // Opcode: 3 | Operand: 3 => Hex: 3003
        rom[0] = {CMD_CALC, 12'd3}; 
        
        // STOP (HALT)
        // Opcode: F => Hex: F000
        rom[1] = {CMD_HALT, 12'd0};
    end

    assign instruction = rom[addr];
endmodule