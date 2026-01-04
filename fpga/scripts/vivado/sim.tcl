read_verilog -sv [glob build/rtl.f]
read_verilog -sv sim/tb_fpga_top.sv
set_property top tb_fpga_top [current_fileset]
launch_simulation
run 10 ms
