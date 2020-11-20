#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: Briere_model.R
#Work Path: CMEECourseWork/MiniProject/Code
#Depemdency: minpack.lm
#Input: Results/filtered_data.csv
#Function: Fit each thermal performace curve with Briere model:
#          B(T) = (B0) * T * (T - T0) * (Tm - T)^0.5
#          where B(T) is trait value under temperature T, 
#          parameters are B0, T0, Tm, and
#          T0 < Tm, B0 > 0.
#Output: Results/Briere_model_n.csv
#Usage: Rscript Briere_model.R
#Date: Oct, 2020

rm(list = ls())

library(minpack.lm)

data = read.csv("../Results/filtered_data.csv")

name = c("SampleSize","AIC","BIC",
         "B0","std.error_B0","t_B0","p_B0","B0_start",
         "T0","std.error_T0","t_T0","p_T0","T0_start",
         "Tm","std.error_Tm","t_Tm","p_Tm","Tm_start","ID")

Brie = data.frame(Value_name = name)

Brie_fun = function(t, B0, T0, Tm){
  return(B0 * t * (t-T0) * (Tm-t)^0.5)
}

for (i in 1:903){
  d = subset(data, ID == i)
  T0_start = min(d$ConTemp)
  Tm_start = max(d$ConTemp)
  a=d$OriginalTraitValue/(d$ConTemp*(d$ConTemp-T0_start)*(Tm_start-d$ConTemp)^0.5)
  a[is.na(a)] = 0
  a=a[!is.infinite(a)]
  B0_estimate = mean(a)
  B0_starts = runif(100, 0.1*B0_estimate, 10*B0_estimate)
  for (B0_start in B0_starts){
    mol = try(
      nlsLM(data = d,
            d$OriginalTraitValue ~ Brie_fun(ConTemp,B0,T0,Tm),
            start = list(B0 = B0_start, T0 = T0_start, Tm = Tm_start),
            control = list(maxiter = 200)),
      silent = T
    )
    if (as.vector(summary(mol))[2] != "try-error"){
      report = rep(NA,19)
      #Sample size
      report[1] = nrow(d)
      #AIC, BIC
      report[2] = AIC(mol) #The smaller, better fitting
      report[3] = BIC(mol) #The smaller, better fitting
      #B0
      report[4] = coef(summary(mol))["B0",1]
      report[5] = coef(summary(mol))["B0",2]
      report[6] = coef(summary(mol))["B0",3]
      report[7] = coef(summary(mol))["B0",4] #H0: B0 = 0
      report[8] = B0_start
      #T0
      report[9] = coef(summary(mol))["T0",1]
      report[10] = coef(summary(mol))["T0",2]
      report[11] = coef(summary(mol))["T0",3]
      report[12] = coef(summary(mol))["T0",4] #H0: B1 = 0
      report[13] = T0_start
      #Tm
      report[14] = coef(summary(mol))["Tm",1]
      report[15] = coef(summary(mol))["Tm",2]
      report[16] = coef(summary(mol))["Tm",3]
      report[17] = coef(summary(mol))["Tm",4] #H0: B2 = 0
      report[18] = Tm_start
      #ID
      report[19] = i
      
      Brie = cbind(Brie,report)
    }
  }
}

labels = c("ID",Brie[19,][-1])
colnames(Brie) = labels
Brie = Brie[-19,]
Brie = t(Brie)

write.csv(Brie, 
          "../Results/Briere_model.csv", 
          row.names = T)
