#!/bin/bash
# Setup script for the "Transformers for Bayesian statistics" project.
# Installs the Python dependencies and the PFNs library.

set -e

echo "=== Installing Python dependencies ==="
python3 -m pip install -r requirements.txt

echo ""
echo "=== Cloning and installing PFNs ==="
if [ -d "PFNs" ]; then
    echo "PFNs directory already exists, pulling latest changes..."
    cd PFNs && git pull && cd ..
else
    git clone https://github.com/automl/PFNs.git
fi
cd PFNs && python3 -m pip install -e . -q && cd ..

echo ""
echo "=== Setup complete ==="
echo "Start Jupyter and open the notebooks/ folder: jupyter notebook"
