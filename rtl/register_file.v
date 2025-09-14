`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.09.2025 21:52:11
// Design Name: 
// Module Name: register_file
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


module register_file(clk,reset,RegWrite,read_add1,read_add2,
                      write1,data_in,read_out1, read_out2);
  input clk, reset, RegWrite;
  input [4:0] read_add1, read_add2, write1;
  input [31:0] data_in;
  output [31:0] read_out1, read_out2;
  integer i;
  reg [31:0]Reg[0:31];
  
  assign read_out1 = (read_add1 == 5'b0) ? 32'h0:Reg[read_add1];
  assign read_out2 = (read_add2 == 5'b0) ? 32'h0:Reg[read_add2];
  
  always @(posedge clk) begin 
     if(reset)begin
        for(i=0; i<32; i=i+1)begin
          Reg[i]<=32'h0;
        end
     end
     else if (RegWrite && (write1 != 5'b0))begin
          Reg[write1] <= data_in;
          end
  end
endmodule
