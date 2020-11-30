#Language: R 4.0.3
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: cubic_polynomial_model.R
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

rm(list = ls())

data = read.csv("../Results/filtered_data.csv")

name = c("SampleSize","AIC","BIC",
         "B0","std.error_B0","t_B0","p_B0",
         "B1","std.error_B1","t_B1","p_B1",
         "B2","std.error_B2","t_B2","p_B2",
         "B3","std.error_B3","t_B3","p_B3",
         "ID")

cub = data.frame(Value_name = name)

for (i in 1:903){
  d = subset(data, ID == i)
  
  mol = lm(data = d,
           d$OriginalTraitValue ~ poly(ConTemp,3,raw = T))
  report = rep(NA,20)
  #Sample size
  report[1] = nrow(d)
  #AIC, BIC
  report[2] = AIC(mol) #The smaller, better fitting
  report[3] = BIC(mol) #The smaller, better fitting
  #B0
  report[4] = coef(summary(mol))["(Intercept)",1]
  report[5] = coef(summary(mol))["(Intercept)",2]
  report[6] = coef(summary(mol))["(Intercept)",3]
  report[7] = coef(summary(mol))["(Intercept)",4] #H0: B0 = 0
  #Tm
  report[8] = coef(summary(mol))["poly(ConTemp, 3, raw = T)1",1]
  report[9] = coef(summary(mol))["poly(ConTemp, 3, raw = T)1",2]
  report[10] = coef(summary(mol))["poly(ConTemp, 3, raw = T)1",3]
  report[11] = coef(summary(mol))["poly(ConTemp, 3, raw = T)1",4] #H0: B1 = 0
  #a
  report[12] = coef(summary(mol))["poly(ConTemp, 3, raw = T)2",1]
  report[13] = coef(summary(mol))["poly(ConTemp, 3, raw = T)2",2]
  report[14] = coef(summary(mol))["poly(ConTemp, 3, raw = T)2",3]
  report[15] = coef(summary(mol))["poly(ConTemp, 3, raw = T)2",4] #H0: B2 = 0
  
  report[16] = coef(summary(mol))["poly(ConTemp, 3, raw = T)3",1]
  report[17] = coef(summary(mol))["poly(ConTemp, 3, raw = T)3",2]
  report[18] = coef(summary(mol))["poly(ConTemp, 3, raw = T)3",3]
  report[19] = coef(summary(mol))["poly(ConTemp, 3, raw = T)3",4]
  #ID
  report[20] = i
  
  cub = cbind(cub,report)
}

labels = c("ID",cub[20,][-1])
colnames(cub) = labels
cub = cub[-20,]
cub = t(cub)

write.csv(cub, 
          "../Results/cubic_polynomial_model.csv", 
          row.names = T)
