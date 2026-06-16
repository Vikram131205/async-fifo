# =========================================================
# STEP 3: GLOBAL PLACEMENT (OpenROAD)
# =========================================================
# Places cells in approximate locations to minimize wirelength.
# Run:  openroad flow/3_global_placement.tcl
# =========================================================

# ── Read Technology ──────────────────────────────────────
read_lef /OpenROAD-flow-scripts/flow/platforms/sky130hd/lef/sky130_fd_sc_hd.tlef
read_lef /OpenROAD-flow-scripts/flow/platforms/sky130hd/lef/sky130_fd_sc_hd_merged.lef
read_liberty /OpenROAD-flow-scripts/flow/platforms/sky130hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# ── Load Floorplan ───────────────────────────────────────
read_def outputs/floorplan.def

# ── Global Placement ────────────────────────────────────
global_placement

# ── Save ────────────────────────────────────────────────
write_def outputs/placed.def
