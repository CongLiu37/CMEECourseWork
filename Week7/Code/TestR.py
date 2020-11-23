"""Language: python3
   Author: Cong Liu (cong.liu20@imperial.ac.uk)
   Work Path: CMEECourseWork/Week7/Code
   Dependencies:
   Input: TestR.R
   Function: Examplify how to run R script by python
   Output:
   Usage: python TestR.py
   Date: Nov, 2020"""

import subprocess
subprocess.Popen("Rscript --verbose TestR.R > ../Results/TestR.Rout 2> ../Results/TestR_errFile.Rout", shell=True).wait()
subprocess.Popen("Rscript --verbose NonExistScript.R > ../Results/outputFile.Rout 2> ../Results/errorFile.Rout", shell=True).wait()