"""Language: Python3
   Auther: Cong Liu (cong.liu20@imperial.ac.uk)
   Script: test_control_flow.py
   Work Path: CMEECourseWork/Week2/Code
   Dependencies: sys, doctest
   Function: Exemplify the use of control statement
   Usage: python test_control_flow.py
   Date: Oct, 2020"""

#Docstring
__author__ = 'Your Name (Your.Name@your.email.address)'
__version__ = '0.0.1'

import sys
import doctest # Import the doctest module

def even_or_odd(x=0):
    """Find whether a number x is even or odd.
      
    >>> even_or_odd(10)
    '10 is Even!'
    
    >>> even_or_odd(5)
    '5 is Odd!'
    
    whenever a float is provided, then the closest integer is used:    
    >>> even_or_odd(3.2)
    '3 is Odd!'
    
    in case of negative numbers, the positive is taken:    
    >>> even_or_odd(-2)
    '-2 is Even!'
    
    """
    #Define function to be tested
    if x % 2 == 0:
        return "%d is Even!" % x
    return "%d is Odd!" % x


def main(argv): 
    """Test functions above"""
    print(even_or_odd(22))
    print(even_or_odd(33))
    return 0

if (__name__ == "__main__"):
    status = main(sys.argv)

    
doctest.testmod()   # To run with embedded tests
