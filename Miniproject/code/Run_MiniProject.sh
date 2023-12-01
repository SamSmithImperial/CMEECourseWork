#!/bin/bash

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
texcount -1 -sum Write_up.tex > WordCount.sum

pdflatex -shell-escape Write_up.tex
bibtex Write_up
pdflatex Write_up.tex
pdflatex Write_up.tex


rm -f *.aux *.log *.out *.fls *.sum *.bbl *.blg 

echo "Script execution complete. Please find Write_up.pdf in the code directory"
