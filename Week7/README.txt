BASIC DESCRIPTION:
Project: Week7
Description: Course work of week 7
Language: Python3, R 4.0.3
Dependencies: numpy, scipy.integrate, matplotlib.pylab, sys, cProfile, re, timeit,
              time, subprocess
Auther: Cong Liu (cong.liu20@imperial.ac.uk)

SCRIPTS
(1) LV1.py
Language: Python3
Author: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/Week7/Code
Dependencies: numpy, scipy.integrate, matplotlib.pylab, sys
Input: 
Function: Simulate Lotka-Volterra model for a predator-prey system 
          and visualize results in two ways. 
Output: ../Results/LV1_1.pdf
        ../Results/LV1_2.pdf
Usage: python LV1.py
Date: Nov, 2020

(2) LV2.py
Language: Python3
Author: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/Week7/Code
Dependencies: sys, numpy, scipy.integrate, matplotlib.pylab
Input: 
Function: Simulate Lotka-Volterra model with prey density dependence 
          and visualize results in two ways. Parameters should be provided by user.
          If no parameter is provided, following default values will be used:
          r = 1
          a = 0.1
          z = 1.5
          e = 0.75
          K =  1,000,000
          The final densities of resource and consumer are printed.
Output: ../Results/LV.pdf
        ../Results/LV1.pdf
Usage: python LV2.py [r] [a] [z] [e] [K]
Date: Nov, 2020

(3) profileme.py
Language: Python3
Author: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/Week7/Code
Dependencies:
Input:
Function: An example of profiling code.
Output: 
Usage: python profileme.py
Date: Nov, 2020

(4) profileme2.py
Language: Python3
Author: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/Week7/Code
Dependencies:
Input:
Function: A more efficient version of Code/profileme.py
Output: 
Usage: python profileme2.py
Date: Nov, 2020

(5) re.py
Language: Python3
Author: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/Week7/Code
Dependencies: re
Input:
Function: Extract email address by regular express
Output: 
Usage: python re.py
Date: Nov, 2020

(6)run_fmr_R.py
Language: Python3
Auther: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/Week7/Code
Dependency: subprocess
Input: fmr.R
Function: Run fmr.R
Output: ../Results/fmr_plot.pdf
Usage: python run_fmr_R.py
Date: Nov, 2020

(7) run_LV.py
Language: Python3
Author: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/Week7/Code
Dependencies: cProfile, pstats
Input: ../Code/LV1.py 
       ../Code/LV2.py
Function: Profile input scripts. 
Output:
Usage: 
Date: Nov, 2020

(8) regexs.py
Language: Python3
Author: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/Week7/Code
Dependencies: re
Input:
Function: Examplify the usage of regular express.
Output: 
Usage: python regexs.py
Date: Nov, 2020

(9) timeitme.py
Language: Python3
Author: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/Week7/Code
Dependencies: timeit, time
Input: Profileme.py
       Profileme2.py
Function: Another two ways of profiling code.
Output: 
Usage: python profileme.py
Date: Nov, 2020

(10) using_os.py
Language: Python3
Author: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/Week7/Code
Dependencies: subprocess
Input: 
Function: Get a list of files and directories in home/ that start with 'C'.
          Get files and directories in home/ that start with either an upper or lower case 'C'.
          Get only directories in your home/ that start with either an upper or lower case 'C'.
Output: 
Usage: python profileme.py
Date: Nov, 2020

(11) blackbirds.py
Language: Python3
Author: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/Week7/Code
Dependencies: re
Input: ../Data/blackbirds.txt
Function: Capture the Kingdom, Phylum and Species 
          name for each species and prints it out to screen neatly
Output: 
Usage: python blackbirds.py
Date: Nov, 2020

(12) fmr.R
#Language: R 4.0.3
#Author: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/Week7/Code
#Dependencies:
#Input: ../Data/NagyEtAl1999.csv
#Function: Plots log(field metabolic rate) against log(body mass) for the Nagy et al 
#          1999 dataset to a file fmr.pdf.
#Output: ../Results/fmr_plot.pdf
#Usage: Rscript fmr.R
#Date: Nov, 2020

(13) TestR.py
Language: python3
Author: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/Week7/Code
Dependencies:
Input: TestR.R
Function: Examplify how to run R script by python
Output:
Usage: python TestR.py
Date: Nov, 2020

(14) TestR.R
The input script of TestR.py.
It prints "Hello, this is R!"
