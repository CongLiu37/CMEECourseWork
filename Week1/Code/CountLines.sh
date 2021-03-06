#!/bin/bash
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: CountLines.sh
#Work Path: CMEECourseWork/Week1/Code
#Input: A file in Data/
#Function: Count how many lines the input file has
#Output: The number of lines the input file has
#Usage: bash CountLines.sh [file]
#Date: Oct 2020

if [ -e ../Data/$1 ]; #Check whether input exists in Data/
    then
        NumLines=$(wc -l < ../Data/$1) #Count how many lines input has
        echo "The file $1 has $NumLines lines"
    else
        echo "The file $1 does not exist in Data/"
fi
echo "Done"
