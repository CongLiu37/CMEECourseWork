"""Language: Python3
   Auther: Cong Liu (cong.liu20@imperial.ac.uk)
   Script: basic_io2.py
   Work Path: CMEECourseWork/Week2/Code
   Input file: 
   Function: Write 0-99 in output file
             One number in each line.
   Output: Sandbox/testout.txt
   Usage: python basic_io2.py
   Date: Oct, 2020"""

#############################
# FILE OUTPUT
#############################
# Save the elements of a list to a file
list_to_save = range(100)

f = open('../Sandbox/testout.txt','w')
for i in list_to_save:
    f.write(str(i) + '\n') ## Add a new line at the end

f.close()
