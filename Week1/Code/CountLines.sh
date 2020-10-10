#!/bin/bash
#Running in CMEECourseWork/Week1
#Input: A file in Data/
#Output: The number of lines the input file has
if [ -e Data/$1 ];
    then
        NumLines=$(wc -l < Data/$1)
        echo "The file $1 has $NumLines lines"
    else
        echo "The file $1 is not in Data/"
fi
echo "Done"
