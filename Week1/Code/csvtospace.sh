#!/bin/bash
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: csvtospace.sh
#Work Path: CMEECourseWork/Week1/Code
#Input: A comma-separated-values file in Data/
#Function: Convert input file to a space-separated-values(ssv) file
#Output: A space-separated-values file in Results/
#Usage: bash csvtospace.sh [file]
#Date: Oct 2020

if [ -z $1 ]; #Check whether input is provided
    then
        echo "You have not input any file"
    else
        if [ -e ../Data/$1 ]; #Check whether input is in Data/
            then
                echo "Creating a space delomited version of $1 ..."
                cat ../Data/$1 | tr -s "," " " >> ../Results/$1.ssv #Convert comma to space
                echo "Done!"
            else
                echo "$1 is not in Data/"
        fi
fi
