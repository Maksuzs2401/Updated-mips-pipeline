`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.09.2025 10:56:21
// Design Name: 
// Module Name: if_stage_tb
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


module if_stage_tb;
  reg clk;
  reg reset;

    // Instantiate the full datapath
    risc_top DUT (
        .clk(clk),
        .reset(reset)
    );

    // Clock generator
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus and checking block
    initial begin
        $display("--- Starting Full Pipeline Test ---");
        
        // Apply reset
        reset <= 1;
        @(posedge clk);
        @(posedge clk);
        reset <= 0;
        $display("Reset released. Running program...");
        
        // Let the simulation run for 15 cycles
        repeat (15) begin
            @(posedge clk);
        end

        $display("Program finished. Check the register values in the waveform.");
        #10; $finish;
    end

endmodule
