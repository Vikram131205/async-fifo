# =========================================================
# STEP 8c: STA WITH SPEF BACK-ANNOTATION (OpenROAD)
# =========================================================
# Alternative STA that reads a pre-extracted SPEF file instead
# of extracting parasitics on-the-fly. Useful for running STA
# separately from the PnR flow.
# Run:  openroad flow/10_sta_spef.tcl
# =========================================================

# ── Read Technology ──────────────────────────────────────
read_lef /OpenROAD-flow-scripts/flow/platforms/sky130hd/lef/sky130_fd_sc_hd.tlef
read_lef /OpenROAD-flow-scripts/flow/platforms/sky130hd/lef/sky130_fd_sc_hd_merged.lef

# ── Load Routed Design ──────────────────────────────────
read_def outputs/routed.def
read_liberty /OpenROAD-flow-scripts/flow/platforms/sky130hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_sdc constraints/constraints.sdc

# ── Read Pre-Extracted SPEF ─────────────────────────────
read_spef outputs/asy_fifo.spef

# ── Use Real Clock Delays ───────────────────────────────
set_propagated_clock [all_clocks]

# ── Timing Reports ──────────────────────────────────────
report_wns
report_tns
report_checks -path_delay max
report_checks -path_delay min
