#!/bin/bash
# setup.sh - Project setup script for BNNPowerSupply

set -e  # Exit on error

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$PROJECT_ROOT/.venv"

echo "=========================================="
echo "BNN Power Supply FPGA Project Setup"
echo "=========================================="

# Check if Python is available
if ! command -v python &> /dev/null; then
    echo "❌ Error: Python not found. Please install Python 3.8 or later."
    exit 1
fi

# Create virtual environment if it doesn't exist
if [ ! -d "$VENV_DIR" ]; then
    echo "📦 Creating virtual environment..."
    python -m venv "$VENV_DIR"
    echo "✅ Virtual environment created"
else
    echo "✅ Virtual environment already exists"
fi

# Activate virtual environment
echo "🔧 Activating virtual environment..."
if [ -f "$VENV_DIR/Scripts/activate" ]; then
    source "$VENV_DIR/Scripts/activate"
elif [ -f "$VENV_DIR/bin/activate" ]; then
    source "$VENV_DIR/bin/activate"
else
    echo "❌ Error: Could not find activation script"
    exit 1
fi

# Upgrade pip
echo "⬆️  Upgrading pip..."
python -m pip install --upgrade pip -q

# Install requirements
if [ -f "$PROJECT_ROOT/requirements.txt" ]; then
    echo "📚 Installing Python dependencies..."
    pip install -r "$PROJECT_ROOT/requirements.txt" -q
    echo "✅ Dependencies installed"
else
    echo "⚠️  Warning: requirements.txt not found"
fi

# Check for Vivado
echo ""
echo "🔍 Checking for Vivado installation..."
if [ -f "/c/AMDDesignTools/2025.2/Vivado/bin/vivado.bat" ]; then
    echo "✅ Vivado found at: /c/AMDDesignTools/2025.2/Vivado"
else
    echo "⚠️  Warning: Vivado not found at expected location"
    echo "   Update VIVADO path in Makefile if needed"
fi

# Create build directory if it doesn't exist
mkdir -p "$PROJECT_ROOT/fpga/build"

echo ""
echo "=========================================="
echo "✅ Setup complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  1. Activate environment: source .venv/Scripts/activate"
echo "  2. Build FPGA project:   make fpga"
echo ""
echo "For quick activation, run: source activate.sh"
echo "=========================================="