# =========================================================
# STEP 1: SYNTHESIS (Yosys)
# =========================================================
# Converts RTL Verilog → Gate-level netlist using SKY130 cells.
# Tool: Yosys
# Run:  yosys -s flow/1_synthesis.tcl
# =========================================================

# ── Read RTL Files ───────────────────────────────────────
read_verilog rtl/asy_FIFO.v
read_verilog rtl/bcd_gray.v
read_verilog rtl/d_ff.v
read_verilog rtl/gray_bcd.v
read_verilog rtl/pseudo_dual.v
read_verilog rtl/read_ptr_logic.v
read_verilog rtl/synchroniser.v
read_verilog rtl/top_module.v
read_verilog rtl/write_ptr_logic.v

# ── Set Top Module ───────────────────────────────────────
hierarchy -check -top asy_FIFO

# ── Generic Synthesis ────────────────────────────────────
synth -top asy_FIFO

# ── Optimization ─────────────────────────────────────────
opt -full
clean

# ── Map Flip-Flops to SKY130 Cells ──────────────────────
dfflibmap -liberty /OpenROAD-flow-scripts/flow/platforms/sky130hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# ── ABC Technology Mapping ───────────────────────────────
abc -liberty /OpenROAD-flow-scripts/flow/platforms/sky130hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# ── Final Cleanup ────────────────────────────────────────
clean

# ── Write Outputs ────────────────────────────────────────
write_verilog outputs/synthesized_fifo.v
write_json outputs/synthesized_fifo.json

# ── Report Area/Cell Statistics ──────────────────────────
stat
