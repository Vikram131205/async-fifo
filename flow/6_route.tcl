# =========================================================
# STEP 6: ROUTING (OpenROAD)
# =========================================================
# Global routing (coarse paths) then detailed routing (exact metal tracks).
# Produces the final routed DEF and DRC violation report.
# Run:  openroad flow/6_route.tcl
# =========================================================

# ── Read Technology ──────────────────────────────────────
read_lef /OpenROAD-flow-scripts/flow/platforms/sky130hd/lef/sky130_fd_sc_hd.tlef
read_lef /OpenROAD-flow-scripts/flow/platforms/sky130hd/lef/sky130_fd_sc_hd_merged.lef
read_liberty /OpenROAD-flow-scripts/flow/platforms/sky130hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# ── Load Design ─────────────────────────────────────────
read_def outputs/cts.def
read_sdc constraints/constraints.sdc

# ── Wire RC Estimation ──────────────────────────────────
set_wire_rc -clock -layer met5
set_wire_rc -signal -layer met3

# ── Post-CTS Legalization ───────────────────────────────
detailed_placement
check_placement

# ── Global Route → Detailed Route ───────────────────────
global_route
detailed_route \
    -output_drc outputs/route_drc.rpt

# ── Save ────────────────────────────────────────────────
write_def outputs/routed.def
