`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.09.2025 13:00:31
// Design Name: 
// Module Name: alu_tb
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


module alu_tb;
// Testbench signals
    reg  [31:0] a_in, b_in;
    reg  [2:0]  alu_opcode_in;
    wire [31:0] result_out;
    wire        zero_out;

    // Instantiate the Design Under Test (DUT)
    alu_unit dut (
        .a(a_in),
        .b(b_in),
        .alu_opcode(alu_opcode_in),
        .result(result_out),
        .zero(zero_out)
    );
    
    // Define the ALU Operation codes to make tests readable
    parameter OP_ADD=3'b000, OP_SUB=3'b001, OP_AND=3'b010, 
              OP_OR=3'b011, OP_SLT=3'b100;

    // Stimulus and checking block
    initial begin
        $display("--- Starting ALU Verification ---");

        // Test Case 1: ADD (15 + 10 = 25)
        a_in = 32'd15; b_in = 32'd10; alu_opcode_in = OP_ADD; #10;
        if (result_out == 25) $display("PASS: ADD test (15+10=25).");
        else $display("FAIL: ADD test. Expected 25, got %d", result_out);

        // Test Case 2: SUB (10 - 15 = -5)
        a_in = 32'd10; b_in = 32'd15; alu_opcode_in = OP_SUB; #10;
        if ($signed(result_out) == -5) $display("PASS: SUB test (10-15=-5).");
        else $display("FAIL: SUB test. Expected -5, got %d", $signed(result_out));

        // Test Case 3: SUB with Zero flag (15 - 15 = 0)
        a_in = 32'd15; b_in = 32'd15; alu_opcode_in = OP_SUB; #10;
        if (result_out == 0 && zero_out == 1) $display("PASS: Zero flag test (15-15=0).");
        else $display("FAIL: Zero flag test.");

        // Test Case 4: AND (12 & 10 = 8)
        a_in = 32'b1100; b_in = 32'b1010; alu_opcode_in = OP_AND; #10;
        if (result_out == 8) $display("PASS: AND test (12&10=8).");
        else $display("FAIL: AND test. Expected 8, got %d", result_out);

        // Test Case 5: OR (12 | 10 = 14)
        a_in = 32'b1100; b_in = 32'b1010; alu_opcode_in = OP_OR; #10;
        if (result_out == 14) $display("PASS: OR test (12|10=14).");
        else $display("FAIL: OR test. Expected 14, got %d", result_out);

        // Test Case 6: SLT (5 < 10 -> true)
        a_in = 32'd5; b_in = 32'd10; alu_opcode_in = OP_SLT; #10;
        if (result_out == 1) $display("PASS: SLT test (5<10).");
        else $display("FAIL: SLT test (5<10).");

        // Test Case 7: SLT with negative numbers (-5 < 2 -> true)
        a_in = -32'sd5; b_in = 32'sd2; alu_opcode_in = OP_SLT; #10;
        if (result_out == 1) $display("PASS: SLT test (-5<2).");
        else $display("FAIL: SLT test (-5<2).");

        $display("--- ALU Verification Complete ---");
        #10; $finish;
    end

endmodule
