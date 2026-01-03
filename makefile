.PHONY: venv fpga vivado clean

# Python (MSYS2 / Windows venv)
PYTHON := .venv/Scripts/python
PIP    := .venv/Scripts/pip

venv:
	python -m venv .venv
	.venv\Scripts\Activate.ps1
	$(PIP) install -r tools/python/requirements.txt

fpga: gen_filelists vivado

gen_filelists:
	$(PYTHON) fpga/scripts/python/gen_filelists.py

vivado:
	vivado -mode batch \
		-source fpga/scripts/vivado/build.tcl \
		-tclargs smart_psu_fpga xc7s25csga324-1 fpga_top

clean:
	rm -rf fpga/build/*
