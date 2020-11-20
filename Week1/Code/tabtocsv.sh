#!/bin/bash
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: tabtocsv.sh
#Work Path: CMEECourseWork/Week1/Code
#Input: A file in Data/
#Function: Substitute the tabs in input files with commas
#Output: Saved as a csv file in Results/
#Usage: bash tabtocsv.sh [file]
#Date: Oct 2020

if [ -z $1 ];
    then
        echo "You have not input any file"
    else
        if [ -e ../Data/$1 ];
            then
                File=../Data/$1
                echo "Creating a comma delomited version of $1 ..."
                cat $File | tr -s "\t" "," >> ../Results/$1.csv
                echo "Done!"
            else
                echo "$1 is not in Data/"
        fi
fi
