`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2025 17:33:39
// Design Name: 
// Module Name: instruction_mem_tb
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


module instruction_mem_tb;
  reg clk;
    reg [31:0] address_in;
    wire [31:0] instruction_out;

    // Instantiate the Design Under Test (DUT)
    instruction_memory dut (
        .clk(clk),
        .address(address_in),
        .instruction(instruction_out)
    );
    
    // Clock generator
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Stimulus and checking block
    initial begin
        $display("--- Starting Instruction Memory Verification ---");

        // Test Case 1: Read from address 0
        address_in <= 32'h00000000;
        @(posedge clk); // Wait one clock cycle for the synchronous read
        #1; // Wait a tiny bit for signals to settle
        $display("Reading from address 0...");
        if (instruction_out === 32'h24010005) begin
            $display("PASS: Correct instruction found.");
        end else begin
            $display("FAIL: Incorrect instruction. Expected 24010005, got %h", instruction_out);
        end

        // Test Case 2: Read from address 4
        address_in <= 32'h00000004;
        @(posedge clk); // Wait one clock cycle
        #1;
        $display("Reading from address 4...");
        if (instruction_out === 32'h2422000A) begin
            $display("PASS: Correct instruction found.");
        end else begin
            $display("FAIL: Incorrect instruction. Expected 2422000A, got %h", instruction_out);
        end

        $display("--- Instruction Memory Verification Complete ---");
        #10; $finish;
    end
endmodule
