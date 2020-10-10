#!/bin/bash
#Running in CMEECourseWork/Week1
#Input: two files in Data/
#Output: Merged file of inputs, saved as Results/Merged

if [ -e Data/$1 ];
    then
        if [ -e Data/$2 ];
            then 
                file1=Data/$1
                file2=Data/$2
                file3=Results/Merged
                cat $file1 >> $file3
                cat $file2 >> $file3
                echo "The merged file is"
                cat $file3
            else
                echo "$2 does not exist in Data/"
        fi
    else
        echo "$1 does not exist in Data/"
fi
            
echo "Done"
