# =========================================================
# STEP 8a: PRE-ROUTE STA (OpenSTA)
# =========================================================
# Static Timing Analysis on the synthesized netlist BEFORE
# physical design. Provides an initial timing picture.
# Run:  sta flow/8_sta.tcl
# =========================================================

# ── Read Library ────────────────────────────────────────
read_liberty /OpenROAD-flow-scripts/flow/platforms/sky130hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# ── Read Synthesized Netlist ────────────────────────────
read_verilog outputs/synthesized_fifo.v
link_design asy_FIFO

# ── Read Timing Constraints ────────────────────────────
read_sdc constraints/constraints.sdc

# ── Reports ─────────────────────────────────────────────
report_checks
report_wns
report_tns
