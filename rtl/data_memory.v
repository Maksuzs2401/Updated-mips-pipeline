`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.09.2025 12:06:39
// Design Name: 
// Module Name: data_memory
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


module data_memory(clk,m_read,m_write,m_addrs,m_in,m_out);
  input clk, m_write,m_read;
  input [31:0]m_addrs,m_in;
  output reg [31:0]m_out;
  
  reg [31:0] mem [1023:0];
  
  always @(posedge clk)begin
    if(m_read)
      m_out <= mem[m_addrs[31:2]];
    if (m_write)
      mem[m_addrs[31:2]] <= m_in;
  end
  
endmodule
