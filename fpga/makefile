PROJECT = smart_power_supply
PART    = xc7s25csga324-1
TOP     = fpga_top

build:
	python3 scripts/python/gen_filelists.py
	vivado -mode batch \
		-source scripts/vivado/build.tcl \
		-tclargs $(PROJECT) $(PART) $(TOP)

sim:
	python3 scripts/python/gen_filelists.py
	vivado -mode batch \
		-source scripts/vivado/sim.tcl

clean:
	rm -rf build