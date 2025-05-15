#===========================================================================
# Setup Script (setup.tcl)
#===========================================================================

# Set up libraries - Update these paths with your actual library locations
set LIB_PATH "/path/to/libraries"  # Update this path
set_app_var search_path "$search_path $NETLIST_DIR $CONST_DIR $LIB_PATH"

# Standard cell libraries - Update with your actual libraries
set_app_var link_library "*.db"  # Update with your actual libraries
set_app_var target_library "target_library.db"  # Update with your target library

# Set analysis type (setup, hold, or both)
set_app_var timing_enable_multiple_clocks_per_reg true
set_app_var timing_report_unconstrained_paths true
set_app_var timing_save_pin_arrival_and_slack true
set_app_var case_analysis_propagate_through_icg true

# Read design netlist - Use the appropriate format based on what you have
if {[file exists "$NETLIST_DIR/${DESIGN_NAME}.v"]} {
    # If you have a synthesized netlist
    read_verilog "$NETLIST_DIR/${DESIGN_NAME}.v"
} elseif {[file exists "$NETLIST_DIR/${DESIGN_NAME}.db"]} {
    # If you have a DB format file
    read_db "$NETLIST_DIR/${DESIGN_NAME}.db"
} else {
    # If you don't have a netlist, you can use the RTL directly for initial analysis
    # Note: This will be interpreted as behavioral model, not a true netlist
    puts "Warning: No netlist found. Using RTL for behavioral analysis."
    read_verilog "$WORK_DIR/rtl/${DESIGN_NAME}.v"
}

current_design $TOP_MODULE
link_design

# Optional: Floorplan information if available
# read_parasitics -format SPEF "$NETLIST_DIR/${DESIGN_NAME}.spef"

puts "Setup completed successfully."
