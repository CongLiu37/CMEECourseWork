#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: DataWrang.R
#Work Path: CMEECourseWork/Week3/Code
#Dependency: tidyverse
#Input: Data/PoundHillData.csv
#       Data/PoundHillMetaData.csv
#Function: Data wrangling using tidyverse package
#Output:
#Usage: Rscript DataWranTidy.R
#Date: Oct, 2020

rm(list = ls())
library(tidyverse)

############# Load the dataset ###############
# header = false because the raw data don't have real headers
MyData = readr::read_csv("../Data/PoundHillData.csv",col_names = F)
MyData = as_tibble(MyData)
# header = true because we do have metadata headers
MyMetaData = readr::read_csv("../Data/PoundHillMetaData.csv")
MyMetaData = as_tibble(MyMetaData)
############# Inspect the dataset ###############
head(MyData)
dim(MyData)
str(MyData)
fix(MyData) #you can also do this
fix(MyMetaData)

############# Transpose ###############
# To get those species into columns and treatments into rows 
MyData <- as_tibble(t(as.data.frame(MyData))) 
head(MyData)
dim(MyData)

############# Replace species absences with zeros ###############
MyData = as.data.frame(MyData)
MyData[is.na(MyData)] = 0

############# Convert raw matrix to data frame ###############
TempData <- MyData[-1,] #stringsAsFactors = F is important!
colnames(TempData) <- MyData[1,] # assign column names from original data

MyWrangledData = gather(TempData, 
                        key = "species", 
                        value = "count",
                        -"Cultivation", -"Block", -"Plot", -"Quadrat")

MyWrangledData[, "Cultivation"] <- as.factor(MyWrangledData[, "Cultivation"])
MyWrangledData[, "Block"] <- as.factor(MyWrangledData[, "Block"])
MyWrangledData[, "Plot"] <- as.factor(MyWrangledData[, "Plot"])
MyWrangledData[, "Quadrat"] <- as.factor(MyWrangledData[, "Quadrat"])
MyWrangledData[, "Count"] <- as.integer(MyWrangledData[, "count"])

str(MyWrangledData)
head(MyWrangledData)
dim(MyWrangledData)

tidyverse_packages(include_self = TRUE) # the include_self = TRUE means list "tidyverse" as well 
tibble::as_tibble(MyWrangledData)
dplyr::glimpse(MyWrangledData) #like str(), but nicer!
dplyr::filter(MyWrangledData, Count>100) #like subset(), but nicer!
dplyr::slice(MyWrangledData, 10:15) # Look at an arbitrary set of data rows
