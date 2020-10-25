#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: basic_io.R
#Work Path: CMEECourseWork/Week3
#Input: Data/trees.csv
#Function: Illustrate R input-output 
#Output: Results/MyData.csv
#Usage: Rscript basic_io.R
#Date: Oct, 2020

MyData <- read.csv("Data/trees.csv", header = TRUE) # import with headers

write.csv(MyData, "Results/MyData.csv") #write it out as a new file

write.table(MyData[1,], file = "Results/MyData.csv",append=TRUE) # Append to it

write.csv(MyData, "Results/MyData.csv", row.names=TRUE) # write row names

write.table(MyData, "Results/MyData.csv", col.names=FALSE) # ignore column names
