"""Language: Python3
   Auther: Cong Liu (cong.liu20@imperial.ac.uk)
   Script: run_MiniProject.py
   Work Path: CMEECourseWork/MiniProject/Code
   Dependency: os
   Input: 
   Function: Run all scripts of miniproject.
   Output:
   Usage: python run_MiniProject.py
   Date: Nov, 2020"""

import os

#os.system("Rscript data_filter.R")

#Model fitting
#os.system("Rscript quadratic_polynomial_model.R")
#os.system("Rscript cubic_polynomial_model.R")
#os.system("Rscript Briere_model.R")
#os.system("Rscript Ratkowsky_model.R")

#Select Briere models and Ratkowsky models with lowest AIC or BIC of each curve.
#os.system("Rscript ModelQC.R")

#Plot all plausible models
os.system("Rscript PlotValidModels.R")

#Choose best fitting models of each curve,
#using either AIC or BIC as criteria
#os.system("Rscript BestModel.R")

#os.system("Rscript StatisticsResults.R")

#Plot best model or models of each curve
os.system("Rscript PlotBestModels.R")





