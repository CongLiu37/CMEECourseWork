#!/bin/bash
#Auther: cong.liu20@imperial.ac.uk
#Script: tiff2png.sh
#Running: In CMEECourseWork/Week1
#Input: A directory contains tif format pictures
#Function: Convert all tif format pictures in the input directory into png format
#Output: Saved as jpg format in Results/
#Usage: bash tiff2png.sh [directory]
#Date: Oct 2020

if [ -z $1 ];
    then 
        echo "You have not input any directory"
    else
        if [ -e $1 ];
            then
                for f in "$1/"*.tif; 
                    do  
                        echo "Converting $f"; 
                        convert "$f"  "Results/$(basename "$f" .tif).png";
                    done
            else
                echo "The directory does not exist"
        fi
fi
echo "Done!"
