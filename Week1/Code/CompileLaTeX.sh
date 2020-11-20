#!/bin/bash
#Auther: Cong liu (cong.liu20@imperial.ac.uk)
#Script: CompileLaTeX.sh
#Work Path: CMEECourseWork/Week1/Code
#Input: .tex and .bib files in Code/
#Function: Run LaTeX, save .pdf file in Writeup/ and remove other files
#Output: .pdf file in Writeup/
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


mv *.pdf ../Writeup
