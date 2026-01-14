// =============================================================================
// Module:      npu_processor_top
// Description: Top-level SoC, RAM, ROM và PE.
// =============================================================================
`timescale 1ns/1ps

module npu_processor_top (
    input logic clk,
    input logic rst_n,
    output logic [7:0] result_out,
    output logic result_valid
);
    logic [5:0] pc;
    logic [15:0] instr;
    logic [7:0] rdata_feat, rdata_w, mem_addr;
    logic pe_valid, pe_last;

    // 1. Control Unit
    control_unit u_cu (
        .clk(clk), .rst_n(rst_n), .pc_out(pc), .instruction(instr),
        .mem_addr(mem_addr), .pe_valid(pe_valid), .pe_last(pe_last)
    );

    // 2. Instruction Memory
    instruction_memory u_imem (.addr(pc), .instruction(instr));

    // 3. Data Memories 
    data_memory u_ram_feat (.clk(clk), .we(1'b0), .addr(mem_addr), .wdata(8'b0), .rdata(rdata_feat));
    // Weight RAM offset 
    data_memory u_ram_weight (.clk(clk), .we(1'b0), .addr(mem_addr), .wdata(8'b0), .rdata(rdata_w));

    // 4. NPU Processing Element
    npu_pe #( .DATA_WIDTH(8), .ACC_WIDTH(20) ) u_pe (
        .clk(clk), .rst_n(rst_n),
        .i_valid(pe_valid), .i_last(pe_last),
        .i_feature(rdata_feat), .i_weight(rdata_w),
        .i_bias(20'd5), // Bias = 5
        .o_valid(result_valid), .o_result(result_out)
    );
endmodule