# RISC-V + ML Coprocessor SoC

A custom System-on-Chip (SoC) featuring a minimal RISC-V CPU and a memory-mapped ML accelerator coprocessor. This project is built in Verilog and goes through the full ASIC flow using open-source tools.

---

## 📁 Folder Structure

- `rtl/` — RTL Verilog source files  
- `testbench/` — Testbenches and simulations  
- `synthesis/` — Yosys synthesis scripts and reports  
- `openlane/` — ASIC layout with OpenLane  
- `doc/` — Block diagrams, FSMs, specs  
- `scripts/` — Custom utilities  
- `results/` — Waveform and layout screenshots  

---

## 🔧 Tools Used

- Verilog, Icarus Verilog, GTKWave  
- Yosys, OpenLane, Magic VLSI  
- Python (for optional scripting/testing)

---

## ✅ Modules Implemented

| Module        | Description                        | Status                           |
|---------------|------------------------------------|----------------------------------|
| `pc.v`        | Program Counter                    | ✅ Tested in Vivado & iverilog   |
| `instr_mem.v` | Instruction Memory (preloaded ROM) | ✅ Tested in Vivado & iverilog   |
| `regfile.v`   | 32-register file with dual-read, single-write port | ✅ Tested in Vivado & iverilog |

---

## ▶️ Running Simulations (Linux)

### Simulate the PC module:
```bash
cd testbench
iverilog -o pc_test pc_tb.v ../rtl/pc.v
./pc_test
gtkwave pc.vcd
```

### Simulate the Instruction Memory module:
```bash
cd testbench
iverilog -o instr_mem_test instr_mem_tb.v ../rtl/instr_mem.v
./instr_mem_test
gtkwave instr_mem.vcd
```

### 🧪 Simulate the Register File Module
```bash
cd testbench
iverilog -o regfile_test regfile_tb.v ../rtl/regfile.v
./regfile_test
gtkwave regfile.vcd
```