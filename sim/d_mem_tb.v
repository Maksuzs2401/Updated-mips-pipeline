`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.09.2025 12:15:19
// Design Name: 
// Module Name: d_mem_tb
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


module d_mem_tb;
  reg clk,m_write,m_read;
  reg [31:0] m_addrs,m_in;
  wire [31:0]m_out;
  
  data_memory DUT (.clk(clk),.m_write(m_write),.m_read(m_read),
                   .m_addrs(m_addrs),.m_in(m_in),.m_out(m_out));
  
  initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus and checking block
    initial begin
        $display("--- Starting Data Memory Verification ---");
        
        // --- Test Case: Write the value 123 to address 8 ---
        $display("Testing: Writing 123 to address 8...");
        m_write  <= 1;
        m_read   <= 0;
        m_addrs    <= 32'h8;
        m_in <= 32'd123;
        @(posedge clk);
        
        // De-assert write and prepare for read
        m_write <= 0;
        
        // --- Test Case: Read back from address 8 ---
        $display("Testing: Reading from address 8...");
        m_read  <= 1;
        m_addrs   <= 32'h8;
        @(posedge clk); // Wait for the read data to become valid
        
        #1; // Wait a moment for signals to settle
        if (m_out === 32'd123) begin
            $display("PASS: Correct value read back.");
        end else begin
            $display("FAIL: Incorrect value. Expected 123, got %d", m_out);
        end

        $display("--- Data Memory Verification Complete ---");
        #10; $finish;
    end

  
endmodule
