#Language: R 4.0.3
#Author: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/MiniProject/Code
#Dependency: 
#Input: ../Results/quadratic_polynomial_model.csv
#       ../Results/cubic_polynomial_model.csv
#       ../Results/Briere_model.csv
#       ../Results/Ratkowsky_model.csv
#Function: (1) For each curve, select combinations of parameters of Briere model
#              that lead to lowest AIC or BIC and conduct model averaging, 
#              saving as ../Results/Briere_AIC.csv and ../Results/Briere_BIC.csv.
#          (2) For each curve, select combinations of parameters of Ratkowsky model
#              that lead to lowest AIC or BIC and conduct model averaging,
#              saving as ../Results/Ratkowsky_AIC.csv and ../Results/Ratkowsky_BIC.csv
#          (3) Extract parameter values of all linear models, saving as 
#              ../Results/quadratic_valid.csv and ../Results/cubic_valid.csv.
#Output: ../Results/quadratic_valid.csv
#        ../Results/cubic_valid.csv
#        ../Results/Briere_AIC.csv
#        ../Results/Briere_BIC.csv
#        ../Results/Ratkowsky_AIC.csv
#        ../Results/Ratkowsky_BIC.csv
#Usage: Rscript ModelQC.R
#Date: Nov, 2020

rm(list = ls())
data = read.csv("../Results/filtered_data.csv")

#Extract parameters of quadratic model
Q = read.csv("../Results/quadratic_polynomial_model.csv", header = T)
colnames(Q) = Q[1,]
Q = Q[-1,]
Q = data.frame(lapply(Q, as.numeric))
Q_parameter = data.frame(ID=Q$ID,AIC=Q$AIC,BIC=Q$BIC,B0=Q$B0,B1=Q$B1,B2=Q$B2)
write.csv(Q_parameter,"../Results/quadratic_valid.csv", row.names = F)
#Extract parameters of cubic model
C = read.csv("../Results/cubic_polynomial_model.csv", header = T)
colnames(C) = C[1,]
C = C[-1,]
C = data.frame(lapply(C, as.numeric))
C_parameter = data.frame(ID=C$ID,AIC=C$AIC,BIC=C$BIC,B0=C$B0,B1=C$B1,B2=C$B2,B3=C$B3)
write.csv(C_parameter,"../Results/cubic_valid.csv", row.names = F)

#Import Briere models
B = read.csv("../Results/Briere_model.csv")
colnames(B) = B[1,]
B = B[-1,]
B1 = B

ID_B = names(table(B1$ID))
B_AIC = data.frame()
B_BIC = data.frame()

#Select Briere models with lowest AIC/BIC
for (i in ID_B){
  d = subset(B1, ID == i)
  d_AIC = subset(d, as.numeric(d$AIC) == min(as.numeric(d$AIC)))
  B_AIC = rbind(B_AIC,d_AIC)
  d_BIC = subset(d, as.numeric(BIC) == min(as.numeric(d$BIC)))
  B_BIC = rbind(B_BIC,d_BIC)
}

B_AIC_parameters = data.frame(ID = B_AIC$ID,
                              AIC = B_AIC$AIC,BIC = B_AIC$BIC,
                              B0 = B_AIC$B0,T0 = B_AIC$T0,Tm = B_AIC$Tm)
B_AIC_parameters = B_AIC_parameters[!duplicated(B_AIC_parameters),]

#Model average based on AIC selection
Briere_AIC = data.frame()
for (i in as.numeric(names(table(B_AIC_parameters$ID)))){
  d = subset(B_AIC_parameters, ID == i)
  f = subset(data, ID == i)
  B0 = mean(as.numeric(d$B0))
  T0 = mean(as.numeric(d$T0))
  Tm = mean(as.numeric(d$Tm))
  
  #AIC/BIC of averaged model
  pre = B0*f$ConTemp*(f$ConTemp-T0)*(abs(Tm-f$ConTemp))^0.5
  RSS = sum((f$OriginalTraitValue - pre)^2)
  likelihood = -0.5*nrow(f)*log(RSS/nrow(f))
  AIC = -2*likelihood + 6
  BIC = -2*likelihood + 3*log(nrow(f))
  a = c(i, AIC, BIC, B0, T0, Tm)
  
  Briere_AIC = rbind(Briere_AIC, a)}
colnames(Briere_AIC) = c("ID", "AIC", "BIC", "B0", "T0", "Tm")


B_BIC_parameters = data.frame(ID = B_BIC$ID,
                              AIC = B_BIC$AIC, BIC = B_BIC$BIC,
                              B0 = B_BIC$B0,T0 = B_BIC$T0,Tm = B_BIC$Tm)
B_BIC_parameters = B_BIC_parameters[!duplicated(B_BIC_parameters),]

#Model average based on BIC selection
Briere_BIC = data.frame()
for (i in as.numeric(names(table(B_BIC_parameters$ID)))){
  d = subset(B_BIC_parameters, ID == i)
  f = subset(data, ID == i)
  B0 = mean(as.numeric(d$B0))
  T0 = mean(as.numeric(d$T0))
  Tm = mean(as.numeric(d$Tm))
  
  #AIC/BIC of averaged model
  pre = B0*f$ConTemp*(f$ConTemp-T0)*(abs(Tm-f$ConTemp))^0.5
  RSS = sum((f$OriginalTraitValue - pre)^2)
  likelihood = -0.5*nrow(f)*log(RSS/nrow(f))
  AIC = -2*likelihood + 6
  BIC = -2*likelihood + 3*log(nrow(f))
  a = c(i, AIC, BIC, B0, T0, Tm)
  
  Briere_BIC = rbind(Briere_BIC, a)}
colnames(Briere_BIC) = c("ID", "AIC", "BIC", "B0", "T0", "Tm")

write.csv(Briere_AIC,"../Results/Briere_AIC.csv",row.names = F)
write.csv(Briere_BIC,"../Results/Briere_BIC.csv",row.names = F)

###############################################################
#The same work flow for Ratkowsky model
R = read.csv("../Results/Ratkowsky_model.csv")
colnames(R) = R[1,]
R = R[-1,]
R1 = R


ID_R = names(table(R1$ID))
R_AIC = data.frame()
R_BIC = data.frame()

for (i in ID_R){
  d = subset(R1, ID == i)
  d_AIC = subset(d, as.numeric(d$AIC) == min(as.numeric(d$AIC)))
  R_AIC = rbind(R_AIC,d_AIC)
  d_BIC = subset(d, as.numeric(d$BIC) == min(as.numeric(d$BIC)))
  R_BIC = rbind(R_BIC,d_BIC)
}

R_AIC_parameters = data.frame(ID = R_AIC$ID,
                              AIC = R_AIC$AIC,BIC = R_AIC$BIC,
                              T0 = R_AIC$T0,Tm = R_AIC$Tm,
                              a = R_AIC$a, b = R_AIC$b)
R_AIC_parameters = R_AIC_parameters[!duplicated(R_AIC_parameters),]

Ratkowsky_AIC = data.frame()
for (i in as.numeric(names(table(R_AIC_parameters$ID)))){
  d = subset(R_AIC_parameters, ID == i)
  f = subset(data, ID == i)
  T0 = mean(as.numeric(d$T0))
  Tm = mean(as.numeric(d$Tm))
  a = mean(as.numeric(d$a))
  b = mean(as.numeric(d$b))
  
  pre = (a * (f$ConTemp - T0) * (1 - exp(b * (f$ConTemp - Tm))))^2
  RSS = sum((f$OriginalTraitValue - pre)^2)
  likelihood = -0.5*nrow(f)*log(RSS/nrow(f))
  AIC = -2*likelihood + 8
  BIC = -2*likelihood + 4*log(nrow(f))
  a = c(i, AIC, BIC, T0, Tm, a, b)
  
  Ratkowsky_AIC = rbind(Ratkowsky_AIC, a)}
colnames(Ratkowsky_AIC) = c("ID", "AIC", "BIC", "T0", "Tm", "a", "b")

R_BIC_parameters = data.frame(ID = R_BIC$ID,
                              AIC = R_BIC$AIC, BIC = R_BIC$BIC,
                              T0 = R_BIC$T0,Tm = R_BIC$Tm,
                              a = R_BIC$a, b = R_BIC$b)
R_BIC_parameters = R_BIC_parameters[!duplicated(R_BIC_parameters),]
Ratkowsky_BIC = data.frame()
for (i in as.numeric(names(table(R_BIC_parameters$ID)))){
  d = subset(R_BIC_parameters, ID == i)
  f = subset(data, ID == i)
  T0 = mean(as.numeric(d$T0))
  Tm = mean(as.numeric(d$Tm))
  a = mean(as.numeric(d$a))
  b = mean(as.numeric(d$b))
  
  pre = (a * (f$ConTemp - T0) * (1 - exp(b * (f$ConTemp - Tm))))^2
  RSS = sum((f$OriginalTraitValue - pre)^2)
  likelihood = -0.5*nrow(f)*log(RSS/nrow(f))
  AIC = -2*likelihood + 8
  BIC = -2*likelihood + 4*log(nrow(f))
  a = c(i, AIC, BIC, T0, Tm, a, b)
  
  Ratkowsky_BIC = rbind(Ratkowsky_BIC, a)}
colnames(Ratkowsky_BIC) = c("ID", "AIC", "BIC", "T0", "Tm", "a", "b")

write.csv(Ratkowsky_AIC,"../Results/Ratkowsky_AIC.csv",row.names = F)
write.csv(Ratkowsky_BIC,"../Results/Ratkowsky_BIC.csv",row.names = F)
