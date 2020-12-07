#!/bin/bash
#Auther: Cong liu (cong.liu20@imperial.ac.uk)
#Script: CompileLaTeX.sh
#Work Path: CMEECourseWork/MiniProject/Code
#Input: .tex and .bib files in Code/
#Function: Run LaTeX, save .pdf file in Results/ and remove other files
#Output: .pdf file in Results/
#Usage: bash Code/CompileLaTeX.sh [Base name of .tex]
#Date: Oct 2020

pdflatex $1.tex
pdflatex $1.tex
bibtex $1
pdflatex $1.tex
pdflatex $1.tex

rm *~
rm *.aux
rm *.dvi
rm *.log
rm *.nav
rm *.out
rm *.snm
rm *.toc
rm *.bbl
rm *.blg
rm *fdb_latexmk
rm *fls

mv *.pdf ../Results
