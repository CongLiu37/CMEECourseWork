"""Language: Python3
   Auther: Cong Liu (cong.liu20@imperial.ac.uk)
   Script: debugme.py
   Work Path: CMEECourseWork/Week2
   Input file:
   Function: Exemplify the process of debugging
   Output:
   Usage:
   Date: Oct, 2020"""

def makeabug(x):
    y = x**4
    #z = 0.
    z = 1
    y = y/z
    print(y)
    return y

makeabug(25)
