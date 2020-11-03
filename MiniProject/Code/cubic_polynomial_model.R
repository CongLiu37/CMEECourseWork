#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: cubic_polynomial_model.R
#Work Path: CMEECourseWork/MiniProject
#Depemdency:
#Input: Data/ThermRespData.csv
#Function: Fit each thermal performace curve with cubic model:
#          B(T) = (B0) + (B1)T + (B2)(T^2) + (B3)(T^3)
#          where B(T) is trait value under temperature T, 
#          parameters are B0, B1, B2, B3.
#Output: Results/cubic_polynomial_model.csv
#Usage: Rscript cubic_polynomial_model.R
#Date: Oct, 2020

rm(list = ls())

data = read.csv("Data/ThermRespData.csv")

name = c("RSS","TSS","RSq","AIC","BIC","SampleSize",
         "B0","std.error_B0","t_B0","p_B0",
         "B1","std.error_B1","t_B1","p_B1",
         "B2","std.error_B2","t_B2","p_B2",
         "B3","std.error_B3","t_B3","p_B3")
Cub = data.frame(Value_name = name)

for (i in 1:903){
  d = subset(data, ID == i)
  mol = lm(data = d,
           OriginalTraitValue ~ poly(ConTemp,3))
  
  report = rep(NA,22)
  
  report[1] = sum(residuals(mol)^2)
  report[2] = sum((d$OriginalTraitValue - mean(d$ConTemp))^2)
  report[3] = 1 - (as.numeric(report[1])/as.numeric(report[2])) # >0.5 indicates good fitting
  
  report[4] = AIC(mol) #The smaller, better fitting
  report[5] = BIC(mol) #The smaller, better fitting
  
  report[6] = nrow(d)
  
  report[7] = unlist(coef(summary(mol)))["(Intercept)",1]
  report[8] = unlist(coef(summary(mol)))["(Intercept)",2]
  report[9] = unlist(coef(summary(mol)))["(Intercept)",3]
  report[10] = unlist(coef(summary(mol)))["(Intercept)",4] #H0: B0 = 0
  
  report[11] = unlist(coef(summary(mol)))["poly(ConTemp, 3)1",1]
  report[12] = unlist(coef(summary(mol)))["poly(ConTemp, 3)1",2]
  report[13] = unlist(coef(summary(mol)))["poly(ConTemp, 3)1",3]
  report[14] = unlist(coef(summary(mol)))["poly(ConTemp, 3)1",4] #H0: B1 = 0
  
  report[15] = unlist(coef(summary(mol)))["poly(ConTemp, 3)2",1]
  report[16] = unlist(coef(summary(mol)))["poly(ConTemp, 3)2",2]
  report[17] = unlist(coef(summary(mol)))["poly(ConTemp, 3)2",3]
  report[18] = unlist(coef(summary(mol)))["poly(ConTemp, 3)2",4] #H0: B2 = 0
  
  report[19] = unlist(coef(summary(mol)))["poly(ConTemp, 3)3",1]
  report[20] = unlist(coef(summary(mol)))["poly(ConTemp, 3)3",2]
  report[21] = unlist(coef(summary(mol)))["poly(ConTemp, 3)3",3]
  report[22] = unlist(coef(summary(mol)))["poly(ConTemp, 3)3",4]

  Cub = cbind(Cub,report)
}

labels = c("Value_name",1:903)
colnames(Cub) = labels

write.csv(Cub, "Results/cubic_polynomial_model.csv", row.names = F)
