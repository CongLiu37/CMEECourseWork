#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: DataWrang.R
#Work Path: CMEECourseWork/Week3/Code
#Dependency: reshape2, tidyverse
#Input: Data/PoundHillData.csv
#       Data/PoundHillMetaData.csv
#Function: Data wrangling using reshape2 packae
#Output:
#Usage: Rscript DataWrang.R
#Date: Oct, 2020

################################################################
################## Wrangling the Pound Hill Dataset ############
################################################################
rm(list = ls())
############# Load the dataset ###############
# header = false because the raw data don't have real headers
MyData <- as.matrix(read.csv("../Data/PoundHillData.csv", header = FALSE))

# header = true because we do have metadata headers
MyMetaData <- read.csv("../Data/PoundHillMetaData.csv", header = TRUE, sep = ";")

############# Inspect the dataset ###############
head(MyData)
dim(MyData)
str(MyData)
fix(MyData) #you can also do this
fix(MyMetaData)

############# Transpose ###############
# To get those species into columns and treatments into rows 
MyData <- t(MyData) 
head(MyData)
dim(MyData)

############# Replace species absences with zeros ###############
MyData[MyData == ""] = 0

############# Convert raw matrix to data frame ###############

TempData <- as.data.frame(MyData[-1,],stringsAsFactors = F) #stringsAsFactors = F is important!
colnames(TempData) <- MyData[1,] # assign column names from original data

############# Convert from wide to long format  ###############
require(reshape2) # load the reshape2 package

?melt #check out the melt function

MyWrangledData <- melt(TempData, id=c("Cultivation", "Block", "Plot", "Quadrat"), variable.name = "Species", value.name = "Count")

MyWrangledData[, "Cultivation"] <- as.factor(MyWrangledData[, "Cultivation"])
MyWrangledData[, "Block"] <- as.factor(MyWrangledData[, "Block"])
MyWrangledData[, "Plot"] <- as.factor(MyWrangledData[, "Plot"])
MyWrangledData[, "Quadrat"] <- as.factor(MyWrangledData[, "Quadrat"])
MyWrangledData[, "Count"] <- as.integer(MyWrangledData[, "Count"])

str(MyWrangledData)
head(MyWrangledData)
dim(MyWrangledData)

############# Exploring the data (extend the script below)  ###############

require(tidyverse)
tidyverse_packages(include_self = TRUE) # the include_self = TRUE means list "tidyverse" as well 
tibble::as_tibble(MyWrangledData)
dplyr::glimpse(MyWrangledData) #like str(), but nicer!
dplyr::filter(MyWrangledData, Count>100) #like subset(), but nicer!
dplyr::slice(MyWrangledData, 10:15) # Look at an arbitrary set of data rows
