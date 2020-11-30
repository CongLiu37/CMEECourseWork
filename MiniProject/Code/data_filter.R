#Language: R 4.0.3
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: data_filter.R
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

rm(list = ls())

data = read.csv("../Data/ThermRespData.csv")

tempData = data.frame()
move = rep(NA,903)

for (i in 1:903){
  d = subset(data, ID == i)
  a = min(d$OriginalTraitValue)
  if (a <= 0){
    d$OriginalTraitValue = d$OriginalTraitValue - a
    move[i] = a
    tempData = rbind(tempData, d)}
  else{
    move[i] = 0
    tempData = rbind(tempData, d)}
}

write.csv(tempData, "../Results/filtered_data.csv", row.names = F)
write.csv(data.frame(ID=c(1:903), minus = move),
          "../Results/move_curves.csv", row.names = F)

