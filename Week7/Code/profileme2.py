"""Language: Python3
   Author: Cong Liu (cong.liu20@imperial.ac.uk)
   Script: profileme2.py
   Work Path: CMEECourseWork/Week7/Code
   Dependencies:
   Input:
   Function: A more efficient version of Code/profileme.py
   Output: 
   Usage: python -m cProfile profileme2.py
   Date: Nov, 2020"""

def my_squares(iters):
    """Cauculate square of inputs in a vectorizated way"""
    out = [i ** 2 for i in range(iters)]
    return out

def my_join(iters, string):
    """Generate a new string 
    by repeating an input string multiple times and separate them by comma.
    It works in a vectorized way."""
    out = ''
    for i in range(iters):
        out += ", " + string
    return out

def run_my_funcs(x,y):
    """Run functions my_square and my_joint"""
    print(x,y)
    my_squares(x)
    my_join(x,y)
    return 0

run_my_funcs(10000000,"My string")