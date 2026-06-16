# =========================================================
# STEP 7: PARASITIC EXTRACTION (OpenROAD)
# =========================================================
# Extracts wire RC parasitics from the routed layout → SPEF file.
# The SPEF is used for accurate post-route timing analysis.
# Run:  openroad flow/7_write_spef.tcl
# =========================================================

# ── Read Technology ──────────────────────────────────────
read_lef /OpenROAD-flow-scripts/flow/platforms/sky130hd/lef/sky130_fd_sc_hd.tlef
read_lef /OpenROAD-flow-scripts/flow/platforms/sky130hd/lef/sky130_fd_sc_hd_merged.lef

# ── Load Routed Design ──────────────────────────────────
read_def outputs/routed.def

# ── Extract Parasitics ──────────────────────────────────
extract_parasitics \
    -ext_model_file /OpenROAD-flow-scripts/flow/platforms/sky130hd/rcx_patterns.rules

# ── Write SPEF ──────────────────────────────────────────
write_spef outputs/asy_fifo.spef
