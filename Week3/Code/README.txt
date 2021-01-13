Project: Code
Description: Scripts of week 3
Languages: R 4.0, Python3, shell, LaTeX
Dependencies: R packages including reshape2, tidyverse, ggplot2, maps, scales, broom, sqldf
Auther: Cong Liu (cong.liu20@imperial.ac.uk)

Individual work

(1) apply1.R
#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/Week3/Code
#Function: Exemplify the usage of *apply functions
#Usage: Rscript apply1.R
#Date: Oct, 2020

(2) apply2.R
#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/Week3/Code
#Function: Exemplify the usage of *apply functions
#Usage: Rscript apply2.R
#Date: Oct, 2020

(3) basic_io.R
#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/Week3/Code
#Input: Data/trees.csv
#Function: Illustrate R input/output 
#Output: Results/MyData.csv
#Usage: Rscript basic_io.R
#Date: Oct, 2020

(4) boilerplate.R
#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/Week3/Code
#Function: An exemple of R function
#Usage: Rscript boilerplate.R
#Date: Oct, 2020

(5) break.R
#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/Week3/Code
#Function: Illustrate breaking out of loops 
#Usage: Rscript break.R
#Date: Oct, 2020

(6) browse.R
#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/Week3/Code
#Function: An exemple of debugging
#Usage: Rscript browse.R
#Date: Oct, 2020

(7) control_flow.R
#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/Week3/Code
#Function: Illustrate R control flow tools 
#Usage: Rscript control_flow.R
#Date: Oct, 2020

(8) DataWrang.R
#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/Week3/Code
#Dependency: reshape2, tidyverse
#Input: Data/PoundHillData.csv
#       Data/PoundHillMetaData.csv
#Function: Data wrangling
#Usage: Rscript DataWrang.R
#Date: Oct, 2020

(9) DataWrang.R
#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/Week3/Code
#Dependency: tidyverse
#Input: Data/PoundHillData.csv
#       Data/PoundHillMetaData.csv
#Function: Data wrangling
#Usage: Rscript DataWranTidy.R
#Date: Oct, 2020

(10) Girko.R
#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/Week3/Code
#Dependency: ggplot2
#Function: Simulate Girko’s circular law.
#Output: Results/Girko.pdf
#Date: Oct, 2020

(11) GPDD_Data.R
#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/Week3/Code
#Dependency: ggplot2, maps
#Input: Data/GPDDFiltered.RData
#Function: Create a world map, 
#          superimposes on the map all the locations 
#          from which there is data in the GPDD dataframe
#Usage: Rscript GPDD.R
#Date: Oct, 2020

(12) MyBars.R
#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/Week3/Code
#Dependency: ggplot2
#Input: Data/Results.txt
#Function: Exemplify annotating a plot
#Output: Results/MyBars.pdf
#Usage: Rscript MyBars.R
#Date: Oct, 2020

(13) next.R
#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/Week3/Code
#Function: Illustrate skipping to next iteration of a loop
#Usage: Rscript next.R
#Date: Oct, 2020

(14) plotLin.R
#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/Week3/Code
#Dependency: ggplot2
#Function: Plot linear regression data
#Output: Results/MyLinReg.pdf
#Usage: Rscript plotLin.R
#Date: Oct, 2020

(15) PP_Dists.R
#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/Week3/Code
#Dependency: ggplot2
#Input: Data/EcolArchives-E089-51-D1.csv
#Function: Plot distributions of predator mass, prey mass, 
#          and the size ratio of prey mass over predator mass 
#          by feeding interaction type, saving as Pred_Subplots.pdf, Results/Prey_Subplots.pdf, Results/SizeRatio_Subplots.pdf
#          Calculate the mean and median log predator mass, prey mass, 
#          and predator-prey size ratio by feeding type, saving in PP_Results.csv
#Output: Results/Pred_Subplots.pdf, 
#        Results/Prey_Subplots.pdf, 
#        Results/SizeRatio_Subplots.pdf
#        Results/PP_Results.csv
#Usage: Rscript PP_Dists.R
#Date: Oct, 2020

(16) PP_Regress.R
#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/Week3/Code
#Dependency: ggplot2, scales, broom
#Input: Data/EcolArchives-E089-51-D1.csv
#Function: Regress prey mass and predator mass for each 
#          Feeding Type+Predator life Stage combination and
#          save results in Results/PP_Regress_Results.csv.
#          For each combination, if it has only two sample poits or 
#          there is no correlation (R-square = 0), it will not be saved in csv file.
#          Plot the regression, saved as Results/PP_Regress_Results.pdf
#Output: Results/PP_Regress_Results.pdf 
#        Results/PP_Regress_Results.csv
#Usage: Rscript PP_Regress.R
#Date: Oct, 2020

(17) preallocate.R
#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/Week3/Code
#Function: Illustrate the effect of pre-allocation in computing efficiency
#Usage: Rscript preallocate.R
#Date: Oct, 2020

(18) R_conditionals.R
#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: R_conditionals.R
#Work Path: CMEECourseWork/Week3/Code
#Function: Examples of functions with conditionals
#Usage: Rscript R_conditionals.R
#Date: Oct, 2020

(19) Ricker.R
#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/Week3/Code
#Function: Simulate Ricker model of population growth
#Output: A figure shows population growth of Ricker model
#Usage: Rscript Ricker.R
#Date: Oct, 2020

(20) sample.R
#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/Week3/Code
#Function: Exemplify vectorization
#Usage: Rscript sample.R
#Date: Oct, 2020

(21) SQLinR.R
#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/Week3/Code
#Dependency: sqldf
#Function: Build, manipulate and access database using SQLite
#Usage: Rscript SQLinR.R
#Date: Oct, 2020

(22) TAutoCorr.R
#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Directory: CMEECourseWork/Week3/Code
#Dependency: ggplot2
#Input: Data/KeyWestAnnualMeanTemperature.RData
#Function: Test autocorrelation of each year's temperature and estimate p-value
#Usage: Rscript TAutoCorr.R
#Date: Oct, 2020

(23) TAutoCOrr.tex
%Language: LaTeX
%Author: Cong Liu (cong.liu20@imperial.ac.uk)
%Work directory: CMEECourseWork/Week3/Code
%Description: Written work of practical "Autocorrelation in weather"

(24) TreeHeight.R
#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/Week3/Code
#Input: Data/trees.csv
#Function: Calculate heights of trees given distance of each tree 
#          from its base and angle to its top, using  the trigonometric formula. Results saves in TreeHts.csv 
#Output: Results/TreeHts.csv
#Usage: Rscript TreeHeight.R
#Date: Oct, 2020

(25) try.R
#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/Week3/Code
#Function: Exemplify the usage of try()
#Usage: Rscript try.R
#Date: Oct, 2020

(26) Vectorize1.R
#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/Week3/Code
#Function: Exemplify vectorization's effect in computing efficiency and 
#          low speed of loops
#Usage: Rscript Vectorize1.R
#Date: Oct, 2020

(27) Vectorize2.R
#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/Week3/Code
#Function: Simulate stochastic Ricker model in vectorized and un-victorized way,
#          and compare their efficiency
#Usage: Rscript Vectorize2.R
#Date: Oct, 2020

Group work

(1) PP_Regress_loc.R
# Author: Group 4
# Script: PP_Regress.R
# Created: Nov 2020
#
# Script draws and saves a pdf of regression analysis using data subsetted by
# the Predator.lifestage field and writes the accompanying regression results to
# a formatted table in csv in the results directory

(2) Vectorize1.py
This script is the translated version of Vectorize1.R

(3) Vectorize2.py
This script is the translated version of Vectorize2.R

(4) compare_Speed.sh
# Author: Group 4
# Script: compare_Speed.sh
# Desc: Script runs Vectorize 1 and 2 in both R and python for speed comparison
# Date: Nov 2020

(5) get_TreeHeight.R
# Author: Group 4
#
# Script: get_TreeHeight.R
#
# Desc: Reads argued .csv file(s) for data frame, adds blank 4th column, uses
#       columns 2 & 3 to calculate tree heights to populate 4th column, then
#       writes new dataframe into a new .csv file
#
# Arguments:
# .csv file(s) with second header "Distance.m" and third header "Angle.degrees", 
# or none to use default.
#
# Output:
# ../results/[argument basename]_treeheights.csv
#
# Date: 27 Oct 2020

(6) get_TreeHeight.py
This script is the translated version of get_TreeHeight.R

(7) run_get_TreeHeight.sh
# Author: Group 4
# Script: run_get_TreeHeight.sh
# Desc: shell script to run R and python versions of get_TreeHeight
# Arguments: none
# Date: Oct 2020
