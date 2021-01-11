"""Language: Python3
   Auther: Cong Liu (cong.liu20@imperial.ac.uk)
   Script: cfexercises1.py
   Work Path: CMEECourseWork/Week2/Code
   Dependencies: sys
   Description: Some functions for numberic calculation
   Usage: python cfexercises1.py
   Date: Oct, 2020"""

#Docstring
__author__ = 'Cong Liu (cong.liu20@imperial.ac.uk)'
__version__ = '0.0.1'

import sys

def foo_1(x):
    """Return the square root of input number"""
    return x** 0.5 

def foo_2(x, y):
    """Return the larger one in two input numbers"""
    if x > y:
        return x
    return y        

def foo_3(x, y, z):
    """Sort three input numbers from the smallest to the largest"""
    if x > y:
        tmp = y
        y = x
        x = tmp
    if y > z:
        tmp = z
        z = y
        y = tmp
    return [x, y, z]

def foo_4(x):
    """Calculate x!, where x is the input number"""
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result

def foo_5(x):
    """Input x.
       When x = 1, return 1, otherwise return x * ( x - 1 )"""
    if x == 1:
        return 1
    return x * (x - 1)

def foo_6(x):
    """Calculate the factorial of input number"""
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto

def main(argv):
    """Test functions above"""
    print(foo_1(2))
    print(foo_2(5,9))
    print(foo_3(3,2,9))
    print(foo_4(10))
    print(foo_5(6))
    print(foo_6(6))

if (__name__ == "__main__"):
    status = main(sys.argv)
    sys.exit(status)
