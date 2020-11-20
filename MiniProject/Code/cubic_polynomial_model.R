#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: cubic_polynomial_model.R
#Work Path: CMEECourseWork/MiniProject/Code
#Depemdency:
#Input: Results/filtered_data.csv
#Function: Fit each thermal performace curve with cubic model:
#          B(T) = (B0) + (B1)T + (B2)(T^2) + (B3)(T^3)
#          where B(T) is trait value under temperature T, 
#          parameters are B0, B1, B2, B3.
#Output: Results/cubic_polynomial_model.csv
#Usage: Rscript cubic_polynomial_model.R
#Date: Oct, 2020

rm(list = ls())

data = read.csv("../Results/filtered_data.csv")

name = c("SampleSize","AIC","BIC",
         "B0","std.error_B0","t_B0","p_B0",
         "B1","std.error_B1","t_B1","p_B1",
         "B2","std.error_B2","t_B2","p_B2",
         "B3","std.error_B3","t_B3","p_B3")
Cub = data.frame(Value_name = name)


for (i in 1:903){
  d = subset(data, ID == i)
  mol = lm(data = d,
           OriginalTraitValue ~ poly(ConTemp,3,raw=T))
  
  report = rep(NA,19)
  #Sample size
  report[1] = nrow(d)
  #AIC, BIC
  report[2] = AIC(mol) #The smaller, better fitting
  report[3] = BIC(mol) #The smaller, better fitting
  #B0
  report[4] = unlist(coef(summary(mol)))["(Intercept)",1]
  report[5] = unlist(coef(summary(mol)))["(Intercept)",2]
  report[6] = unlist(coef(summary(mol)))["(Intercept)",3]
  report[7] = unlist(coef(summary(mol)))["(Intercept)",4] #H0: B0 = 0
  #B1
  report[8] = unlist(coef(summary(mol)))["poly(ConTemp, 3, raw = T)1",1]
  report[9] = unlist(coef(summary(mol)))["poly(ConTemp, 3, raw = T)1",2]
  report[10] = unlist(coef(summary(mol)))["poly(ConTemp, 3, raw = T)1",3]
  report[11] = unlist(coef(summary(mol)))["poly(ConTemp, 3, raw = T)1",4] #H0: B1 = 0
  #B2
  report[12] = unlist(coef(summary(mol)))["poly(ConTemp, 3, raw = T)2",1]
  report[13] = unlist(coef(summary(mol)))["poly(ConTemp, 3, raw = T)2",2]
  report[14] = unlist(coef(summary(mol)))["poly(ConTemp, 3, raw = T)2",3]
  report[15] = unlist(coef(summary(mol)))["poly(ConTemp, 3, raw = T)2",4] #H0: B2 = 0
  #B3
  report[16] = unlist(coef(summary(mol)))["poly(ConTemp, 3, raw = T)3",1]
  report[17] = unlist(coef(summary(mol)))["poly(ConTemp, 3, raw = T)3",2]
  report[18] = unlist(coef(summary(mol)))["poly(ConTemp, 3, raw = T)3",3]
  report[19] = unlist(coef(summary(mol)))["poly(ConTemp, 3, raw = T)3",4]
  
  Cub = cbind(Cub,report)
}

labels = c("ID",1:903)
colnames(Cub) = labels
Cub = t(Cub)

write.csv(Cub, "../Results/cubic_polynomial_model.csv", row.names = T)


