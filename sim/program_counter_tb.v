`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2025 16:00:55
// Design Name: 
// Module Name: program_counter_tb
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


module program_counter_tb;
  reg clk,reset;
  reg [31:0] pc_in;
  wire [31:0] pc_out;
  
  program_counter DUT (.clk(clk),.reset(reset),
                       .pc_out(pc_out),.pc_in(pc_in));
  
  initial begin
  clk = 0;
  forever #5 clk = ~clk;
  end
  
  initial begin
        $display("--- Starting PC Verification (v2) ---");
        
        // 1. Assert reset
        reset <= 1;
        pc_in <= 32'h0; // Drive input to a known value
        @(posedge clk);
        #1;
        if (pc_out === 32'h0) $display("PASS: PC reset to 0.");
        else $display("FAIL: PC did not reset correctly.");
        
        // 2. Release reset and check incrementing
        reset <= 0;
        // To test incrementing, we feed `pc_out + 4` into `pc_in`
        repeat (3) begin
            pc_in <= pc_out + 4;
            @(posedge clk);
            @(posedge clk);
        end
        #1;
        if (pc_out === 12) $display("PASS: PC incremented correctly to 12.");
        else $display("FAIL: PC did not increment correctly. Value: %d", pc_out);

        // 3. NEW TEST: Test the parallel load (jump)
        $display("Testing parallel load (jump to 80)...");
        pc_in <= 32'h80; // Tell the PC to load a new value
        @(posedge clk);
        #1;
        if (pc_out === 32'h80) $display("PASS: PC jumped to 80h correctly.");
        else $display("FAIL: PC did not jump correctly. Value: %h", pc_out);

        // Check that it increments from the new value
        pc_in <= pc_out + 4;
        @(posedge clk);
        #1;
        if (pc_out === 32'h84) $display("PASS: PC incremented from 80h to 84h.");
        else $display("FAIL: PC did not increment from new value. Value: %h", pc_out);

        $display("--- PC Verification Complete ---");
        $finish;
    end
endmodule
