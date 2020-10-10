#!/bin/bash
#Input: .tex, .bib
#Function: Run LaTeX, save .pdf file and remove others
#Output: .pdf file

pdflatex $1.tex
bibtex $1

rm *~
rm *.aux
rm *.dvi
rm *.log
rm *.nav
rm *.out
rm *.snm
rm *.toc
