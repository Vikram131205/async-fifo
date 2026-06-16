# =========================================================
# CLOCK DEFINITIONS
# =========================================================

# Write clock: 100 MHz
create_clock -name wclk -period 10 [get_ports wclk]

# Read clock: 50 MHz
create_clock -name rclk -period 20 [get_ports rclk]

# =========================================================
# ASYNCHRONOUS CLOCK DOMAINS
# =========================================================

set_clock_groups -asynchronous \
-group {wclk} \
-group {rclk}

# =========================================================
# INPUT DELAYS
# =========================================================

# Data and write enable arrive 2 ns after wclk edge
set_input_delay 2 -clock wclk [get_ports data_in*]
set_input_delay 2 -clock wclk [get_ports w_en]

# Read enable arrives 2 ns after rclk edge
set_input_delay 2 -clock rclk [get_ports r_en]

# Reset arrival assumption
set_input_delay 1 -clock wclk [get_ports reset]

# =========================================================
# OUTPUT DELAYS
# =========================================================

# External logic needs FIFO output 2 ns before rclk edge
set_output_delay 2 -clock rclk [get_ports data_out*]

# Status flags
set_output_delay 2 -clock wclk [get_ports full]
set_output_delay 2 -clock rclk [get_ports empty]

# =========================================================
# CLOCK UNCERTAINTY
# =========================================================

set_clock_uncertainty 0.1 [get_clocks wclk]
set_clock_uncertainty 0.1 [get_clocks rclk]

# =========================================================
# OUTPUT LOADS
# =========================================================

set_load 0.05 [all_outputs]
