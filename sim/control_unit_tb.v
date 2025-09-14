`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.09.2025 13:08:23
// Design Name: 
// Module Name: control_unit_tb
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


module control_unit_tb;
  reg [5:0] opcode_in;
    wire      Halt_out, Branch_out, RegWrite_out, ALUSrc_out;
    wire [2:0] ALUOp_out;

    // Instantiate the Design Under Test (DUT)
    alu_control_unit dut (
        .opcode(opcode_in),
        .Halt(Halt_out),
        .Branch(Branch_out),
        .RegWrite(RegWrite_out),
        .ALUsrc(ALUSrc_out),
        .alu_op(ALUOp_out)
    );

    // Define opcodes and ALUOps to make tests readable
    parameter ADD=6'b000000, ADDI=6'b001001, SW=6'b001000, BEQZ=6'b001101, HLT=6'b000101;
    parameter OP_ADD=3'b000, OP_SUB=3'b001;

    // Task to check all control signals for a given test
    task check_signals;
        input expected_Halt, expected_Branch, expected_RegWrite, expected_ALUSrc;
        input [2:0] expected_ALUOp;
        input [8*10:0] test_name; // A string for the test name
        begin
        #10; // Wait for outputs to settle
        if (Halt_out === expected_Halt && Branch_out === expected_Branch && 
            RegWrite_out === expected_RegWrite && ALUSrc_out === expected_ALUSrc &&
            ALUOp_out === expected_ALUOp) begin
            $display("PASS: %s", test_name);
        end else begin
            $display("FAIL: %s", test_name);
            $display("      Expected: H=%b, B=%b, RW=%b, AS=%b, AO=%b", 
                     expected_Halt, expected_Branch, expected_RegWrite, expected_ALUSrc, expected_ALUOp);
            $display("      Got:      H=%b, B=%b, RW=%b, AS=%b, AO=%b", 
                     Halt_out, Branch_out, RegWrite_out, ALUSrc_out, ALUOp_out);
        end
      end
    endtask

    // Stimulus block
    initial begin
        $display("--- Starting Control Unit Verification ---");

        // Test Case 1: R-type (ADD)
        opcode_in = ADD;
        check_signals(0, 0, 1, 0, OP_ADD, "ADD");

        // Test Case 2: I-type (ADDI)
        opcode_in = ADDI;
        check_signals(0, 0, 1, 1, OP_ADD, "ADDI");

        // Test Case 3: Store (SW)
        opcode_in = SW;
        check_signals(0, 0, 0, 1, OP_ADD, "SW");

        // Test Case 4: Branch (BEQZ)
        opcode_in = BEQZ;
        check_signals(0, 1, 0, 0, OP_SUB, "BEQZ");
        
        // Test Case 5: Halt (HLT)
        opcode_in = HLT;
        check_signals(1, 0, 0, 0, OP_ADD, "HLT"); // Default ALUOp for HLT is fine
        
        $display("--- Control Unit Verification Complete ---");
        #10; $finish;
    end
endmodule
