`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.09.2025 22:31:35
// Design Name: 
// Module Name: reg_file_tb
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


module reg_file_tb;
  reg clk, reset, RegWrite;
  reg [4:0] read_add1, read_add2, write1;
  reg [31:0] data_in;
  wire [31:0] read_out1, read_out2;
  
  register_file DUT (.clk(clk),.reset(reset),.RegWrite(RegWrite),
                     .read_add1(read_add1),.read_add2(read_add2),
                     .write1(write1),.data_in(data_in),
                     .read_out1(read_out1),.read_out2(read_out2));
  
  initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10-unit period clock
    end

    // Stimulus and checking block
    initial begin
        $display("--- Starting Register File Verification ---");
        
        // 1. Assert reset
        reset <= 1;
        RegWrite <= 0;
        @(posedge clk);
        @(posedge clk);
        reset <= 0;
        @(posedge clk);
        $display("Reset applied.");

        // 2. Test Case: Write the value 50 to register R10
        $display("Testing: Write 50 to R10...");
        write1 <= 10;
        data_in <= 50;
        RegWrite <= 1;
        @(posedge clk);
        RegWrite <= 0;
        #1;
        
        // 3. Test Case: Read back from R10 and check
        $display("Testing: Read from R10...");
        read_add1 <= 10;
        #10;
        if (read_out1 == 50) $display("PASS: Read back correct value (50).");
        else $display("FAIL: Read back incorrect value. Expected 50, got %d.", read_out1);
        
        // 4. Test Case: Test RegWrite disable
        $display("Testing: Write disable (RegWrite=0)...");
        write1 <= 12;
        data_in <= 99;
        RegWrite <= 0;
        @(posedge clk);
        #1;
        read_add1 <= 12;
        #10;
        if (read_out1 == 0) $display("PASS: Register R12 was not written.");
        else $display("FAIL: Register R12 was written incorrectly.");

        // 5. Test Case: Test writing to Register 0 (should do nothing)
        $display("Testing: Writing to R0 (hardwired to zero)...");
        write1 <= 0;
        data_in <= 123;
        RegWrite <= 1;
        @(posedge clk);
        #1;
        read_add1 <= 0;
        #10;
        if (read_out1 == 0) $display("PASS: Register R0 remains zero.");
        else $display("FAIL: Register R0 was written to.");

        // 6. Test Case: Test simultaneous reads from both ports (NEW)
        $display("Testing: Simultaneous read from R1 and R2...");
        write1 <= 1; data_in <= 111; RegWrite <= 1; @(posedge clk);
        write1 <= 2; data_in <= 222; @(posedge clk);
        RegWrite <= 0; #1;
        read_add1 <= 1; read_add2 <= 2; #10;
        if (read_out1 == 111 && read_out2 == 222) begin
            $display("PASS: Simultaneous read correct (R1=111, R2=222).");
        end else begin
            $display("FAIL: Simultaneous read incorrect. Got R1=%d, R2=%d", read_out1, read_out2);
        end

        $display("--- Register File Verification Complete ---");
        #10; $finish;
    end
 
endmodule
