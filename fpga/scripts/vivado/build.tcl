# ------------------------------------------------------------
# Arguments
# ------------------------------------------------------------
if { $argc < 3 } {
    puts "ERROR: Usage: build.tcl <project_name> <part> <top>"
    exit 1
}

set proj_name [lindex $argv 0]
set part_name [lindex $argv 1]
set top_name  [lindex $argv 2]

puts "INFO: Project  = $proj_name"
puts "INFO: Part     = $part_name"
puts "INFO: Top      = $top_name"

# ------------------------------------------------------------
# Paths
# ------------------------------------------------------------
set repo_root [file normalize [file dirname [info script]]/../../..]
set fpga_root "$repo_root/fpga"
set build_dir "$fpga_root/build"

set rtl_f "$build_dir/rtl.f"
set ip_f  "$build_dir/ip.f"
set xdc_f "$build_dir/xdc.f"

foreach f [list $rtl_f $xdc_f] {
    if { ![file exists $f] } {
        puts "ERROR: Missing filelist: $f"
        exit 1
    }
}

# ------------------------------------------------------------
# Helper: Read filelist and return list of files
# ------------------------------------------------------------
proc read_filelist {flist_path} {
    set files [list]
    set fp [open $flist_path r]
    while {[gets $fp line] >= 0} {
        set line [string trim $line]
        # Skip empty lines and comments
        if {$line eq "" || [string match "#*" $line]} {
            continue
        }
        lappend files $line
    }
    close $fp
    return $files
}

# ------------------------------------------------------------
# Project
# ------------------------------------------------------------
create_project $proj_name $build_dir -part $part_name -force
set_property top $top_name [current_fileset]

# ------------------------------------------------------------
# Sources
# ------------------------------------------------------------
puts "INFO: Reading RTL files..."
set rtl_files [read_filelist $rtl_f]
foreach rtl_file $rtl_files {
    puts "  Adding: $rtl_file"
    read_verilog -sv $rtl_file
}

if { [file exists $ip_f] && [file size $ip_f] > 0 } {
    puts "INFO: Reading IP files..."
    set ip_files [read_filelist $ip_f]
    foreach ip_file $ip_files {
        puts "  Adding: $ip_file"
        read_ip $ip_file
    }
}

puts "INFO: Reading XDC constraints..."
set xdc_files [read_filelist $xdc_f]
foreach xdc_file $xdc_files {
    puts "  Adding: $xdc_file"
    read_xdc $xdc_file
}

# ------------------------------------------------------------
# Synthesis & Implementation
# ------------------------------------------------------------
puts "INFO: Running synthesis..."
synth_design -top $top_name

puts "INFO: Running implementation..."
opt_design
place_design
route_design

# ------------------------------------------------------------
# Reports
# ------------------------------------------------------------
puts "INFO: Generating reports..."
report_utilization -file "$build_dir/utilization.rpt"
report_timing_summary -file "$build_dir/timing_summary.rpt"

# ------------------------------------------------------------
# Bitstream
# ------------------------------------------------------------
puts "INFO: Writing bitstream..."
write_bitstream -force "$build_dir/${proj_name}.bit"

puts "INFO: Build complete!"