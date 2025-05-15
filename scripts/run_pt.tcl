# run_pt.tcl - Main PrimeTime script for complex_design
# Set project variables
set DESIGN_NAME "complex_design"
set TOP_MODULE $DESIGN_NAME

# Define directories
set SCRIPT_DIR    [file dirname [file normalize [info script]]]
set WORK_DIR      [file dirname $SCRIPT_DIR]
set NETLIST_DIR   "$WORK_DIR/netlist"
set CONST_DIR     "$WORK_DIR/constraints"
set REPORT_DIR    "$WORK_DIR/reports"
set OCV_DIR       "$WORK_DIR/ocv"

# Create report directory if it doesn't exist
file mkdir $REPORT_DIR

puts "=== Library Setup ==="
# Update library path with the corrected path
set LIB_PATH "../lib"
puts "Library path: $LIB_PATH"

# Add library path to search path
set_app_var search_path "$search_path $NETLIST_DIR $CONST_DIR $LIB_PATH $OCV_DIR"
puts "Search path: $search_path"

# List available library files
puts "Available library files:"
set lib_files [glob -nocomplain $LIB_PATH/*.db]
foreach lib $lib_files {
    puts "  $lib"
}

# If no specific .db files found, try standard names
if {[llength $lib_files] == 0} {
    puts "No .db files found in $LIB_PATH"
    puts "Trying standard library names..."
    
    # Try standard library names (update these to match your environment)
    set std_libs {
        "typical.db"
        "slow.db"
        "fast.db"
        "stdcell.db"
        "tech.db"
    }
    
    foreach lib $std_libs {
        if {[file exists "$LIB_PATH/$lib"]} {
            puts "Found library: $LIB_PATH/$lib"
            set lib_files "$LIB_PATH/$lib"
            break
        }
    }
}

# Set library variables
if {[llength $lib_files] > 0} {
    set_app_var link_library $lib_files
    set_app_var target_library [lindex $lib_files 0]
    puts "Using link_library: $link_library"
    puts "Using target_library: $target_library"
} else {
    puts "ERROR: No library files found. Please specify correct library path."
    return
}

# PrimeTime configuration
set timing_report_unconstrained_paths true
set timing_save_pin_arrival_and_slack true

puts "=== Reading Design ==="
# Read netlist
puts "Reading netlist: $NETLIST_DIR/${DESIGN_NAME}.v"
if {[catch {read_verilog "$NETLIST_DIR/${DESIGN_NAME}.v"} result]} {
    puts "Error reading netlist: $result"
    return
}

# Set and link design
if {[catch {current_design $TOP_MODULE} result]} {
    puts "Error setting current design: $result"
    return
}

if {[catch {link_design} result]} {
    puts "Error linking design: $result"
    return
}

# Read constraints
puts "Reading constraints: $CONST_DIR/${DESIGN_NAME}.sdc"
if {[catch {read_sdc "$CONST_DIR/${DESIGN_NAME}.sdc"} result]} {
    puts "Error reading constraints: $result"
    # Continue anyway to check the design
}

puts "Design and constraints loaded successfully."

# Check if OCV mode is enabled via command line argument
set enable_ocv 0
if {[info exists env(ENABLE_OCV)] && $env(ENABLE_OCV) == 1} {
    set enable_ocv 1
}

# Source OCV configuration if enabled
if {$enable_ocv} {
    puts "OCV mode is enabled, sourcing OCV configuration..."
    if {[file exists "$OCV_DIR/ocv_config.tcl"]} {
        source "$OCV_DIR/ocv_config.tcl"
        # Call the OCV reporting procedure defined in the OCV config file
        create_ocv_reports $REPORT_DIR
    } else {
        puts "Warning: OCV configuration file not found at $OCV_DIR/ocv_config.tcl"
    }
}

puts "=== Analysis & Reporting ==="
# Check for any issues in the design
check_timing > $REPORT_DIR/check_timing.rpt
report_design > $REPORT_DIR/design.rpt

# Report timing paths
if {[catch {report_timing -max_paths 10 -delay_type max > $REPORT_DIR/setup_timing.rpt} result]} {
    puts "Warning: Could not generate setup timing report: $result"
}
if {[catch {report_timing -max_paths 10 -delay_type min > $REPORT_DIR/hold_timing.rpt} result]} {
    puts "Warning: Could not generate hold timing report: $result"
}

# Report specific paths in the design
if {[catch {report_timing -from "FF1_reg/Q" -to "FF2_reg/D" > $REPORT_DIR/ff1_to_ff2.rpt} result]} {
    puts "Warning: Could not generate FF1 to FF2 path report: $result"
}
if {[catch {report_timing -from "FF2_reg/Q" -to "FF3_reg/D" > $REPORT_DIR/ff2_to_ff3.rpt} result]} {
    puts "Warning: Could not generate FF2 to FF3 path report: $result"
}

puts "STA analysis for $DESIGN_NAME completed successfully"
puts "Reports are available in $REPORT_DIR"
exit
