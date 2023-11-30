#!/bin/bash
# To run this script write './run.sh' in the terminal
# Run Python script
echo "Running DataWrangling.py..."
python3 DataWrangling.py

# Run R script
echo "Running Fitting_Models.R..."
Rscript Fitting_Models.R

# Run another R script
echo "Running Plotting.R..."
Rscript Plotting.R

# Compile LaTeX document
echo "Compiling Write_up.tex..."
pdflatex Write_up.tex

rm -f *.aux *.log *.out 
rm -f *.fls

echo "Script execution complete. Please find Write_up.pdf in the code directory"
