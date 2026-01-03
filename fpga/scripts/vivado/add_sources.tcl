read_verilog -sv [glob build/rtl.f]
read_xdc [glob build/xdc.f]
read_ip [glob build/ip.f]
upgrade_ip [get_ips]
