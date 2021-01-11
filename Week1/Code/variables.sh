#!/bin/bash
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: variables.sh
#Work Path: CMEECourseWork/Week1/Code
#Usage: bash variable.sh
#Date: Oct 2020


#Input: A string
MyVar="some string" #Defining variable
echo "The current value of the variable is $MyVar"
echo "Please enter a new string"
read MyVar #Define a variable through terminal input
if [ -z "$MyVar" ]; #Checking if the length of MyVar is 0
    then
        echo "You have not input any string."
    else
        echo "The current value of the variable is $MyVar"
fi

#Input two numbers and output their sum
echo "Enter two numbers separated by space."
read a b #Input variables through terminal
if echo "$a" | grep -qE '^[0-9,\.,-,]+$'; #Check if the first input is a number 
    then
        if echo "$b" | grep -qE '^[0-9,\.,-]+$'; #Check if the second input is a number
            then
                echo "You entered $a and $b. Their sum is"
                sum=$(echo $a + $b | bc)
                echo $sum
            else
                echo "The second input is not provided or is not a number"
        fi
    else
        echo "The first input is not provided or is not a number"
fi

echo "Done"
