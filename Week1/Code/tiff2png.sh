#!/bin/bash
#Running in CMEECourseWork/Week1
#Input: A directory contains tif format files
#Output: jpg format of tif files in input directory, stored in Results/ 

if [ -z $1 ];
    then 
        echo "You have not input any directory"
    else
        if [ -e $1 ];
            then
                for f in "$1/"*.tif; 
                    do  
                        echo "Converting $f"; 
                        convert "$f"  "Results/$(basename "$f" .tif).jpg";
                    done
            else
                echo "The directory does not exist"
        fi
fi
echo "Done!"
