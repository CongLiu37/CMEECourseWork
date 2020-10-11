#!/bin/bash
#Auther: cong.liu20@imperial.ac.uk
#Script: CompileLaTeX.sh
#Running: In CMEECourseWork/Week1
#Input: .tex and .bib in Code/
#Function: Run LaTeX, save .pdf file in Writeup/ and remove other files
#Output: .pdf file in Writeup/
#Usage: bash Code/CompileLaTeX.sh [Base name of .tex]
#Date: Oct 2020

cd Code
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
cd ..
mv Code/*.pdf Writeup
