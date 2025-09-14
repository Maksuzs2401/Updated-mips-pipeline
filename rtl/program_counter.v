`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2025 15:56:46
// Design Name: 
// Module Name: program_counter
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


module program_counter(clk, reset, pc_out, pc_in);
  input          clk,reset;
  output reg [31:0] pc_out;
  input      [31:0] pc_in;
  
  always @(posedge clk)
    begin
      if(reset)begin
        pc_out <= 32'h0;
        end
      else begin
        pc_out = pc_in;
        end
    end
endmodule
