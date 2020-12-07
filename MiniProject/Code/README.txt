BASIC DESCRIPTION:
Project: MiniProject
Description: Codes in MoniProject
Language: Python3, R 4.0.3, bash, LaTeX
Dependencies: 
             R packages: minpack.lm, ggplot2, gridExtra, cowplot
             Python modules: os
Auther: Cong Liu (cong.liu20@imperial.ac.uk)

(1) data_filter.R
#Language: R 4.0.3
#Author: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/MiniProject/Code
#Dependency:
#Input: ../Data/ThermRespData.csv
#Function: Rescale curves with negative trait values to make performance positive.
#          These rescaled curves will be used in model fitting and selection, to make 
#          IDs of curves are consecutive integers. They will be removed in further 
#          analysis.
#Output: ../Results/filtered_data.csv
#        ../Results/move_curves.csv
#Usage: Rscript data_filter.R
#Date: Oct, 2020

(2) quadratic_polynomial_model.R
#Language: R 4.0.3
#Author: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/MiniProject/Code
#Dependency:
#Input: ../Results/filtered_data.csv
#Function: Fit each thermal performance curve with quadratic model:
#          B(T) = B0 + B1*T + B2*T^2 
#          where B(T) is trait value under temperature T, 
#          B0, B1, B2 are constants.
#Output: ../Results/quadratic_polynomial_model.csv
#Usage: Rscript quadratic_polynomial_model.R
#Date: Oct, 2020

(3) cubic_polynomial_model.R
#Language: R 4.0.3
#Author: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/MiniProject/Code
#Dependency:
#Input: ../Results/filtered_data.csv
#Function: Fit each thermal performance curve with cubic model:
#          B(T) = B0 + B1*T + B2*T^2 + B3*T^3
#          where B(T) is trait value under temperature T. 
#          B0, B1, B2, B3 are constants.
#Output: ../Results/cubic_polynomial_model.csv
#Usage: Rscript cubic_polynomial_model.R
#Date: Oct, 2020

(4) Briere_model.R
#Language: R 4.0.3
#Author: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/MiniProject/Code
#Dependency: minpack.lm
#Input: ../Results/filtered_data.csv
#Function: Fit each thermal performace curve with Ratkowsky model:
#          B(T) = B0*T*(T-T0)*(Tm-T)^0.5 
#          where B(T) is trait value under temperature T. 
#          T0, Tm, B0 are constants
#Output: ../Results/Briere_model.csv
#Usage: Rscript Briere_model.R
#Date: Oct, 2020

(5) Ratkowsky_model.R
#Language: R 4.0.3
#Author: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/MiniProject/Code
#Depemdency: minpack.lm
#Input: ../Results/filtered_data.csv
#Function: Fit each thermal performace curve with Ratkowsky model:
#          B(T)^0.5 = a * (t - T0) * (1 - exp(b * (t - Tm)))
#          where B(T) is trait value under temperature T. 
#          T0, Tm, a, b are constants.
#Output: ../Results/Ratkowsky_model.csv
#Usage: Rscript Ratkowsky_model.R
#Date: Oct, 2020

(6) ModelQC.R
#Language: R 4.0.3
#Author: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/MiniProject/Code
#Dependency: 
#Input: ../Results/quadratic_polynomial_model.csv
#       ../Results/cubic_polynomial_model.csv
#       ../Results/Briere_model.csv
#       ../Results/Ratkowsky_model.csv
#Function: (1) For each curve, select combinations of parameters of Briere model
#              that lead to lowest AIC or BIC and average them.
#          (2) For each curve, select combinations of parameters of Ratkowsky model
#              that lead to lowest AIC or BIC and average them.
#          (3) Extract parameter values of all models.
#Output: ../Results/quadratic_valid.csv
#        ../Results/cubic_valid.csv
#        ../Results/Briere_AIC.csv
#        ../Results/Briere_BIC.csv
#        ../Results/Ratkowsky_AIC.csv
#        ../Results/Ratkowsky_BIC.csv
#Usage: Rscript ModelQC.R
#Date: Nov, 2020

(7) PlotValidModels.R
#Language: R 4.0.3
#Author: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/MiniProject/Code
#Dependency: ggplot2
#Input: ../Results/quadratic_valid.csv
#       ../Results/cubic_valid.csv
#       ../Results/Briere_AIC.csv
#       ../Results/Briere_BIC.csv
#       ../Results/Ratkowsky_AIC.csv
#       ../Results/Ratkowsky_BIC.csv
#       ../Results/filtered_data.csv
#Function: Visualize four plausible models of each curve
#Output: ../Results/AIC_models.pdf
#        ../Results/BIC_models.pdf
#Usage: Rscript PlotValidModels.R
#Date: Nov, 2020

(8) BestModel.R
#Language: R 4.0.3
#Author: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/MiniProject/Code
#Dependency: 
#Input: ../Results/quadratic_valid.csv
#       ../Results/cubic_valid.csv
#       ../Results/Briere_AIC.csv
#       ../Results/Briere_BIC.csv
#       ../Results/Ratkowsky_AIC.csv
#       ../Results/Ratkowsky_BIC.csv
#Function: For each curve, select best-fitting models from 
#          quadratic, cubic, Briere and Ratkowsky models, 
#          using either AIC or BIC as criteria.
#Output: ../Results/bestAIC_quadratic.csv
#        ../Results/bestBIC_quadratic.csv
#        ../Results/bestAIC_cubic.csv
#        ../Results/bestBIC_cubic.csv
#        ../Results/bestAIC_Briere.csv
#        ../Results/bestBIC_Briere.csv
#        ../Results/bestAIC_Ratkowsky.csv
#        ../Results/bestBIC_Ratkowsky.csv
#Usage: Rscript BestModel.R
#Date: Nov, 2020

(9) PlotBestModels.R
#Language: R 4.0.3
#Author: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/MiniProject/Code
#Dependency: ggplot2 
#Input:  ../Results/bestAIC_quadratic.csv
#        ../Results/bestBIC_quadratic.csv
#        ../Results/bestAIC_cubic.csv
#        ../Results/bestBIC_cubic.csv
#        ../Results/bestAIC_Briere.csv
#        ../Results/bestBIC_Briere.csv
#        ../Results/bestAIC_Ratkowsky.csv
#        ../Results/bestBIC_Ratkowsky.csv
#        ../Results/filtered_data.csv
#Function: Plot best model of each curve when AIC or BIC is used for
#          model selection.
#Output: ../Results/AIC_bestmodels.pdf
#        ../Results/BIC_bestmodels.pdf
#Usage: Rscript PlotBestModels.R
#Date: Nov, 2020

(10) StatisticsResults.R
#Language: R 4.0.3
#Author: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/MiniProject/Code
#Dependency:
#Input: ../Results/move_curves.csv
#       ../Results/Briere_model.csv
#       ../Results/Ratkowsky_model.csv
#       ../Results/bestAIC_quadratic.csv
#       ../Results/bestAIC_cubic.csv
#       ../Results/bestAIC_Briere.csv
#       ../Results/bestAIC_Ratkowsky.csv
#       ../Results/bestBIC_quadratic.csv
#       ../Results/bestBIC_cubic.csv
#       ../Results/bestBIC_Briere.csv
#       ../Results/bestBIC_Ratkowsky.csv
#Function: Basic summary of the results of model fitting and selection.
#Output: 
#Usage: Rscript StatisticsResults.R
#Date: Nov, 2020

(11) FiguresInReport.R
#Language: R 4.0.3
#Author: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/MiniProject/Code
#Dependency: ggplot2, gridExtra, cowplot 
#Input:  ../Results/bestAIC_quadratic.csv
#        ../Results/bestBIC_quadratic.csv
#        ../Results/bestAIC_cubic.csv
#        ../Results/bestBIC_cubic.csv
#        ../Results/bestAIC_Briere.csv
#        ../Results/bestBIC_Briere.csv
#        ../Results/bestAIC_Ratkowsky.csv
#        ../Results/bestBIC_Ratkowsky.csv
#        ../Results/filtered_data.csv
#        ../Results/move_curves.csv
#        ../Results/quadratic_valid.csv
#        ../Results/cubic_valid.csv
#        ../Results/Briere_AIC.csv
#        ../Results/Briere_BIC.csv
#        ../Results/Ratkowsky_AIC.csv
#        ../Results/Ratkowsky_BIC.csv
#Function: Plot figures in report.
#Output: ../Results/Figure1.pdf
         ../Results/Figure2.pdf
         ../Results/a.pdf
         ../Results/b.pdf
#Date: Nov, 2020

(12) Report.tex
Language: LaTeX
Author: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/MiniProject/Code
Function: LaTeX source code for the report

(13) References.bib
Author: Cong Liu (cong.liu20@imperial.ac.uk)
Function: References for the report.

(14) CompileLaTeX.sh
#Auther: Cong liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/MiniProject/Code
#Input: .tex and .bib files in Code/
#Function: Compile LaTeX, save .pdf file in Results/ and remove other files
#Output: .pdf file in Results/
#Usage: bash Code/CompileLaTeX.sh [Base name of .tex]
#Date: Nov 2020

(15) run_MiniProject.py
Language: Python3
Auther: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/MiniProject/Code
Dependency: os
Input: 
Function: Run all scripts of miniproject.
Output:
Usage: python run_MiniProject.py
Date: Nov, 2020
