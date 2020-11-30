#Language: R 4.0.3
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: ModelQC.R
#Work Path: CMEECourseWork/MiniProject/Code
#Dependency: 
#Input: ../Results/quadratic_polynomial_model.csv
#       ../Results/cubic_polynomial_model.csv
#       ../Results/Briere_model.csv
#       ../Results/Ratkowsky_model.csv
#Function: (1) For each curve, select combinations of parameters of Briere model
#              that lead to lowest AIC or BIC.
#          (2) For each curve, select combinations of parameters of Ratkowsky model
#              that lead to lowest AIC or BIC.
#          (3) Extract parameter values of all models.
#Output: ../Results/quadratic_valid.csv
#        ../Results/cubic_valid.csv
#        ../Results/Briere_valid.csv
#        ../Results/Ratkowsky_valid.csv
#        ../Results/Briere_AIC.csv
#        ../Results/Briere_BIC.csv
#        ../Results/Ratkowsky_AIC.csv
#        ../Results/Ratkowsky_BIC.csv
#Usage: Rscript ModelQC.R
#Date: Nov, 2020

rm(list = ls())

Q = read.csv("../Results/quadratic_polynomial_model.csv", header = T)
colnames(Q) = Q[1,]
Q = Q[-1,]
Q = data.frame(lapply(Q, as.numeric))

Q_parameter = data.frame(ID=Q$ID,AIC=Q$AIC,BIC=Q$BIC,B0=Q$B0,B1=Q$B1,B2=Q$B2)
write.csv(Q_parameter,"../Results/quadratic_valid.csv", row.names = F)

C = read.csv("../Results/cubic_polynomial_model.csv", header = T)
colnames(C) = C[1,]
C = C[-1,]
C = data.frame(lapply(C, as.numeric))

C_parameter = data.frame(ID=C$ID,AIC=C$AIC,BIC=C$BIC,B0=C$B0,B1=C$B1,B2=C$B2,B3=C$B3)
write.csv(C_parameter,"../Results/cubic_valid.csv", row.names = F)

B = read.csv("../Results/Briere_model.csv")
colnames(B) = B[1,]
B = B[-1,]
B1 = B
#B1 = subset(B, as.numeric(B$B0) > 0)
#B1 = subset(B1, as.numeric(B1$T0) > -30)
#B1 = subset(B1, as.numeric(B1$Tm) < 100)
#B1 = subset(B1,as.numeric(B1$T0) < as.numeric(B1$Tm))

#v2 = paste(length(table(B1$ID)),"of 903 curves can be fitted by Briere models with realistic parameters")
#print(v2)

#write.csv(B1, "../Results/Briere_valid.csv",row.names = F)

ID_B = names(table(B1$ID))
B_AIC = data.frame()
B_BIC = data.frame()

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


B_BIC_parameters = data.frame(ID = B_BIC$ID,
                              AIC = B_BIC$AIC, BIC = B_BIC$BIC,
                              B0 = B_BIC$B0,T0 = B_BIC$T0,Tm = B_BIC$Tm)
B_BIC_parameters = B_BIC_parameters[!duplicated(B_BIC_parameters),]

write.csv(B_AIC_parameters,"../Results/Briere_AIC.csv",row.names = F)
write.csv(B_BIC_parameters,"../Results/Briere_BIC.csv",row.names = F)

R = read.csv("../Results/Ratkowsky_model.csv")
colnames(R) = R[1,]
R = R[-1,]
R1 = R


#R1 = subset(R, as.numeric(R$T0) > -30)
#R1 = subset(R1, as.numeric(R1$Tm) < 100)
#R1 = subset(R1,as.numeric(R1$T0) < as.numeric(R1$Tm))
#R1 = subset(R1, as.numeric(R1$a) > 0)
#R1 = subset(R1, as.numeric(R1$b) > 0)

#v4 = paste(length(table(R1$ID)),"of 903 curves can be fitted by Ratkowsky models with realistic parameters")
#print(v4)

#write.csv(R1, "../Results/Ratkowsky_valid.csv", row.names = F)

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


R_BIC_parameters = data.frame(ID = R_BIC$ID,
                              AIC = R_BIC$AIC, BIC = R_BIC$BIC,
                              T0 = R_BIC$T0,Tm = R_BIC$Tm,
                              a = R_BIC$a, b = R_BIC$b)
R_BIC_parameters = R_BIC_parameters[!duplicated(R_BIC_parameters),]

write.csv(R_AIC_parameters,"../Results/Ratkowsky_AIC.csv",row.names = F)
write.csv(R_BIC_parameters,"../Results/Ratkowsky_BIC.csv",row.names = F)
