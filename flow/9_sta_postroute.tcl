# =========================================================
# STEP 8b: POST-ROUTE STA (OpenROAD)
# =========================================================
# Static Timing Analysis AFTER routing with extracted parasitics.
# This is the most accurate timing report — accounts for real
# wire delays from the routed layout.
# Run:  openroad flow/9_sta_postroute.tcl
# =========================================================

# ── Read Technology ──────────────────────────────────────
read_lef /OpenROAD-flow-scripts/flow/platforms/sky130hd/lef/sky130_fd_sc_hd.tlef
read_lef /OpenROAD-flow-scripts/flow/platforms/sky130hd/lef/sky130_fd_sc_hd_merged.lef

# ── Load Routed Design ──────────────────────────────────
read_def outputs/routed.def
read_liberty /OpenROAD-flow-scripts/flow/platforms/sky130hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_sdc constraints/constraints.sdc

# ── Use Real Clock Delays (not ideal) ───────────────────
set_propagated_clock [all_clocks]

# ── Extract Parasitics from Layout ──────────────────────
extract_parasitics \
    -ext_model_file /OpenROAD-flow-scripts/flow/platforms/sky130hd/rcx_patterns.rules

# ── Timing Reports ──────────────────────────────────────
report_wns
report_tns
report_checks -path_delay max -digits 4
report_checks -path_delay min -digits 4
