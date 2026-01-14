// =============================================================================
// Module:      tb_npu_processor_top
// Description: Testbench (System Verification).
// =============================================================================
`timescale 1ns/1ps

module tb_npu_processor_top;
  logic clk = 0;
  logic rst_n = 0;
  logic [7:0] result_out;
  logic result_valid;

  always #5 clk = ~clk; // 100MHz Clock

  npu_processor_top DUT (
    .clk(clk), .rst_n(rst_n),
    .result_out(result_out), .result_valid(result_valid)
  );

  initial begin
    $display("==================================================");
    $display("   STARTING NPU PROCESSOR SIMULATION              ");
    $display("==================================================");

    // --- B1: Nap Data vao RAM (Backdoor Load) ---
    // Test Case: (10*2) + (5*-3) + (2*4) + 5 = 18
    DUT.u_ram_feat.mem[0] = 10;  DUT.u_ram_weight.mem[0] = 2;
    DUT.u_ram_feat.mem[1] = 5;   DUT.u_ram_weight.mem[1] = -3;
    DUT.u_ram_feat.mem[2] = 2;   DUT.u_ram_weight.mem[2] = 4;

    // --- B2: Khoi Dong ---
    $display("[%0t] System Reset...", $time);
    rst_n = 0; #20 rst_n = 1;

    // --- B3: Doi Ket Qua ---
    $display("[%0t] CPU Running... Waiting for result...", $time);
    wait(result_valid);
    @(negedge clk);

    // --- B4: Kiem Tra Tu Dong ---
    $display("--------------------------------------------------");
    if (result_out === 8'd18) begin
        $display(">> RESULT MATCHED! System works perfectly.");
        $display(">> Expected: 18 | Actual: %d", result_out);
        $display(">> STATUS: [ PASS ]");
    end else begin
        $display(">> RESULT MISMATCH!");
        $display(">> Expected: 18 | Actual: %d", result_out);
        $display(">> STATUS: [ FAIL ]");
    end
    $display("--------------------------------------------------");
    
    #50; $stop;
  end
endmodule