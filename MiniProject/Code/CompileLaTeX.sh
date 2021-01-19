#Auther: Cong liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/MiniProject/Code
#Input: .tex and .bib files in Code/
#Function: Compile LaTeX, save .pdf file in Results/ and remove other files
#Output: .pdf file in ../Writeup
#Usage: bash CompileLaTeX.sh [Base name of .tex]
#Date: Nov 2020
pdflatex $1.tex
pdflatex $1.tex
bibtex $1
pdflatex $1.tex
pdflatex $1.tex

rm *.aux
rm *.log
rm *.out
rm *.bbl
rm *.blg


mv *.pdf ../Writeup
