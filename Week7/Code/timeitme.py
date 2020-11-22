"""Language: Python3
   Author: Cong Liu (cong.liu20@imperial.ac.uk)
   Script: timeitme.py
   Work Path: CMEECourseWork/Week7/Code
   Dependencies: timeit, time
   Input: Profileme.py
          Profileme2.py
   Function: Another two ways of profiling code.
   Output: 
   Usage: python profileme.py
   Date: Nov, 2020"""

##############################################################################
# loops vs. list comprehensions: which is faster?
##############################################################################

iters = 1000000

import timeit

from profileme import my_squares as my_squares_loops

from profileme2 import my_squares as my_squares_lc

##############################################################################
# loops vs. the join method for strings: which is faster?
##############################################################################

mystring = "my string"

from profileme import my_join as my_join_join

from profileme2 import my_join as my_join

#Print the running time of function in Profileme.py, which uses loops.
import time
start = time.time()
my_squares_loops(iters)
print("my_squares_loops takes %f s to run." % (time.time() - start))

#Print the running time of function in Profileme2.py, which uses vectorization.
start = time.time()
my_squares_lc(iters)
print("my_squares_lc takes %f s to run." % (time.time() - start))
