#!/bin/bash
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: variables.sh
#Work Path: CMEECourseWork/Week1
#Usage: bash variable.sh
#Date: Oct 2020


#Input: A string
MyVar="some string" #Defining variable
echo "The current value of the variable is $MyVar"
echo "Please enter a new string"
read MyVar
if [ -z "$MyVar" ]; #Checking if the length of MyVar is 0
    then
        echo "You have not input any string."
    else
        echo "The current value of the variable is $MyVar"
fi

#Input two numbers and output their sum
echo "Enter two numbers separated by space."
read a b #Inputting variables
if echo "$a" | grep -qE '^[0-9,\.,-,]+$'; 
    then
        if echo "$b" | grep -qE '^[0-9,\.,-]+$';
            then
                echo "You entered $a and $b. Their sum is"
                sum=$(echo $a + $b | bc)
                echo $sum
            else
                echo "$b is not a number"
        fi
    else
        echo "$a is not a number"
fi

echo "Done"
