#Language: R 4.0.3
#Author: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/MiniProject/Code
#Dependency: 
#Input: ../Results/quadratic_valid.csv
#       ../Results/cubic_valid.csv
#       ../Results/Briere_AIC.csv
#       ../Results/Briere_BIC.csv
#       ../Results/Ratkowsky_AIC.csv
#       ../Results/Ratkowsky_BIC.csv
#Function: For each curve, select best-fitting models from 
#          quadratic, cubic, Briere and Ratkowsky models, 
#          using either AIC or BIC as criteria.
#Output: ../Results/bestAIC_quadratic.csv (AIC, quadratic winner)
#        ../Results/bestBIC_quadratic.csv (BIC, quadratic winner)
#        ../Results/bestAIC_cubic.csv (AIC, cubic winner)
#        ../Results/bestBIC_cubic.csv (BIC, cubic winner)
#        ../Results/bestAIC_Briere.csv (AIC, Briere winner)
#        ../Results/bestBIC_Briere.csv (BIC, Briere winner)
#        ../Results/bestAIC_Ratkowsky.csv (AIC, Ratkowsky winner)
#        ../Results/bestBIC_Ratkowsky.csv (BIC, Ratkowsky winner)
#Usage: Rscript BestModel.R
#Date: Nov, 2020

rm(list = ls())
#Import data
Qua = read.csv("../Results/quadratic_valid.csv", header = T)
Cub = read.csv("../Results/cubic_valid.csv", header = T)

Bri_AIC = read.csv("../Results/Briere_AIC.csv", header = T)
Bri_BIC = read.csv("../Results/Briere_BIC.csv", header = T)

Rat_AIC = read.csv("../Results/Ratkowsky_AIC.csv", header = T)
Rat_BIC = read.csv("../Results/Ratkowsky_BIC.csv", header = T)

AICbestQ = data.frame()
AICbestC = data.frame()
AICbestB = data.frame()
AICbestR = data.frame()

BICbestQ = data.frame()
BICbestC = data.frame()
BICbestB = data.frame()
BICbestR = data.frame()
#Model selection
for (i in 1:903){
  q = subset(Qua, ID == i)
  c = subset(Cub, ID == i)
  b_AIC = subset(Bri_AIC, ID == i)
  b_BIC = subset(Bri_BIC, ID == i)
  r_AIC = subset(Rat_AIC, ID == i)
  r_BIC = subset(Rat_BIC, ID == i)
  
  AIC = min(c(q$AIC,c$AIC,b_AIC$AIC,r_AIC$AIC))
  BIC = min(c(q$BIC,c$BIC,b_BIC$BIC,r_BIC$BIC))
  
  
    if (nrow(q) != 0){
      if (q$AIC == AIC){
        AICbestQ = rbind(AICbestQ,q)
      }
    } 
  
    if (nrow(c) != 0){
      if (c$AIC == AIC){
        AICbestC = rbind(AICbestC,c)
      }
    }
      
    if (nrow(b_AIC) != 0){
      if (all(b_AIC$AIC == rep(AIC,nrow(b_AIC)))){
        AICbestB = rbind(AICbestB,b_AIC)
      }
    }
    
    if (nrow(r_AIC) != 0){
      if (all(r_AIC$AIC == rep(AIC,nrow(r_AIC)))){
        AICbestR = rbind(AICbestR,r_AIC)
      }
    }
    
    if (nrow(q) != 0){
      if (q$BIC == BIC){
        BICbestQ = rbind(BICbestQ,q)
      }
    } 
  
    if (nrow(c) != 0){
      if (c$BIC == BIC){
        BICbestC = rbind(BICbestC,c)
      }
    }
  
    if (nrow(b_BIC) != 0){
      if (all(b_BIC$BIC == rep(BIC,nrow(b_BIC)))){
        BICbestB = rbind(BICbestB,b_BIC)
      }
    }
    
    if (nrow(r_BIC) != 0){
      if (all(r_BIC$BIC == rep(BIC,nrow(r_BIC)))){
        BICbestR = rbind(BICbestR,r_BIC)
      }
    }
}

#Output
write.csv(AICbestQ,"../Results/bestAIC_quadratic.csv",row.names = F)
write.csv(AICbestC,"../Results/bestAIC_cubic.csv",row.names = F)
write.csv(AICbestB,"../Results/bestAIC_Briere.csv",row.names = F)
write.csv(AICbestR,"../Results/bestAIC_Ratkowsky.csv",row.names = F)

write.csv(BICbestQ,"../Results/bestBIC_quadratic.csv",row.names = F)
write.csv(BICbestC,"../Results/bestBIC_cubic.csv",row.names = F)
write.csv(BICbestB,"../Results/bestBIC_Briere.csv",row.names = F)
write.csv(BICbestR,"../Results/bestBIC_Ratkowsky.csv",row.names = F)
