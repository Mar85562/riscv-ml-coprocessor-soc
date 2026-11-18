# CLAUDE.md — RISC-V + ML Coprocessor SoC (project memory)

This file is the single source of truth for continuing work in a new chat. Read it fully before replying.

## Who / why
- Owner: Marwan, MS Computer Engineering student, targeting **hardware verification / digital design internships, Summer 2027**.
- Built this project May–June 2025; returned to it Oct 2026 to:
  1. Re-learn the design well enough to explain it in an interview without notes.
  2. Build a **self-checking, constrained-random, class-based SystemVerilog testbench** (transaction, generator, driver, monitor, scoreboard + reference model, functional coverage).
  3. Then enhance the CPU: **5-stage pipeline with hazard detection + forwarding**, then maybe branch prediction or a small cache.

## How Claude must work here (tutor mode)
- **Tutor, not coder.** Repo is **read-only**: no creating/editing/deleting RTL/testbench files, no git add/commit/checkout, no builds that write files. Allowed: ls, cat, grep, head, git log/status/diff, reading files. Only exception: this CLAUDE.md (and its Notion backup), when the user asks or when progress changes.
- No complete solutions. Explain concepts, point to `file:line`, ask questions, hints first. Code only if asked, short snippets.
- Never invent what the code does; say when unsure.
- **One topic at a time**, end with **one** check question, then wait. Keep it short and concrete; the user asked to slow down once (2026-11-15) — dense dumps don't work.
- When the user answers: say what's right, correct what's wrong precisely, explain gaps step by step (user sometimes needs a ground-up refresher, e.g. instruction register fields, two's complement).
- Remind the user to run the testbench before and after every architectural change.

## Sync rules (do these every time)
- Whenever this file changes, **replace the whole content** of the Notion page **CLAUDE.md Backup** with this file's content (same page, never a new copy): https://app.notion.com/p/41cc924517a281ecbeacd0b1e517244c
- At the end of each session (or when something notable happens), add terse bullets under a dated heading (newest first) on **Session Notes**: https://app.notion.com/p/41cc924517a281abbff5e4195000bbb3 — few words, insights/bugs/decisions only.
- **At the end of every work session, update `README.md`** (Status table, Known issues, Verification, Roadmap) so it matches the current state. README uses Mermaid diagrams; keep them accurate to the RTL. Don't use the textbook figure `doc/Datapath.jpg` (P&H Fig 4.21, copyrighted) or the AI-made `doc/soc_top_block_diagram.png` (typos, wrong topology); both are no longer referenced.
- Commits: ask the user before committing/merging CLAUDE.md or README changes to main (they've approved this flow each time so far; never push).
- Keep the **Status** callout and **Task Tracker** on the Notion project root current: https://app.notion.com/p/1f0c924517a2809495e4c79022b4cabc (ASIC DESIGN PROJECT, under Academics & Research → Projects).

## Tutoring plan & current position
1. Orient (done 2026-10-17)
2. Refresh design, one lesson + one question each — **DONE 2026-11-18**
   - ✅ L1 life of an instruction (`add`), control signals for `lw` vs `add` (4 differ: alu_op, mem_read, alu_src, mem_to_reg)
   - ✅ Refresher: register fields (rs1/rs2/rd 5-bit), x0
   - ✅ L2 register file (x0: read-side mux is what guarantees 0; write guard alone fails since no reset)
   - ✅ L3 PC + branch (`branch && zero`); user found bne acts as beq; fix idea = route funct3 into next-PC, invert zero for bne. Teaser left open: blt can't use zero flag (hint: SLT).
   - ✅ L4 imm_gen (formats, sign-extend from bit 31, B-type implicit bit0 → doubles reach, negative offsets)
   - ✅ L5 ALU + alu_control: user found the addi-1030 bug. Fix concept agreed: give alu_control `opcode[5]` (R=1, I=0) (or a distinct alu_op for I-type); I-type ignores funct7 except funct3=101 (srli/srai; shamt is only imm[4:0], so imm[11:5] is free to act as funct7).
   - ✅ L6 data_mem: byte address → word index = addr[7:2] (÷4 drops [1:0]; 64 words = 6 bits; bits ≥8 dropped → aliasing every 256 B, e.g. 0x120 and 0x020 both hit index 8). User needed the decimal "÷4 then wrap at 64, like a clock" explanation to click.
   - ✅ L7 accel hookup (concept only): memory map 0x000–0x0FF data_mem, 0x100–0x1FF ml_accel (matches program.hex); decoder uses `addr[8]`; route enables to selected device only; mux read data back; accel gets low 6 address bits. User needed the "compare range edges bit-by-bit" method to find the select bit.
3. **IN PROGRESS → Refresh verification.** Part 1 taught 2026-11-18 (directed tests; self-checking vs print-only; cpu_top_tb checks regs only once at end). **Open question (unanswered, resume here):** name a bug that happens mid-program but leaves final regs correct (e.g. reg written wrong then overwritten, wrong store address since memory isn't checked, skipped instr x7 written) → motivates per-instruction monitor + scoreboard. Remaining parts: what's tested vs not; what a class-based TB must check; simulator choice (Icarus lacks SV class/constraint/covergroup support → Verilator 5.x (partial), or free tools: Questa Intel FPGA edition, Vivado xsim, EDA Playground); short ordered plan.
4. Three warm-up SV exercises (e.g. self-checking ALU / regfile tests); review user's code with guiding questions.
5. Architecture enhancements (only after TB works): plan → user implements → review.

## Repo facts (verified 2026-10-17, unchanged 2026-11-15)
- Main checkout: `/home/marwan/personal_projects/riscv-ml-coprocessor-soc` (branch main). Files show "modified" only due to chmod/mode changes (0 line diffs).
- `rtl/`: pc, instr_mem, decoder, control, alu_control, alu, imm_gen, regfile, data_mem, cpu_top, ml_accel; `soc_top.v` **empty**.
- `testbench/`: one TB per module + `cpu_top_tb.sv`. Self-checking: alu, alu_control, control, cpu_top. Print-only: pc, regfile, instr_mem, decoder, imm_gen, data_mem, ml_accel.
- `synthesis/ openlane/ scripts/ results/` **empty / never committed** → no Yosys/OpenLane/GDS evidence in repo. Don't claim layout results unless redone.
- `srcs/program.hex` untracked, never loaded (no `$readmemh`); `instr_mem.v` hardcodes a 10-instr program. Hex looks like an accelerator test (base 0x100, control at 0x120).
- Single-cycle RV32 subset: R-type (all 10), I-type ALU, `lw`, `sw`, `beq`. Unknown opcodes = NOP (lui/auipc/jal/jalr). imm_gen already builds U/J immediates.
- `ml_accel`: 4-elem dot product, regs A 0x00–0x0C, B 0x10–0x1C, start 0x20, result 0x24; FSM IDLE→COMPUTE→DONE; not connected to CPU.
- `cpu_top.v:143-152` prints debug every clock (noise).

## Baseline
- `cpu_top_tb` **PASSES** (Icarus, 2026-11-15). Run from main checkout root:
  `iverilog -g2012 -o cpu_test testbench/cpu_top_tb.sv rtl/cpu_top.v rtl/pc.v rtl/instr_mem.v rtl/decoder.v rtl/control.v rtl/alu_control.v rtl/alu.v rtl/imm_gen.v rtl/regfile.v rtl/data_mem.v && vvp cpu_test | tail -12`

## Bug list (fix only after TB exists — write the failing test first)
1. **Found by user:** `addi` imm 1024–1055 → SUB (alu_control.v:14 uses funct7 for I-type; those bits are the immediate). Planned fix #1.
2. **Found by user:** branch ignores funct3 → bne/blt/bge/bltu/bgeu behave as beq.
3. Not yet discussed (let user discover): load/store ignore funct3 (lb/lh/sb/sh act as word); cpu_top has no outputs (synthesis would prune all logic); regfile/ml_accel vectors have no reset; ml_accel `addr` is 6-bit but case labels are 8'hXX; 32-bit truncating multiply; ml_accel_tb reads r_data after dropping r_en (possible race); alu_tb prints PASS based only on zero check; cpu_top_tb doesn't check x7/x0.

## Interview stories collected
- "My directed test passed, but a corner case (addi 1030) silently became SUB — coverage on immediate ranges / funct3 per opcode would have exposed it." → motivates constrained-random + coverage.
