#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: quadratic_polynomial_model.R
#Work Path: CMEECourseWork/MiniProject
#Depemdency:
#Input: Data/ThermRespData.csv
#Function: Fit each thermal performace curve with quadratic model:
#          B(T) = (B0) + (B1)T + (B2)(T^2)
#          where B(T) is trait value under temperature T, 
#          parameters are B0, B1, B2.
#Output: Results/quadratic_polynomial_model.csv
#Usage: Rscript quadratic_polynomial_model.R
#Date: Oct, 2020

rm(list = ls())

data = read.csv("Data/ThermRespData.csv")

name = c("SampleSize","RSS","TSS","RSq","adj.RSq","AIC","BIC",
         "B0","std.error_B0","t_B0","p_B0",
         "B1","std.error_B1","t_B1","p_B1",
         "B2","std.error_B2","t_B2","p_B2")

Qua = data.frame(Value_name = name)

for (i in 1:903){
  d = subset(data, ID == i)
  mol = lm(data = d,
           OriginalTraitValue ~ poly(ConTemp,2))
  
  report = rep(NA,19)
  
  #Sample size
  report[1] = nrow(d)
  
  #RSS, TSS, RSq, adj.RSq
  report[2] = sum(residuals(mol)^2)
  report[3] = sum((d$OriginalTraitValue - mean(d$ConTemp))^2)
  report[4] = 1 - report[2]/report[3] # >0.5 indicates good fitting
  report[5] = 1 - (1 - report[4]) * (report[1] - 1)/(report[1] -1 - 2)
  
  #AIC, BIC
  report[6] = AIC(mol) #The smaller, better fitting
  report[7] = BIC(mol) #The smaller, better fitting
  
  #B0
  report[8] = unlist(coef(summary(mol)))["(Intercept)",1]
  report[9] = unlist(coef(summary(mol)))["(Intercept)",2]
  report[10] = unlist(coef(summary(mol)))["(Intercept)",3]
  report[11] = unlist(coef(summary(mol)))["(Intercept)",4] #H0: B0 = 0
  
  #B1
  report[12] = unlist(coef(summary(mol)))["poly(ConTemp, 2)1",1]
  report[13] = unlist(coef(summary(mol)))["poly(ConTemp, 2)1",2]
  report[14] = unlist(coef(summary(mol)))["poly(ConTemp, 2)1",3]
  report[15] = unlist(coef(summary(mol)))["poly(ConTemp, 2)1",4] #H0: B1 = 0
  
  #B2
  report[16] = unlist(coef(summary(mol)))["poly(ConTemp, 2)2",1]
  report[17] = unlist(coef(summary(mol)))["poly(ConTemp, 2)2",2]
  report[18] = unlist(coef(summary(mol)))["poly(ConTemp, 2)2",3]
  report[19] = unlist(coef(summary(mol)))["poly(ConTemp, 2)2",4] #H0: B2 = 0
  
  Qua = cbind(Qua,report)
}

labels = c("Value_name",1:903)
colnames(Qua) = labels

write.csv(Qua, "Results/quadratic_polynomial_model.csv", row.names = F)

