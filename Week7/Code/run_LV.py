"""Language: Python3
   Author: Cong Liu (cong.liu20@imperial.ac.uk)
   Script: run_LV.py
   Work Path: CMEECourseWork/Week7/Code
   Dependencies: cProfile, pstats
   Input: Code/LV1.py 
          Code/LV2.py
          Code/LV3.py
          Code/LV4.py
   Function: Profile scripts. 
   Output:
   Usage: 
   Date: Nov, 2020"""

import cProfile
import pstats

p1 = cProfile.Profile()
p1.enable()
import LV1
p1.disable()
pr1 = pstats.Stats(p1)
pr1.sort_stats("cumulative").print_stats(20)

p2 = cProfile.Profile()
p2.enable()
import LV2
p2.disable()
pr2 = pstats.Stats(p2)
pr2.sort_stats("cumulative").print_stats(20)