"""Language: Python3
   Auther: Cong Liu (cong.liu20@imperial.ac.uk)
   Script: sysargv.py
   Work Path: CMEECourseWork/Week2/Code
   Dependencies: sys
   Function: Exemplify use of sys and argv
   Usage: python sysargv.py
   Date: Oct, 2020"""

import sys
print("This is the name of the script: ", sys.argv[0])
print("Number of arguments: ", len(sys.argv))
print("The arguments are: " , str(sys.argv))
