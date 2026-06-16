# =========================================================
# STEP 4: DETAILED PLACEMENT (OpenROAD)
# =========================================================
# Legalizes cell positions — snaps to grid, removes overlaps.
# Run:  openroad flow/4_detailed_placement.tcl
# =========================================================

# ── Read Technology ──────────────────────────────────────
read_lef /OpenROAD-flow-scripts/flow/platforms/sky130hd/lef/sky130_fd_sc_hd.tlef
read_lef /OpenROAD-flow-scripts/flow/platforms/sky130hd/lef/sky130_fd_sc_hd_merged.lef
read_liberty /OpenROAD-flow-scripts/flow/platforms/sky130hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# ── Load Global Placement ───────────────────────────────
read_def outputs/placed.def

# ── Detailed Placement ──────────────────────────────────
detailed_placement
check_placement

# ── Save ────────────────────────────────────────────────
write_def outputs/detailed_placement.def
