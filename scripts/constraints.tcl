#===========================================================================
# Constraints Script (constraints.tcl)
#===========================================================================

# If SDC file exists, read it
if {[file exists "$CONST_DIR/${DESIGN_NAME}.sdc"]} {
    read_sdc "$CONST_DIR/${DESIGN_NAME}.sdc"
} else {
    # Basic constraints for complex_design if no SDC file is available
    puts "No SDC file found. Creating basic constraints for $DESIGN_NAME"
    
    # Create a clock on the clk pin with 10ns period (100MHz)
    create_clock -name main_clock -period 10 [get_ports clk]
    
    # Set clock uncertainty and transition times
    set_clock_uncertainty 0.1 [get_clocks main_clock]
    set_clock_transition 0.1 [get_clocks main_clock]
    
    # Define input and output delays
    set_input_delay -clock main_clock 2.0 [get_ports {a b c}]
    set_output_delay -clock main_clock 2.0 [get_ports q_out]
    
    # Define driving cell for inputs
    # Update the lib_cell name based on your technology library
    # set_driving_cell -lib_cell INVX1 [get_ports {a b c}]
    
    # Define load for outputs
    # set_load 0.1 [get_ports q_out]
}

# Set operating conditions
# set_operating_conditions -min min_cond -max max_cond -analysis_type bc_wc

puts "Constraints applied successfully."
