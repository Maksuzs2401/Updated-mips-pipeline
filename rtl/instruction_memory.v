`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2025 17:04:10
// Design Name: 
// Module Name: instruction_memory
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


module instruction_memory(clk,address,instruction);
  
  input clk;
  input [31:0] address;
  output reg [31:0]instruction;
  
  reg [31:0] mem [1023:0];
  
  initial begin
    $readmemh("program.hex",mem);
    end
    
    always @(posedge clk) begin
      instruction <= mem[address[31:2]];
      end
    
endmodule
