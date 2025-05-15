# ocv_config.tcl - OCV configuration for PrimeTime
# This script configures On-Chip Variation settings

puts "=== Setting up OCV Analysis ==="

# Enable OCV mode
set timing_pocvm_enable_analysis true
puts "OCV analysis enabled"

# Global derating factors (adjust these values based on your process)
set_timing_derate -early 0.95 -cell_delay
set_timing_derate -late  1.05 -cell_delay

# Net delay derating (for interconnect)
set_timing_derate -early 0.97 -net_delay
set_timing_derate -late  1.03 -net_delay

# Setup/hold check derating
set_timing_derate -early 0.95 -cell_check
set_timing_derate -late  1.05 -cell_check

puts "OCV derating factors applied"

# Add additional OCV reports
proc create_ocv_reports {report_dir} {
    # Report OCV settings
    report_timing_derate > $report_dir/ocv_derating.rpt
    puts "OCV derating settings saved to $report_dir/ocv_derating.rpt"
    
    # OCV-specific timing reports
    report_timing -max_paths 10 -delay_type max > $report_dir/setup_timing_ocv.rpt
    report_timing -max_paths 10 -delay_type min > $report_dir/hold_timing_ocv.rpt
    
    # You can add more OCV-specific reports here
}

puts "=== OCV Configuration Completed ==="
