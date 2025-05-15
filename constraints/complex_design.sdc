# complex_design.sdc
# SDC constraints file for complex_design

# Define the clock
create_clock -name main_clock -period 10.0 [get_ports clk]

# Clock uncertainty for setup and hold analysis
set_clock_uncertainty -setup 0.1 [get_clocks main_clock]
set_clock_uncertainty -hold 0.05 [get_clocks main_clock]

# Clock transition
set_clock_transition 0.1 [get_clocks main_clock]

# Input delay for input ports (assuming they are driven by flip-flops in another block)
set_input_delay -clock main_clock -max 2.0 [get_ports {a b c}]
set_input_delay -clock main_clock -min 0.5 [get_ports {a b c}]

# Output delay for output ports (assuming they drive flip-flops in another block)
set_output_delay -clock main_clock -max 2.0 [get_ports q_out]
set_output_delay -clock main_clock -min 0.5 [get_ports q_out]

# Input drive strength and transition
# Update the lib_cell name with a cell from your actual library
# set_driving_cell -lib_cell INVX1 [get_ports {a b c}]
set_input_transition -max 0.5 [get_ports {a b c}]
set_input_transition -min 0.1 [get_ports {a b c}]

# Output load (represents the capacitive load driven by the output)
set_load 0.1 [get_ports q_out]

# Set false paths for asynchronous reset (if used asynchronously)
# Since your reset is synchronous according to the RTL, this is commented out
# set_false_path -from [get_ports rst]

# Define case analysis for constants if any
# set_case_analysis 1 [get_ports constant_high_port]

# Set multicycle paths if needed (none apparent in this design)
# set_multicycle_path 2 -setup -from [get_pins ff1/Q] -to [get_pins ff3/D]
