#!/bin/bash
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: ConcatenateTwoFiles.sh
#Work Path: CMEECourseWork/Week1/Code
#Input: Two files saved in Data/
#Function: Merge input files
#Output: Merged file of inputs, saved as Results/Merged
#Usage: bash ConcatenateTwoFiles.sh [file1] [file2]
#Date: Oct 2020

if [ -z $1 ];
    then
        echo "Two files should be inputted"
    else
        if [ -z $2 ];
            then
                echo "Only one file is inoutted"
                echo "Two files should be inputted" #Check whether inputs are provided
            else
                if [ -e ../Data/$1 ];
                    then
                        if [ -e ../Data/$2 ]; #Check whether inputs are in ../Data
                            then 
                                file1=../Data/$1
                                file2=../Data/$2
                                file3=../Results/Merged
                                cat $file1 >> $file3
                                cat $file2 >> $file3 #Merge input files
                                echo "The merged file is"
                                cat $file3
                            else
                                echo "$2 does not exist in Data/"
                        fi
                    else
                        echo "$1 does not exist in Data/"
                fi
        fi
fi

echo "Done"
