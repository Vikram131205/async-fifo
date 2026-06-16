# =========================================================
# STEP 5: CLOCK TREE SYNTHESIS (OpenROAD)
# =========================================================
# Inserts clock buffers to minimize skew across all flip-flops.
# This is critical for the async FIFO — two independent clock
# trees are built: one for wclk (100 MHz) and one for rclk (50 MHz).
# Run:  openroad flow/5_cts.tcl
# =========================================================

# ── Read Technology ──────────────────────────────────────
read_lef /OpenROAD-flow-scripts/flow/platforms/sky130hd/lef/sky130_fd_sc_hd.tlef
read_lef /OpenROAD-flow-scripts/flow/platforms/sky130hd/lef/sky130_fd_sc_hd_merged.lef
read_liberty /OpenROAD-flow-scripts/flow/platforms/sky130hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# ── Load Design ─────────────────────────────────────────
read_def outputs/detailed_placement.def
read_sdc constraints/constraints.sdc

# ── Wire RC Estimation ──────────────────────────────────
set_wire_rc -clock -layer met5
set_wire_rc -signal -layer met3

# ── CTS Configuration ───────────────────────────────────
set_cts_config \
    -buf_list {sky130_fd_sc_hd__clkbuf_2 sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_8}

# ── Run Clock Tree Synthesis ────────────────────────────
clock_tree_synthesis

# ── Reports ─────────────────────────────────────────────
report_clock_skew
report_checks

# ── Save ────────────────────────────────────────────────
write_def outputs/cts.def
