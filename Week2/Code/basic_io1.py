"""Language: Python3
   Auther: Cong Liu (cong.liu20@imperial.ac.uk)
   Script: basic_io1.py
   Work Path: CMEECourseWork/Week2
   Input file: Sandbox/test.txt
   Function: Print all lines of input file
             Print all lines that contains letters in input file
   Output:
   Usage: python basic_io1.py
   Date: Oct, 2020"""

#############################
# FILE INPUT
#############################
# Open a file for reading
f = open('./Sandbox/test.txt', 'r')
# use "implicit" for loop:
# if the object is a file, python will cycle over lines
for line in f:
    print(line)

# close the file
f.close()

# Same example, skip blank lines
f = open('./Sandbox/test.txt', 'r')
for line in f:
    if len(line.strip()) > 0:
        print(line)

f.close()
