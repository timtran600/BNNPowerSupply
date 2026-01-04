.PHONY: venv fpga vivado clean help

# Python (MSYS2 / Windows venv)
PYTHON := .venv/Scripts/python
PIP    := .venv/Scripts/pip

# Auto-detect Vivado - Simple shell approach
VIVADO := $(shell \
    if [ -f /c/AMDDesignTools/2025.2/Vivado/bin/vivado.bat ]; then \
        echo /c/AMDDesignTools/2025.2/Vivado/bin/vivado.bat; \
    elif [ -f /c/AMDDesignTools/Vivado/2025.2/bin/vivado.bat ]; then \
        echo /c/AMDDesignTools/Vivado/2025.2/bin/vivado.bat; \
    elif [ -f /c/Xilinx/Vivado/2025.2/bin/vivado.bat ]; then \
        echo /c/Xilinx/Vivado/2025.2/bin/vivado.bat; \
    elif [ -f /c/Xilinx/Vivado/2024.2/bin/vivado.bat ]; then \
        echo /c/Xilinx/Vivado/2024.2/bin/vivado.bat; \
    else \
        command -v vivado.bat 2>/dev/null || command -v vivado 2>/dev/null || echo ""; \
    fi)

# Check if Vivado was found
ifeq ($(VIVADO),)
$(info ============================================)
$(info ERROR: Vivado not found!)
$(info )
$(info Searched locations:)
$(info   - /c/AMDDesignTools/2025.2/Vivado/bin/)
$(info   - /c/Xilinx/Vivado/2025.2/bin/)
$(info   - System PATH)
$(info )
$(info Please set VIVADO path manually:)
$(info   make VIVADO=/path/to/vivado.bat fpga)
$(info )
$(info Or edit Makefile and set:)
$(info   VIVADO := /your/path/to/vivado.bat)
$(info ============================================)
$(error Vivado not found)
endif

# Default target
.DEFAULT_GOAL := help

help:
	@echo "BNN Power Supply FPGA Build System"
	@echo "===================================="
	@echo "Vivado: $(VIVADO)"
	@echo ""
	@echo "Available targets:"
.PHONY: venv fpga vivado clean help

# Python (MSYS2 / Windows venv)
PYTHON := .venv/Scripts/python
PIP    := .venv/Scripts/pip

# Auto-detect Vivado - Simple shell approach
VIVADO := $(shell \
    if [ -f /c/AMDDesignTools/2025.2/Vivado/bin/vivado.bat ]; then \
        echo /c/AMDDesignTools/2025.2/Vivado/bin/vivado.bat; \
    elif [ -f /c/AMDDesignTools/Vivado/2025.2/bin/vivado.bat ]; then \
        echo /c/AMDDesignTools/Vivado/2025.2/bin/vivado.bat; \
    elif [ -f /c/Xilinx/Vivado/2025.2/bin/vivado.bat ]; then \
        echo /c/Xilinx/Vivado/2025.2/bin/vivado.bat; \
    elif [ -f /c/Xilinx/Vivado/2024.2/bin/vivado.bat ]; then \
        echo /c/Xilinx/Vivado/2024.2/bin/vivado.bat; \
    else \
        command -v vivado.bat 2>/dev/null || command -v vivado 2>/dev/null || echo ""; \
    fi)

# Check if Vivado was found
ifeq ($(VIVADO),)
$(info ============================================)
$(info ERROR: Vivado not found!)
$(info )
$(info Searched locations:)
$(info   - /c/AMDDesignTools/2025.2/Vivado/bin/)
$(info   - /c/Xilinx/Vivado/2025.2/bin/)
$(info   - System PATH)
$(info )
$(info Please set VIVADO path manually:)
$(info   make VIVADO=/path/to/vivado.bat fpga)
$(info )
$(info Or edit Makefile and set:)
$(info   VIVADO := /your/path/to/vivado.bat)
$(info ============================================)
$(error Vivado not found)
endif

# Default target
.DEFAULT_GOAL := help

help:
	@echo "BNN Power Supply FPGA Build System"
	@echo "===================================="
	@echo "Vivado: $(VIVADO)"
	@echo ""
	@echo "Available targets:"
	@echo "  make setup          - Run initial project setup"
	@echo "  make venv           - Create virtual environment"
	@echo "  make fpga           - Build FPGA project"
	@echo "  make gen_filelists  - Generate file lists only"
	@echo "  make clean          - Clean build artifacts"
	@echo "  make help           - Show this help message"
	@echo ""
	@echo "Override Vivado path:"
	@echo "  make VIVADO=/path/to/vivado.bat fpga"

setup:
	@bash setup.sh

venv:
	python -m venv .venv
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt

fpga: gen_filelists vivado

gen_filelists:
	$(PYTHON) fpga/scripts/python/gen_filelists.py

vivado:
	@echo "Using Vivado: $(VIVADO)"
	$(VIVADO) -mode batch \
		-source fpga/scripts/vivado/build.tcl \
		-tclargs smart_psu_fpga xc7s25csga324-1 fpga_top

clean:
	rm -rf fpga/build/*