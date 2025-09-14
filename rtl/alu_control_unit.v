`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.09.2025 12:12:40
// Design Name: 
// Module Name: alu_control_unit
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


module alu_control_unit(opcode,ALUsrc,RegWrite,alu_op,Branch,Halt,
                        MemRead,MemWrite,MemToReg,RegDst);
  input      [5:0] opcode;
  output reg RegWrite,ALUsrc,Branch,Halt,
             MemRead,MemWrite,MemToReg,RegDst;
  output reg [2:0] alu_op;
  
  parameter ADD=6'b000000, SUB=6'b000001, AND=6'b000010, OR=6'b000011,
            SLT=6'b000100, HLT=6'b000101, LW=6'b000111, SW=6'b001000,
            ADDI=6'b001001, SUBI=6'b001010, SLTI=6'b001011,
            BNEQZ=6'b001100, BEQZ=6'b001101;
  
  parameter OP_ADD=3'b000, OP_SUB=3'b001, OP_AND=3'b010, 
            OP_OR=3'b011, OP_SLT=3'b100;
  
  always @(*) begin
    Branch   = 0;
    Halt     = 0;
    RegWrite = 0;
    ALUsrc   = 0;
    alu_op   = 3'b000;
    MemRead  = 0;
    MemWrite = 0;
    MemToReg = 0;
    RegDst   = 0;
    
    case (opcode)
      ADD,SUB,AND,OR,SLT: begin
        RegWrite = 1;
        RegDst   = 1;
        ALUsrc   = 0;
        if (opcode == ADD) alu_op = OP_ADD;
        else if (opcode == SUB) alu_op = OP_SUB;
        else if (opcode == AND) alu_op = OP_AND;
        else if (opcode == OR) alu_op = OP_OR;
        else if (opcode == SLT) alu_op = OP_SLT;
        end
      
      ADDI,SUBI,SLTI: begin
        RegWrite = 1;
        ALUsrc = 1;
        if (opcode == ADDI) alu_op = OP_ADD;
        else if (opcode == SUBI) alu_op = OP_SUB;
        else if (opcode == SLTI) alu_op = OP_SLT;
        end
      
      LW: begin
        RegWrite = 1;
        MemRead  = 1;
        MemToReg = 1;
        ALUsrc = 1;
        alu_op = OP_ADD;
        end
      
      SW: begin
        RegWrite = 0;
        MemWrite = 1;
        ALUsrc = 1;
        alu_op = OP_ADD;
        end
        
      BNEQZ, BEQZ: begin
                Branch   = 1;
                ALUsrc   = 0;
                alu_op   = OP_SUB;
                end
                
      HLT: begin
        Halt = 1; 
        end
     default: alu_op = 0;  
    endcase
    end 
endmodule
