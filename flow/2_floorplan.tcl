# =========================================================
# STEP 2: FLOORPLAN (OpenROAD)
# =========================================================
# Defines die area, places I/O pins, and creates routing tracks.
# Run:  openroad flow/2_floorplan.tcl
# =========================================================

# ── Read Technology ──────────────────────────────────────
read_lef /OpenROAD-flow-scripts/flow/platforms/sky130hd/lef/sky130_fd_sc_hd.tlef
read_lef /OpenROAD-flow-scripts/flow/platforms/sky130hd/lef/sky130_fd_sc_hd_merged.lef
read_liberty /OpenROAD-flow-scripts/flow/platforms/sky130hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# ── Read Synthesized Netlist ─────────────────────────────
read_verilog outputs/synthesized_fifo.v
link_design asy_FIFO

# ── Read Timing Constraints ─────────────────────────────
read_sdc constraints/constraints.sdc

# ── Initialize Floorplan ─────────────────────────────────
initialize_floorplan \
    -site unithd \
    -utilization 50 \
    -aspect_ratio 1.0 \
    -core_space 5

# ── Create Routing Tracks ───────────────────────────────
source /OpenROAD-flow-scripts/flow/platforms/sky130hd/make_tracks.tcl

# ── Place I/O Pins ──────────────────────────────────────
place_pins \
   -hor_layers met3 \
   -ver_layers met2

# ── Save ────────────────────────────────────────────────
write_def outputs/floorplan.def
