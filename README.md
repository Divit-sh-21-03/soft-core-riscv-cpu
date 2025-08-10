# Soft_Core_RISC-V_CPU

## Executive Summary

Soft_Core_RISC-V_CPU is a compact, modular **5-stage pipelined RISC-V soft core** implemented in Verilog and validated on a Spartan-7 (XC7S15) FPGA using Xilinx Vivado. The design implements IF, ID, EX, MEM and WB stages, includes hazard detection and forwarding, and is supplied with a simulation testbench and on-board LED visualization for quick hardware demonstrations.

---

## Key Features

- Full 5-stage pipeline (IF → ID → EX → MEM → WB)  
- Hazard detection and forwarding to minimize stalls  
- ALU, register file, immediate generator, instruction & data memory  
- Instruction ROM preloaded with example program (`arith.coe`)  
- Testbench (`pipeline_tb.v`) with detailed stage-wise debug prints  
- Vivado project with constraints (`my_board.xdc`) for Spartan-7 deployment  
- Low resource usage and timing closure at 100 MHz (implementation evidence included in repository)

---

## Getting Started

### Prerequisites
- Xilinx Vivado (project tested with Vivado versions compatible with Spartan-7)  
- Spartan-7 development board (XC7S15) or compatible target

### Build & Hardware Programming (3 steps)
1. Open a new Vivado project , import all the src files and set the top module to `top_level` .  
2. Run **Synthesis → Implementation → Generate Bitstream**.  
3. Connect the board, open Hardware Manager and program the generated bitstream. Observe on-board LEDs indicating pipeline activity.

---

## Simulation & Verification

- Run the provided testbench `tb/pipeline_tb.v` in Vivado simulator or using `iverilog` + `vvp`.  
- The testbench performs reset, steps the clock and prints stage outputs (PC, fetched instruction, ALU results, hazard/forwarding events). Use these logs to demonstrate functional verification during interviews.

---

## Resource & Timing Summary

- Target device: Spartan-7 (XC7S15)  
- Design clock target: 100 MHz  
- Implementation reports indicate timing closure and low logic utilization (refer to provided implementation screenshots and reports in the repository for exact numbers).

---

## Recommended Artifacts (included in repository)

- Vivado Flow Navigator screenshot (synthesis/implementation)  
- Sources / Hierarchy screenshot  
- Timing Summary (post-implementation)  
- Utilization Summary (resource usage)  
- I/O pin mapping (XDC)  

---
## Supported Opcodes 
This core implements the RV32 base integer instruction set. The supported opcodes / instructions are as follows :

- Arithmetic & Logical (R-type / I-type)
  - ADD, SUB (R-type)
  - ADDI (I-type)
  - AND, OR (R-type)
  - ANDI, ORI (I-type)
  - SLT (R-type), SLTI (I-type)
  - SLL, SRL, SRA (R-type)
  - SLLI, SRLI, SRAI (I-type shifts)

- Memory Access
  - LW  — Load Word (I-type, loads from data memory)
  - SW  — Store Word (S-type, stores to data memory)

- Branches & Control Flow
   - BEQ  — Branch if Equal (B-type)
   - BNE  — Branch if Not Equal (B-type)
   - JAL  — Jump and Link (J-type)
   - LUI  — Load Upper Immediate (U-type)

- Instruction Types Handled
  - R-type: register-register arithmetic/logical
  - I-type: immediate arithmetic/logical, loads, shifts
  - S-type: stores
  - B-type: branches
  - U-type: upper immediate
  - J-type: jumps

- Unsupported features
  - Multiplication / Division (M-extension)
  - Floating point
  - Atomic operations
  - Exceptions / privileged instructions
  - Compressed instructions (RVC)
---

## Extensions & Next Steps

Potential technical extensions that follow naturally from this architecture:
- Add RISC-V extensions (e.g., RVC or M extension)  
- Implement a simple branch predictor to reduce control stalls  
- Expose a UART/AXI bridge for peripheral I/O and interactive demos  
- Integrate an assembler / toolchain to run compiled programs on the core

---

## Contributing

Contributions are welcome. Fork the repository, create a feature branch, include testbench evidence, and (where applicable) updated implementation screenshots, then submit a pull request.

---

## License

Apache License 2.0 — reuse is allowed with proper attribution. Do not remove or alter the author's name in any derivative works. See the `LICENSE` file in this repository for full details.

---

## Author

Divit Sharma — B.Tech (3rd Year)  
GitHub: [https://github.com/Divit-sh-21-03](https://github.com/Divit-sh-21-03)  
Email: divits@iitbhilai.ac.in

