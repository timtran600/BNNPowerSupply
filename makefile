.PHONY: venv fpga vivado clean

# Python (MSYS2 / Windows venv)
PYTHON := .venv/Scripts/python
PIP    := .venv/Scripts/pip
VIVADO := /c/AMDDesignTools/2025.2/Vivado/bin/vivado.bat

# Default target
.DEFAULT_GOAL := help

help:
	@echo "BNN Power Supply FPGA Build System"
	@echo "===================================="
	@echo "Available targets:"
	@echo "  make setup          - Run initial project setup"
	@echo "  make venv           - Create virtual environment"
	@echo "  make fpga           - Build FPGA project"
	@echo "  make gen_filelists  - Generate file lists only"
	@echo "  make clean          - Clean build artifacts"
	@echo "  make help           - Show this help message"
	
venv:
	python -m venv .venv
	.venv\Scripts\Activate.ps1
	$(PIP) install -r tools/python/requirements.txt

fpga: gen_filelists vivado

gen_filelists:
	$(PYTHON) fpga/scripts/python/gen_filelists.py

vivado:
	$(VIVADO) -mode batch \
		-source fpga/scripts/vivado/build.tcl \
		-tclargs smart_psu_fpga xc7s25csga324-1 fpga_top

clean:
	rm -rf fpga/build/*
