"""Language: Python3
   Author: Cong Liu (cong.liu20@imperial.ac.uk)
   Script: profileme.py
   Work Path: CMEECourseWork/Week7/Code
   Dependencies:
   Input:
   Function: An example of profiling code.
   Output: 
   Usage: python profileme.py
   Date: Nov, 2020"""

def my_squares(iters):
    """Cauculate square of inputs using loops"""
    out = []
    for i in range(iters):
        out.append(i ** 2)
    return out

def my_join(iters, string):
    """Generate a new string 
    by repeating an input string multiple times and separate them by comma.
    It works using loops."""
    out = ''
    for i in range(iters):
        out += string.join(", ")
    return out

def run_my_funcs(x,y):
    """Run functions my_square and my_joint"""
    print(x,y)
    my_squares(x)
    my_join(x,y)
    return 0

run_my_funcs(10000000,"My string")
print(my_join(100,'my string'))
