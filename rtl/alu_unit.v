`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.09.2025 10:17:57
// Design Name: 
// Module Name: alu_unit
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


module alu_unit(a,b,alu_opcode,result,zero);
  input  [31:0]a,b;
  input  [2:0]alu_opcode;
  output [31:0]result;
  output zero;
  reg    [31:0]temp_res;
  
  parameter OP_ADD=3'b000, OP_SUB=3'b001, OP_AND=3'b010, 
            OP_OR=3'b011, OP_SLT=3'b100;   
  
   
  always @(*) begin
    case(alu_opcode)
        OP_ADD:   temp_res = a + b;
        OP_SUB:   temp_res = a - b;
        OP_AND:   temp_res = a & b;
        OP_OR:    temp_res = a | b;
        OP_SLT:   temp_res = a < b;
        default:  temp_res = 32'h0;
     endcase
   end
   
   assign result = temp_res;
   assign zero = (temp_res == 32'h0);
     
endmodule
