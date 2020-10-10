#!/bin/bash
#Input: A comma-separated-values file in Data/
#Function: Convert input file to a space-separated-values file
#Output: Saved in Results/

if [ -z $1 ];
    then
        echo "You have not input any file"
    else
        if [ -e Data/$1 ];
            then
                echo "Creating a space delomited version of $1 ..."
                cat Data/$1 | tr -s "," " " >> Results/$1.ssv
                echo "Done!"
            else
                echo "$1 is not in Data/"
        fi
fi