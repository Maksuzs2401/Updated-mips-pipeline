# 32-bit 5-Stage MIPS Processor Pipeline (Using a standard single phase clock)

## Overview

This repository contains my second attempt at building a single phase, modular Verilog source code for a 32-bit, 5-stage pipelined processor based on the classic MIPS I instruction set architecture. The design is built from the ground up with a focus on modularity, clean design practices, and a rigorous, bottom-up verification strategy.

The primary goal of this project is to implement a functional pipelined datapath that correctly executes a sequence of arithmetic and memory instructions. The design is synthesizable and targets FPGA implementation, with memory modules designed to infer high-performance synchronous Block RAMs (BRAMs).

## Features

* **Classic 5-Stage MIPS Pipeline**: Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), Memory Access (MEM), and Write-Back (WB).
* **Harvard Architecture**: Utilizes separate, synchronous Instruction and Data memories to avoid structural hazards and improve performance. Both are designed to infer BRAMs.
* **Modular Design**: Each core component (ALU, Control Unit, Register File, etc.) is designed and verified in its own separate module.
* **Single-Phase Clock**: The entire design is fully synchronous and operates on a single rising-edge clock.
* **MIPS ISA Subset**: Implements a core subset of the MIPS instruction set, including R-Type (`ADD`, `SUB`), I-Type (`ADDI`, `LW`, `SW`), and control flow instructions.

## Architecture Diagram

<img width="1063" height="579" alt="mips_harv drawio" src="https://github.com/user-attachments/assets/fce84969-b7ce-4ea4-8963-21e2d0af33df" />

## Key Logic Snippets

This design uses standard hardware patterns to implement key datapath logic.

* **Sign Extension**: The 16-bit immediate from I-type instructions is sign-extended to 32 bits as it's latched into the ID/EX pipeline register.
    ```verilog
  id_ex_immediate_extended <= {{16{immediate[15]}}, immediate};
    ```

* **Destination Register MUX (`RegDst`)**: A multiplexer in the EX stage selects the correct destination register address based on the instruction type (R-type vs. I-type).
   ```verilog
  assign EX_reg_addr = ID_EX_RegDst ? ID_EX_rd : ID_EX_rt;
   ```

* **Write-Back MUX (`MemToReg`)**: A multiplexer in the WB stage selects the final data to be written to the register file—either the result from the ALU or the data loaded from memory.
    ```verilog
  assign final_data_to_reg = MEM_WB_MemToReg ? MEM_WB_ReadData : MEM_WB_ALU_RSLT;
    ```

## Modules

| File Name              | Description                                                                    |
| :--------------------- | :----------------------------------------------------------------------------- |
| `risc_top.v`           | The top-level datapath module that connects all pipeline stages and components. |
| `alu_unit.v`           | The 32-bit Arithmetic Logic Unit; performs all calculations.                   |
| `control_unit.v`       | The main control signal decoder. Generates all signals based on the opcode.     |
| `register_file.v`      | The 32x32 general-purpose register file with two read ports and one write port.  |
| `instruction_memory.v` | A synchronous, read-only memory for instructions, pre-loaded from `program.hex`. |
| `data_memory.v`        | A single-port, synchronous read/write memory for `LW` and `SW` instructions.    |

## Verification Strategy

This project followed a rigorous, bottom-up verification methodology to ensure correctness at every step.

1.  **Unit Testing**: Each core module was tested in isolation using a dedicated, self-checking Verilog testbench. This allowed for bugs in the fundamental components to be found and fixed early.
2.  **Incremental Integration Testing**: The pipeline was assembled stage-by-stage. After adding each stage, a new integration test was run to verify the connections and data flow.
3.  **End-to-End Testing**: The final, complete datapath was tested by running a sample program. The final state of the register file was verified by inspecting the internal signals in the simulator's waveform viewer.

## Tools & Language

* **Language**: Verilog HDL
* **Simulation & Synthesis**: Xilinx Vivado

## How to Run the Simulation

1.  Create a new project in Vivado and add all the `.v` source files.
2.  Create and add the `program.hex` file to the project as a simulation source. This file contains the machine code for the test program.
    ```
       24010005  // ADDI R1, R0, 5
       2422000A  // ADDI R2, R1, 10
    ```
3.  Set the `end_to_end_tb.v` as the top-level module for simulation.
4.  Run the behavioral simulation and inspect the `register_file` internal signals in the waveform viewer.

## Current Status & Future Work

The basic 5-stage datapath is complete and has been verified to execute a sequence of simple instructions correctly without data hazards. The next planned steps are to implement the critical hazard-handling logic.

* **Under Development / Future Prospects:**
    * Implement a full **Forwarding Unit** to resolve data hazards.
    * Implement a **Hazard Detection Unit** to handle `LW`-use stalls.
    * Add the necessary logic and MUXes to handle **branch and jump** instructions.
    * Implement the cache memories to increase the computing speed. 
