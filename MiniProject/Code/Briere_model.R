#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: Briere_model.R
#Work Path: CMEECourseWork/MiniProject
#Depemdency: minpack.lm
#Input: Data/ThermRespData.csv
#Function: Fit each thermal performace curve with cubic model:
#          B(T) = (B0) * T * (T - T0) * (Tm - T)^0.5
#          where B(T) is trait value under temperature T, 
#          parameters are B0, T0, Tm.
#Output: 
#Usage: Rscript cubic_polynomial_model.R [input]
#Date: Oct, 2020

rm(list = ls())

library(minpack.lm)

data = read.csv("Data/ThermRespData.csv")

name = c("SampleSize","RSS","TSS","RSq","adj.R","AIC","BIC",
         "B0","std.error_B0","t_B0","p_B0","B0_start",
         "T0","std.error_T0","t_T0","p_T0","T0_start",
         "Tm","std.error_Tm","t_Tm","p_Tm","Tm_start","ID")

Brie = data.frame(Value_name = name)

Brie_fun = function(t, B0, T0, Tm){
  return(B0 * t * (t-T0) * (Tm-t)^0.5)
}

B0_start = runif(1,-2,2)
T0_start = runif(1,-4.516,24.329) #1st Qu and 3st Qu of the lowest temperature of samples among all curves
Tm_start = runif(1,19.45,69.27) #1st Qu and 3st Qu of the highest temperature of samples among all curves

d = subset(data, ID == 10)
BrieFit = try(nlsLM(OriginalTraitValue ~ Brie_fun(ConTemp,B0,T0,Tm),
                    data = d,
                    start = list(B0 = 0, T0 = 1, Tm = 35)),silent = T)

a = as.vector(summary(BrieFit))[2]

for (i in 1:903){
  d = subset(data, ID == i)
  mol = try(
    nlsLM(data = d,
           OriginalTraitValue ~ Brie_fun(ConTemp,B0,T0,Tm),
           start = list(B0 = B0_start, T0 = T0_start, Tm = Tm_start)),
    silent = T
  )
  if (as.vector(summary(mol))[2] != a){
    report = rep(NA,23)
    #Sample size
    report[1] = nrow(d)
    #RSS, TSS, RSq and adj.RSq
    report[2] = sum(residuals(mol)^2)
    report[3] = sum((d$OriginalTraitValue - mean(d$ConTemp))^2)
    report[4] = 1 - report[2]/report[3] # >0.5 indicates good fitting
    report[5] = 1 - (1 - report[4])*(report[1] - 1)/(report[1] - 1 - 3)
    #AIC, BIC
    report[6] = AIC(mol) #The smaller, better fitting
    report[7] = BIC(mol) #The smaller, better fitting
    #B0
    report[8] = coef(summary(mol))["B0",1]
    report[9] = coef(summary(mol))["B0",2]
    report[10] = coef(summary(mol))["B0",3]
    report[11] = coef(summary(mol))["B0",4] #H0: B0 = 0
    report[12] = B0_start
    #T0
    report[13] = coef(summary(mol))["T0",1]
    report[14] = coef(summary(mol))["T0",2]
    report[15] = coef(summary(mol))["T0",3]
    report[16] = coef(summary(mol))["T0",4] #H0: B1 = 0
    report[17] = T0_start
    #Tm
    report[18] = coef(summary(mol))["Tm",1]
    report[19] = coef(summary(mol))["Tm",2]
    report[20] = coef(summary(mol))["Tm",3]
    report[21] = coef(summary(mol))["Tm",4] #H0: B2 = 0
    report[22] = Tm_start
    
    report[23] = i
    
    Brie = cbind(Brie,report)
  }
}

labels = c("Value_name",Brie[23,][-1])
colnames(Brie) = labels
Brie = Brie[-23,]

args = commandArgs(T)
write.csv(Brie, 
          paste("Results/Briere_model",args[1],".csv"), 
          row.names = F)
