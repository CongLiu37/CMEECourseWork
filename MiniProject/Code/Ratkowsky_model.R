#Language: R 4.0.3
#Author: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/MiniProject/Code
#Depemdency: minpack.lm
#Input: ../Results/filtered_data.csv
#Function: Fit each thermal performace curve with Ratkowsky model:
#          B(T)^0.5 = a * (t - T0) * (1 - exp(b * (t - Tm)))
#          where B(T) is trait value under temperature T. 
#          T0, Tm, a, b are constants. AIC and BIC are calculated.
#Output: ../Results/Ratkowsky_model.csv
#Usage: Rscript Ratkowsky_model.R
#Date: Oct, 2020

rm(list = ls())

library(minpack.lm)

data = read.csv("../Results/filtered_data.csv")

name = c("SampleSize","AIC","BIC",
         "T0","std.error_T0","t_T0","p_T0","T0_start",
         "Tm","std.error_Tm","t_Tm","p_Tm","Tm_start",
         "a","std.error_a","t_a","p_a","a_start",
         "b","std.error_b","t_b","p_b","b_start",
         "ID")

Rat = data.frame(Value_name = name)

#Ratkowsky model
Rat_fun = function(t, T0, Tm, a, b){
  return(a * (t - T0) * (1 - exp(b * (t - Tm))))
}

#Start values of a and b
a_starts = 10^seq(-5,4)
b_starts = 10^seq(-5,4)

for (i in 1:903){
  d = subset(data, ID == i)
  #Start values of T0 and Tm
  T0_start = min(d$ConTemp)
  Tm_start = max(d$ConTemp)
  
  for (a0 in a_starts){
    for (b0 in b_starts){
      #Model fitting
      mol = try(
        nlsLM(data = d,
              sqrt(d$OriginalTraitValue) ~ Rat_fun(ConTemp,T0, Tm, a, b),
              start = list(T0 = T0_start, Tm = Tm_start, a = a0, b = b0),
              control = list(maxiter = 200)),
        silent = T)
      if (as.vector(summary(mol))[2] != "try-error"){
        report = rep(NA,24)
        #Sample size
        report[1] = nrow(d)
        #T0
        report[4] = coef(summary(mol))["T0",1]
        report[5] = coef(summary(mol))["T0",2]
        report[6] = coef(summary(mol))["T0",3]
        report[7] = coef(summary(mol))["T0",4] #H0: B0 = 0
        report[8] = T0_start
        #Tm
        report[9] = coef(summary(mol))["Tm",1]
        report[10] = coef(summary(mol))["Tm",2]
        report[11] = coef(summary(mol))["Tm",3]
        report[12] = coef(summary(mol))["Tm",4] #H0: B1 = 0
        report[13] = Tm_start
        #a
        report[14] = coef(summary(mol))["a",1]
        report[15] = coef(summary(mol))["a",2]
        report[16] = coef(summary(mol))["a",3]
        report[17] = coef(summary(mol))["a",4] #H0: B2 = 0
        report[18] = a0
        #b
        report[19] = coef(summary(mol))["b",1]
        report[20] = coef(summary(mol))["b",2]
        report[21] = coef(summary(mol))["b",3]
        report[22] = coef(summary(mol))["b",4] #H0: B2 = 0
        report[23] = b0
        #ID
        report[24] = i
        #AIC, BIC
        pre = (Rat_fun(d$ConTemp, report[4], report[9], report[14],report[19]))^2
        RSS = sum((d$OriginalTraitValue - pre)^2)
        likelihood = -0.5*report[1]*log(RSS/report[1])
        report[2] = -2*likelihood + 8
        report[3] = -2*likelihood + 4*log(report[1])
        
        Rat = cbind(Rat,report)
      }
    }
  }
}

labels = c("ID",Rat[24,][-1])
colnames(Rat) = labels
Rat = Rat[-24,]
Rat = t(Rat)

write.csv(Rat, 
          "../Results/Ratkowsky_model.csv", 
          row.names = T)
