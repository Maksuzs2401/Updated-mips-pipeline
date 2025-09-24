`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.09.2025 10:16:31
// Design Name: 
// Module Name: risc_top
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


module risc_top(clk,reset);
  input clk, reset;
  reg [31:0] pc_reg;
  wire [31:0] npc,inst_out;
  reg [31:0] IF_ID_inst, IF_ID_NPC;
  wire [5:0] OPCODE = IF_ID_inst[31:26];
  wire [4:0] rs     = IF_ID_inst[25:21];
  wire [4:0] rt     = IF_ID_inst[20:16]; 
  wire [4:0] rd     = IF_ID_inst[15:11];
  wire [15:0]Imm    = IF_ID_inst[15:0];   
  wire Halt,Branch,RegWrite,ALUsrc,MemRead,MemWrite,MemToReg,RegDst;
  wire [2:0] ALUOP;
  wire [31:0] Read_d1, Read_d2;
  reg [31:0] ID_EX_d1,ID_EX_d2;
  reg [31:0] ID_EX_Immext;
  reg [2:0]  ID_EX_ALUOP;
  reg [4:0]  ID_EX_rs,ID_EX_rt,ID_EX_rd;
  reg ID_EX_ALUsrc,ID_EX_RegWrite,ID_EX_MemRead,ID_EX_MemWrite, 
      ID_EX_MemToReg,ID_EX_RegDst;
  wire [31:0] ALU_INP_B;
  wire [31:0] ALU_RSLT;
  wire        ALU_Z_FLG;
  wire [4:0]  EX_reg_addr;
  reg [31:0] EX_MEM_ALU_RSLT;
  reg [31:0] EX_MEM_SW; // Holds ReadData2 for SW
  reg [4:0]  EX_MEM_reg_addr;
  // Pass WB control signals through
  reg        EX_MEM_RegWrite,EX_MEM_MemToReg,EX_MEM_MemRead,
             EX_MEM_MemWrite;
  wire [31:0] MEM_data;
  reg [31:0] MEM_WB_ReadData;
  reg [31:0] MEM_WB_ALU_RSLT;
  reg [4:0]  MEM_WB_reg_addr;
  reg        MEM_WB_RegWrite, MEM_WB_MemToReg;
  wire [31:0] WB_REG_data;
  wire [1:0] ForwardA, ForwardB;
  wire [31:0] forward_data_a, forward_data_b;

  //ports for verification
  
  // *********************IF stage************************//
  
  
  instruction_memory i_mem (.clk(clk),.address(pc_reg),
                            .instruction(inst_out));
  
  always @(posedge clk) begin
    if(reset)
      pc_reg <= 32'h0;
    else
      pc_reg <= npc;
  end
  
  assign npc = pc_reg + 4;
  
  // ===================== IF-ID pipeline regs ===================== //
  
  always @(posedge clk) begin
    if(reset)begin
      IF_ID_inst <= 32'h0;
      IF_ID_NPC <=  32'h0;
    end else begin
      IF_ID_inst <= inst_out;
      IF_ID_NPC <=  npc;
    end
  end
// ********************* ID stage ************************//
  
  
  alu_control_unit c_unit (.opcode(OPCODE),.RegWrite(RegWrite),.Branch(Branch),
                           .ALUsrc(ALUsrc),.alu_op(ALUOP),.Halt(Halt),
                           .MemRead(MemRead),.MemWrite(MemWrite), 
                           .MemToReg(MemToReg),.RegDst(RegDst));
  
  
  register_file reg_file (.clk(clk),.reset(reset),.RegWrite(MEM_WB_RegWrite)
                          ,.read_add1(rs),.read_add2(rt),.write1(MEM_WB_reg_addr),
                          .data_in(WB_REG_data),.read_out1(Read_d1),
                          .read_out2(Read_d2));
  
  // ===================== ID-EX pipeline regs ===================== //
  
  
  always @(posedge clk)begin
    if(reset)begin
      ID_EX_d1 <= 32'h0;
      ID_EX_d2 <= 32'h0;
      ID_EX_Immext <= 32'h0;
      ID_EX_ALUOP <= 3'b0;
      ID_EX_ALUsrc <= 1'b0;
      ID_EX_RegWrite <= 1'b0; 
    end
    else begin
      ID_EX_d1 <=     Read_d1;
      ID_EX_d2 <=     Read_d2;
      ID_EX_Immext <= {{16{Imm[15]}},Imm};
      ID_EX_rs <= rs;
      ID_EX_rt <= rt;
      ID_EX_rd <= rd;
      ID_EX_RegWrite <= RegWrite;
      ID_EX_ALUOP <=  ALUOP;
      ID_EX_ALUsrc <= ALUsrc;
      ID_EX_MemRead  <= MemRead; 
      ID_EX_MemWrite <= MemWrite;
      ID_EX_MemToReg <= MemToReg;
      ID_EX_RegDst   <= RegDst;
      
    end
  end
// ********************* EX stage ************************//  
  
  // Logic for ForwardA MUX (controls ALU's first operand)
  assign ForwardA = (EX_MEM_RegWrite && (EX_MEM_reg_addr != 5'b0) && (EX_MEM_reg_addr == ID_EX_rs)) ? 2'b10 : // Forward from MEM stage
                    (MEM_WB_RegWrite && (MEM_WB_reg_addr != 5'b0) && (MEM_WB_reg_addr == ID_EX_rs)) ? 2'b01 : // Forward from WB stage
                    2'b00; // No forwarding

  // Logic for ForwardB MUX (controls ALU's second operand)
  assign ForwardB = (EX_MEM_RegWrite && (EX_MEM_reg_addr != 5'b0) && (EX_MEM_reg_addr == ID_EX_rt)) ? 2'b10 : // Forward from MEM stage
                    (MEM_WB_RegWrite && (MEM_WB_reg_addr != 5'b0) && (MEM_WB_reg_addr == ID_EX_rt)) ? 2'b01 : // Forward from WB stage
                    2'b00; // No forwarding
  
  assign forward_data_a = (ForwardA == 2'b00) ? ID_EX_d1 : 
                            (ForwardA == 2'b10) ? EX_MEM_ALU_RSLT : 
                            WB_REG_data; // WB_REG_data is the final write-back data

  assign forward_data_b = (ForwardB == 2'b00) ? ID_EX_d2 : 
                            (ForwardB == 2'b10) ? EX_MEM_ALU_RSLT : 
                            WB_REG_data; // WB_REG_data is the final write-back data

  
  assign ALU_INP_B = ID_EX_ALUsrc ? ID_EX_Immext : forward_data_b;
  assign EX_reg_addr = ID_EX_RegDst ? ID_EX_rd : ID_EX_rt;
  
  alu_unit brain (.a(forward_data_a),.b(ALU_INP_B),.alu_opcode(ID_EX_ALUOP),
                  .result(ALU_RSLT),.zero(ALU_Z_FLG));

// ===================== EX-MEM pipeline regs ===================== //                  
  
  
  always @(posedge clk)begin
    if(reset)begin
      EX_MEM_ALU_RSLT <= 32'h0;
      EX_MEM_SW       <= 32'h0;
      EX_MEM_reg_addr <= 5'b0;
      EX_MEM_RegWrite <= 1'b0;
      EX_MEM_MemToReg <= 1'b0;
    end
    else begin 
      EX_MEM_ALU_RSLT <= ALU_RSLT;
      EX_MEM_SW       <= ID_EX_d2;
      EX_MEM_reg_addr <= EX_reg_addr;
      EX_MEM_RegWrite <= ID_EX_RegWrite;
      EX_MEM_MemRead  <= ID_EX_MemRead;
      EX_MEM_MemWrite <= ID_EX_MemWrite;
      EX_MEM_MemToReg <= ID_EX_MemToReg;
    end
  end
// ********************* MEM stage ************************//  
  
  data_memory d_mem (.clk(clk),.m_addrs(EX_MEM_ALU_RSLT),
                     .m_in(EX_MEM_SW),.m_write(EX_MEM_MemWrite),
                     .m_read(EX_MEM_MemRead),.m_out(MEM_data));
                     
// ===================== MEM-WB pipeline regs ===================== //

  
  
  always @(posedge clk)begin
    if(reset)begin 
      MEM_WB_ReadData   <= 32'h0;
      MEM_WB_ALU_RSLT   <= 32'h0;
      MEM_WB_reg_addr   <= 5'b0;
      MEM_WB_RegWrite   <= 1'b0;
      MEM_WB_MemToReg   <= 1'b0;
    end
    else begin 
      MEM_WB_ReadData   <= MEM_data;
      MEM_WB_ALU_RSLT   <= EX_MEM_ALU_RSLT;
      MEM_WB_reg_addr   <= EX_MEM_reg_addr;
      MEM_WB_RegWrite   <= EX_MEM_RegWrite;
      MEM_WB_MemToReg   <= EX_MEM_MemToReg;
    end
  end
  
// ********************* WB stage ************************//

  assign WB_REG_data = MEM_WB_MemToReg ? MEM_WB_ReadData : MEM_WB_ALU_RSLT;
  
endmodule
