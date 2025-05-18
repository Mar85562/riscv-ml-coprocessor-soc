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
