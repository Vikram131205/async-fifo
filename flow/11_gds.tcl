# =========================================================
# STEP 9: GDS-II EXPORT (OpenROAD + KLayout)
# =========================================================
# Converts the routed DEF into the final GDS-II layout file.
# This is the "tape-out" format sent to the foundry.
# Run:  openroad flow/11_gds.tcl
# =========================================================

# ── Read Technology ──────────────────────────────────────
read_lef /OpenROAD-flow-scripts/flow/platforms/sky130hd/lef/sky130_fd_sc_hd.tlef
read_lef /OpenROAD-flow-scripts/flow/platforms/sky130hd/lef/sky130_fd_sc_hd_merged.lef

# ── Load Routed Design ──────────────────────────────────
read_def outputs/routed.def

# ── Export GDS-II ───────────────────────────────────────
write_gds outputs/asy_fifo.gds
