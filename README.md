# Asynchronous FIFO — RTL to GDS-II

A fully functional **Asynchronous FIFO** with a complete **RTL-to-GDS physical design flow** using open-source EDA tools targeting **SkyWater 130nm** technology.

```
 Write Clock Domain (100 MHz)          Read Clock Domain (50 MHz)
 ─────────────────────────────         ─────────────────────────────
                                        
  data_in ──►┌──────────────┐           ┌──────────────┐──► data_out
  w_en ─────►│  Pseudo Dual │           │  Pseudo Dual │◄── r_en
             │  Port RAM    │           │  Port RAM    │
  wclk ─────►│  (8 × 32b)  │           │  (8 × 32b)  │◄── rclk
             └──────────────┘           └──────────────┘
                   ▲                          ▲
              bin_w_ptr                  bin_r_ptr
                   │                          │
             ┌─────┴─────┐              ┌─────┴─────┐
             │  Write Ptr │◄── 2-FF ───►│  Read Ptr  │
             │  Logic     │  Synchron.  │  Logic     │
             │            │             │            │
             │ full flag  │  gray_w_ptr │ empty flag │
             │ generation │◄───────────►│ generation │
             └────────────┘  gray_r_ptr └────────────┘
```

## Architecture

| Module | File | Purpose |
|--------|------|---------|
| `asy_FIFO` | `rtl/asy_FIFO.v` | Top-level wrapper — connects pointer logic with memory |
| `top_module` | `rtl/top_module.v` | Instantiates write/read pointers and 2-FF synchronizers |
| `write_ptr_logic` | `rtl/write_ptr_logic.v` | Write pointer + **full flag** generation |
| `read_ptr_logic` | `rtl/read_ptr_logic.v` | Read pointer + **empty flag** generation |
| `pseudo_dual` | `rtl/pseudo_dual.v` | Dual-port RAM (8 entries × 32-bit) |
| `synchroniser` | `rtl/synchroniser.v` | 2-flip-flop CDC synchronizer |
| `bcd_gray` | `rtl/bcd_gray.v` | Binary → Gray code converter |
| `gray_bcd` | `rtl/gray_bcd.v` | Gray → Binary code converter |
| `d_ff` | `rtl/d_ff.v` | D flip-flop building block |

### Key Design Features

- **Clock Domain Crossing (CDC):** Gray-coded pointers + 2-FF synchronizers ensure safe data transfer between the write clock (100 MHz) and read clock (50 MHz) domains
- **Full Flag:** Asserted when write pointer wraps around and catches up to the read pointer (MSB differs, lower bits match)
- **Empty Flag:** Asserted when read and write pointers are equal (same address, same wrap count)
- **Depth:** 8 entries, 32-bit data width (parameterizable)

## RTL-to-GDS Flow

Complete physical design flow using **Yosys** (synthesis) and **OpenROAD** (place & route), targeting **SkyWater SKY130 HD** standard cells.

```
 ┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
 │ 1. Synthesis │────►│ 2. Floorplan│────►│ 3. Global   │────►│ 4. Detailed │
 │   (Yosys)   │     │  (OpenROAD) │     │  Placement  │     │  Placement  │
 └─────────────┘     └─────────────┘     └─────────────┘     └─────────────┘
                                                                     │
 ┌─────────────┐     ┌─────────────┐     ┌─────────────┐            ▼
 │ 7. Parasitic│◄────│ 6. Routing  │◄────│ 5. Clock    │     ┌─────────────┐
 │ Extraction  │     │  (GR + DR)  │     │ Tree Synth  │◄────│ Legalized   │
 └──────┬──────┘     └─────────────┘     └─────────────┘     └─────────────┘
        │
        ▼
 ┌─────────────┐     ┌─────────────┐
 │ 8. Timing   │     │ 9. GDS-II   │
 │  Analysis   │     │   Export    │
 └─────────────┘     └─────────────┘
```

| Step | Script | Tool | Output |
|------|--------|------|--------|
| 1. Synthesis | `flow/1_synthesis.tcl` | Yosys | `synthesized_fifo.v` |
| 2. Floorplan | `flow/2_floorplan.tcl` | OpenROAD | `floorplan.def` |
| 3. Global Placement | `flow/3_global_placement.tcl` | OpenROAD | `placed.def` |
| 4. Detailed Placement | `flow/4_detailed_placement.tcl` | OpenROAD | `detailed_placement.def` |
| 5. Clock Tree Synthesis | `flow/5_cts.tcl` | OpenROAD | `cts.def` |
| 6. Routing | `flow/6_route.tcl` | OpenROAD | `routed.def` |
| 7. Parasitic Extraction | `flow/7_write_spef.tcl` | OpenROAD | `asy_fifo.spef` |
| 8a. Pre-Route STA | `flow/8_sta.tcl` | OpenSTA | Timing reports |
| 8b. Post-Route STA | `flow/9_sta_postroute.tcl` | OpenROAD | Timing reports |
| 8c. STA with SPEF | `flow/10_sta_spef.tcl` | OpenROAD | Timing reports |
| 9. GDS Export | `flow/11_gds.tcl` | OpenROAD | `asy_fifo.gds` |

### Timing Constraints

| Clock | Frequency | Period | Domain |
|-------|-----------|--------|--------|
| `wclk` | 100 MHz | 10 ns | Write |
| `rclk` | 50 MHz | 20 ns | Read |

- Asynchronous clock groups declared (`set_clock_groups -asynchronous`)
- Input delay: 2 ns, Output delay: 2 ns
- Clock uncertainty: 0.1 ns

## How to Run

### Prerequisites
- Docker with [OpenROAD-flow-scripts](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts)
- Or: Yosys + OpenROAD installed natively

### Step-by-Step (Docker)
```bash
# Start ORFS Docker container with this repo mounted
docker run -it -v $(pwd):/workspace openroad/flow-scripts bash

# Run each step in order:
cd /workspace
yosys -s flow/1_synthesis.tcl
openroad flow/2_floorplan.tcl
openroad flow/3_global_placement.tcl
openroad flow/4_detailed_placement.tcl
openroad flow/5_cts.tcl
openroad flow/6_route.tcl
openroad flow/7_write_spef.tcl
openroad flow/11_gds.tcl

# Timing analysis (any of):
sta flow/8_sta.tcl                    # Pre-route
openroad flow/9_sta_postroute.tcl     # Post-route (most accurate)
openroad flow/10_sta_spef.tcl         # With SPEF back-annotation
```

### Results
- **DRC Violations:** 0 (clean design)
- **GDS-II:** `outputs/asy_fifo.gds`

## Repository Structure

```
async-fifo/
├── rtl/                         # 9 Verilog source files
│   ├── asy_FIFO.v               #   Top-level wrapper
│   ├── top_module.v             #   Pointer logic + synchronizers
│   ├── write_ptr_logic.v        #   Write pointer + full flag
│   ├── read_ptr_logic.v         #   Read pointer + empty flag
│   ├── pseudo_dual.v            #   Dual-port RAM
│   ├── synchroniser.v           #   2-FF CDC synchronizer
│   ├── bcd_gray.v               #   Binary → Gray converter
│   ├── gray_bcd.v               #   Gray → Binary converter
│   └── d_ff.v                   #   D flip-flop
│
├── constraints/
│   └── constraints.sdc          # Timing constraints
│
├── flow/                        # RTL-to-GDS TCL scripts
│   ├── 1_synthesis.tcl          #   Yosys synthesis
│   ├── 2_floorplan.tcl          #   Floorplanning
│   ├── 3_global_placement.tcl   #   Global placement
│   ├── 4_detailed_placement.tcl #   Detailed placement
│   ├── 5_cts.tcl                #   Clock tree synthesis
│   ├── 6_route.tcl              #   Routing
│   ├── 7_write_spef.tcl         #   Parasitic extraction
│   ├── 8_sta.tcl                #   Pre-route STA
│   ├── 9_sta_postroute.tcl      #   Post-route STA
│   ├── 10_sta_spef.tcl          #   STA with SPEF
│   └── 11_gds.tcl               #   GDS-II export
│
└── outputs/                     # Flow outputs
    ├── synthesized_fifo.v       #   Gate-level netlist
    ├── floorplan.def            #   Floorplan DEF
    ├── routed.def               #   Final routed DEF
    ├── asy_fifo.gds             #   Final GDS-II layout
    └── route_drc.rpt            #   DRC report (0 violations)
```

## Tools & Technology

- **Yosys** — RTL synthesis
- **OpenROAD** — Floorplanning, placement, CTS, routing, parasitic extraction
- **OpenSTA** — Static timing analysis
- **SkyWater SKY130 HD** — 130nm standard cell library (TT corner, 25°C, 1.8V)
