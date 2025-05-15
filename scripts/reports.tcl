#===========================================================================
# Reports Script (reports.tcl)
#===========================================================================

# Check for constraint violations
check_timing
report_constraint -all_violators -verbose > $REPORT_DIR/constraint_violations.rpt

# Summary reports
report_design > $REPORT_DIR/design.rpt
report_reference > $REPORT_DIR/reference.rpt
report_qor > $REPORT_DIR/qor.rpt

# Timing reports
report_timing -max_paths 100 -slack_lesser_than 0 -delay max > $REPORT_DIR/setup_violations.rpt
report_timing -max_paths 100 -slack_lesser_than 0 -delay min > $REPORT_DIR/hold_violations.rpt
report_timing -max_paths 10 -through [get_pins *] -delay max > $REPORT_DIR/top_critical_paths.rpt

# Report specific paths in your design
# Path from first flip-flop to second flip-flop
report_timing -from [get_pins ff1/Q] -to [get_pins ff2/D] > $REPORT_DIR/ff1_to_ff2_path.rpt

# Path from second flip-flop to third flip-flop
report_timing -from [get_pins ff2/Q] -to [get_pins ff3/D] > $REPORT_DIR/ff2_to_ff3_path.rpt

# Path from inputs to first flip-flop
report_timing -from [get_ports {a b c}] -to [get_pins ff1/D] > $REPORT_DIR/inputs_to_ff1.rpt

# Path from last flip-flop to output
report_timing -from [get_pins ff3/Q] -to [get_ports q_out] > $REPORT_DIR/ff3_to_output.rpt

# Clock reports
report_clock -skew > $REPORT_DIR/clock_skew.rpt
report_clock_timing -type skew > $REPORT_DIR/detailed_clock_skew.rpt

puts "Reports generated successfully in $REPORT_DIR"
