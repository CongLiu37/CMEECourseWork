"""Language: Python3
   Author: Cong Liu (cong.liu20@imperial.ac.uk)
   Script: using_os.py
   Work Path: CMEECourseWork/Week7/Code
   Dependencies: subprocess
   Input: 
   Function: Get a list of files and directories in home/ that start with 'C'.
             Get files and directories in home/ that start with either an upper or lower case 'C'.
             Get only directories in your home/ that start with either an upper or lower case 'C'.
   Output: 
   Usage: python profileme.py
   Date: Nov, 2020"""

# Use the subprocess.os module to get a list of files and directories 
# in your ubuntu home directory 

# Hint: look in subprocess.os and/or subprocess.os.path and/or 
# subprocess.os.walk for helpful functions

import subprocess
#################################
#~Get a list of files and 
#~directories in your home/ that start with an uppercase 'C'

# Type your code here:

# Get the user's home directory.
home = subprocess.os.path.expanduser("~")

# Create a list to store the results.
FilesDirsStartingWithC = []

# Use a for loop to walk through the home directory.
for (root, subdir, files) in subprocess.os.walk(home):
    for names in subdir:
        if names[0] == "C":
            FilesDirsStartingWithC.append(names)
    for n in files:
        if n[0] == "C":
            FilesDirsStartingWithC.append(n)
print(FilesDirsStartingWithC)
#################################
# Get files and directories in your home/ that start with either an 
# upper or lower case 'C'

# Type your code here:
FilesDirsStartingWithCc = []

for (root, subdir, files) in subprocess.os.walk(home):
    for i in subdir:
        if i[0] in ["C","c"]:
            FilesDirsStartingWithCc.append(i)

    for j in files:
        if j[0] in ["C","c"]:
            FilesDirsStartingWithCc.append(j)

#################################
# Get only directories in your home/ that start with either an upper or 
#~lower case 'C' 

# Type your code here:
DirsStartingWithCc = []

for (root, subdir, files) in subprocess.os.walk(home):
    for i in subdir:
        if i[0] in ["C","c"]:
            DirsStartingWithCc.append(i)

