#Language: R 4.0.3
#Author: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/MiniProject/Code
#Dependency:
#Input: ../Results/filtered_data.csv
#Function: Fit each thermal performance curve with quadratic model:
#          B(T) = B0 + B1*T + B2*T^2 
#          where B(T) is trait value under temperature T, 
#          B0, B1, B2 are constants. AIC and BIC are calculated.
#Output: ../Results/quadratic_polynomial_model.csv
#Usage: Rscript quadratic_polynomial_model.R
#Date: Oct, 2020

rm(list = ls())

data = read.csv("../Results/filtered_data.csv")

name = c("SampleSize","AIC","BIC",
         "B0","std.error_B0","t_B0","p_B0",
         "B1","std.error_B1","t_B1","p_B1",
         "B2","std.error_B2","t_B2","p_B2",
         "ID")

qua = data.frame(Value_name = name)

#Model fitting
for (i in 1:903){
  d = subset(data, ID == i)
  
  mol = lm(data = d,
           d$OriginalTraitValue ~ poly(ConTemp,2,raw = T))
  report = rep(NA,16)
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
  #B1
  report[8] = coef(summary(mol))["poly(ConTemp, 2, raw = T)1",1]
  report[9] = coef(summary(mol))["poly(ConTemp, 2, raw = T)1",2]
  report[10] = coef(summary(mol))["poly(ConTemp, 2, raw = T)1",3]
  report[11] = coef(summary(mol))["poly(ConTemp, 2, raw = T)1",4] #H0: B1 = 0
  #B2
  report[12] = coef(summary(mol))["poly(ConTemp, 2, raw = T)2",1]
  report[13] = coef(summary(mol))["poly(ConTemp, 2, raw = T)2",2]
  report[14] = coef(summary(mol))["poly(ConTemp, 2, raw = T)2",3]
  report[15] = coef(summary(mol))["poly(ConTemp, 2, raw = T)2",4] #H0: B2 = 0
  #ID
  report[16] = i
        
  qua = cbind(qua,report)
}


labels = c("ID",qua[16,][-1])
colnames(qua) = labels
qua = qua[-16,]
qua = t(qua)

write.csv(qua, 
          "../Results/quadratic_polynomial_model.csv", 
          row.names = T)
