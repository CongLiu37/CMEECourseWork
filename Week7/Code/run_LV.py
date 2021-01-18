"""Language: Python3
   Author: Cong Liu (cong.liu20@imperial.ac.uk)
   Script: run_LV.py
   Work Path: CMEECourseWork/Week7/Code
   Dependencies: cProfile, pstats
   Input: Code/LV1.py 
          Code/LV2.py
          Code/LV3.py
          Code/LV4.py
   Function: Profile input scripts. 
   Output:
   Usage: 
   Date: Nov, 2020"""

import cProfile
import pstats

#Profile LV1.py
p1 = cProfile.Profile()
p1.enable()
import LV1 #Run LV1.py
p1.disable()
pr1 = pstats.Stats(p1)
pr1.sort_stats("cumulative").print_stats(20)

#Profile LV2.py
p2 = cProfile.Profile()
p2.enable()
import LV2 #Run LV2.py
p2.disable()
pr2 = pstats.Stats(p2)
pr2.sort_stats("cumulative").print_stats(20)

#Profile LV3.py
p3 = cProfile.Profile()
p3.enable()
import LV3 
LV3.main()#Run LV3.py
p3.disable()
pr3 = pstats.Stats(p3)
pr3.sort_stats("cumulative").print_stats(20)

#Profile LV4.py
p4 = cProfile.Profile()
p4.enable()
import LV4
LV4.main()#Run LV4.py
p4.disable()
pr4 = pstats.Stats(p4)
pr4.sort_stats("cumulative").print_stats(20)