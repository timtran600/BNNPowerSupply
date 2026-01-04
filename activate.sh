#!/bin/bash
# activate.sh - Quick activation script

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f "$PROJECT_ROOT/.venv/Scripts/activate" ]; then
    source "$PROJECT_ROOT/.venv/Scripts/activate"
    echo "✅ Virtual environment activated"
    echo "Python: $(which python)"
    echo "Run 'make fpga' to build the project"
elif [ -f "$PROJECT_ROOT/.venv/bin/activate" ]; then
    source "$PROJECT_ROOT/.venv/bin/activate"
    echo "✅ Virtual environment activated"
else
    echo "❌ Virtual environment not found"
    echo "Run './setup.sh' to create it"
    exit 1
fi