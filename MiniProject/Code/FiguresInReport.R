#Language: R 4.0.3
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: FIguresInReport.R
#Work Path: CMEECourseWork/MiniProject/Code
#Dependency: ggplot2, gridExtra, cowplot 
#Input:  ../Results/bestAIC_quadratic.csv
#        ../Results/bestBIC_quadratic.csv
#        ../Results/bestAIC_cubic.csv
#        ../Results/bestBIC_cubic.csv
#        ../Results/bestAIC_Briere.csv
#        ../Results/bestBIC_Briere.csv
#        ../Results/bestAIC_Ratkowsky.csv
#        ../Results/bestBIC_Ratkowsky.csv
#        ../Results/filtered_data.csv
#        ../Results/move_curves.csv
#        ../Results/quadratic_valid.csv
#        ../Results/cubic_valid.csv
#        ../Results/Briere_AIC.csv
#        ../Results/Briere_BIC.csv
#        ../Results/Ratkowsky_AIC.csv
#        ../Results/Ratkowsky_BIC.csv
#Function: Plot figures in report.
#Date: Nov, 2020

rm(list = ls())
library(ggplot2)
library(gridExtra)
library(cowplot)

rescale = read.csv("../Results/move_curves.csv", header = T)
IDs = subset(rescale, minus == 0)$ID

data = read.csv("../Results/filtered_data.csv", header = T)

Q = subset(read.csv("../Results/quadratic_valid.csv", header = T),
           ID %in% IDs)
C = subset(read.csv("../Results/cubic_valid.csv", header = T),
           ID %in% IDs)
B_AIC = subset(read.csv("../Results/Briere_AIC.csv", header = T),
           ID %in% IDs)
B_BIC = subset(read.csv("../Results/Briere_BIC.csv", header = T),
           ID %in% IDs)
R_AIC = subset(read.csv("../Results/Ratkowsky_AIC.csv", header = T),
           ID %in% IDs)
R_BIC = subset(read.csv("../Results/Ratkowsky_BIC.csv", header = T),
           ID %in% IDs)

q_AIC = subset(read.csv("../Results/bestAIC_quadratic.csv", header = T),
               ID %in% IDs)
q_BIC = subset(read.csv("../Results/bestBIC_quadratic.csv", header = T),
               ID %in% IDs)
c_AIC = subset(read.csv("../Results/bestAIC_cubic.csv", header = T),
               ID %in% IDs)
c_BIC = subset(read.csv("../Results/bestBIC_cubic.csv", header = T),
               ID %in% IDs)
b_AIC = subset(read.csv("../Results/bestAIC_Briere.csv", header = T),
               ID %in% IDs)
r_AIC = subset(read.csv("../Results/bestAIC_Ratkowsky.csv", header = T),
               ID %in% IDs)
b_BIC = subset(read.csv("../Results/bestBIC_Briere.csv", header = T),
               ID %in% IDs)
r_BIC = subset(read.csv("../Results/bestBIC_Ratkowsky.csv", header = T),
               ID %in% IDs)

#######################################
#Figure 1
q = subset(Q, ID == 148)
c = subset(C, ID == 148)
b = subset(B_AIC, ID == 148)
r = subset(R_AIC, ID == 148)
d = subset(data, ID == 148)
temp = seq(min(d$ConTemp), max(d$ConTemp), 0.1)

preq = q$B0 + q$B1*temp + q$B2*temp^2
prec = c$B0 + c$B1*temp + c$B2*temp^2 + c$B3*temp^3
preb = b$B0 * temp * (temp-b$T0) * (abs(b$Tm-temp))^0.5
prer = ((r$a * (temp - r$T0)) * (1 - exp(r$b * (temp - r$Tm))))^2

preq = data.frame(Model = rep("Quadratic", length(temp)),
                  ConTemp = temp,
                  OriginalTraitValue = preq)
prec = data.frame(Model = rep("Cubic", length(temp)),
                  ConTemp = temp,
                  OriginalTraitValue = prec)
preb = data.frame(Model = rep("Briere", length(temp)),
                  ConTemp = temp,
                  OriginalTraitValue = preb)
prer = data.frame(Model = rep("Ratkowsky", length(temp)),
                  ConTemp = temp,
                  OriginalTraitValue = prer)
p1 = ggplot(d, aes(x = ConTemp, y = OriginalTraitValue)) + geom_point() +
  labs(title = "a") +
  xlab("Temperature") +
  ylab("Trait Value") +
  geom_line(data = rbind(preq, prec, preb, prer), 
            aes(x = ConTemp, y = OriginalTraitValue, colour = Model))
#subplot b of Fig. 1
q = subset(Q, ID == 204)
c = subset(C, ID == 204)
b = subset(B_AIC, ID == 204)
r = subset(R_AIC, ID == 204)
d = subset(data, ID == 204)
temp = seq(min(d$ConTemp), max(d$ConTemp), 0.1)

preq = q$B0 + q$B1*temp + q$B2*temp^2
prec = c$B0 + c$B1*temp + c$B2*temp^2 + c$B3*temp^3
preb = b$B0 * temp * (temp-b$T0) * (abs(b$Tm-temp))^0.5
prer = ((r$a * (temp - r$T0)) * (1 - exp(r$b * (temp - r$Tm))))^2

preq = data.frame(Model = rep("Quadratic", length(temp)),
                  ConTemp = temp,
                  OriginalTraitValue = preq)
prec = data.frame(Model = rep("Cubic", length(temp)),
                  ConTemp = temp,
                  OriginalTraitValue = prec)
preb = data.frame(Model = rep("Briere", length(temp)),
                  ConTemp = temp,
                  OriginalTraitValue = preb)
prer = data.frame(Model = rep("Ratkowsky", length(temp)),
                  ConTemp = temp,
                  OriginalTraitValue = prer)
p2 = ggplot(d, aes(x = ConTemp, y = OriginalTraitValue)) + geom_point() +
  labs(title = "b") +
  xlab("Temperature") +
  ylab("Trait Value") +
  geom_line(data = rbind(preq, prec, preb, prer), 
            aes(x = ConTemp, y = OriginalTraitValue, colour = Model))
#subplot c of Fig. 1
q = subset(Q, ID == 322)
c = subset(C, ID == 322)
b = subset(B_AIC, ID == 322)
r = subset(R_AIC, ID == 322)
d = subset(data, ID == 322)
temp = seq(min(d$ConTemp), max(d$ConTemp), 0.1)

preq = q$B0 + q$B1*temp + q$B2*temp^2
prec = c$B0 + c$B1*temp + c$B2*temp^2 + c$B3*temp^3
preb = b$B0 * temp * (temp-b$T0) * (abs(b$Tm-temp))^0.5
prer = ((r$a * (temp - r$T0)) * (1 - exp(r$b * (temp - r$Tm))))^2

preq = data.frame(Model = rep("Quadratic", length(temp)),
                  ConTemp = temp,
                  OriginalTraitValue = preq)
prec = data.frame(Model = rep("Cubic", length(temp)),
                  ConTemp = temp,
                  OriginalTraitValue = prec)
preb = data.frame(Model = rep("Briere", length(temp)),
                  ConTemp = temp,
                  OriginalTraitValue = preb)
prer = data.frame(Model = rep("Ratkowsky", length(temp)),
                  ConTemp = temp,
                  OriginalTraitValue = prer)
p3 = ggplot(d, aes(x = ConTemp, y = OriginalTraitValue)) + geom_point() +
  labs(title = "c") +
  xlab("Temperature") +
  ylab("Trait Value") +
  geom_line(data = rbind(preq, prec, preb, prer), 
            aes(x = ConTemp, y = OriginalTraitValue, colour = Model))
#subplot d of Fig. 1
q = subset(Q, ID == 138)
c = subset(C, ID == 138)
b = subset(B_BIC, ID == 138)
r = subset(R_BIC, ID == 138)
d = subset(data, ID == 138)
temp = seq(min(d$ConTemp), max(d$ConTemp), 0.1)

preq = q$B0 + q$B1*temp + q$B2*temp^2
prec = c$B0 + c$B1*temp + c$B2*temp^2 + c$B3*temp^3
preb = b$B0 * temp * (temp-b$T0) * (abs(b$Tm-temp))^0.5
prer = ((r$a * (temp - r$T0)) * (1 - exp(r$b * (temp - r$Tm))))^2

preq = data.frame(Model = rep("Quadratic", length(temp)),
                  ConTemp = temp,
                  OriginalTraitValue = preq)
prec = data.frame(Model = rep("Cubic", length(temp)),
                  ConTemp = temp,
                  OriginalTraitValue = prec)
preb = data.frame(Model = rep("Briere", length(temp)),
                  ConTemp = temp,
                  OriginalTraitValue = preb)
prer = data.frame(Model = rep("Ratkowsky", length(temp)),
                  ConTemp = temp,
                  OriginalTraitValue = prer)
p4 = ggplot(d, aes(x = ConTemp, y = OriginalTraitValue)) + geom_point() +
  labs(title = "d") +
  xlab("Temperature") +
  ylab("Trait Value") +
  geom_line(data = rbind(preq, prec, preb, prer), 
            aes(x = ConTemp, y = OriginalTraitValue, colour = Model))
#subplot e of Fig. 1
q = subset(Q, ID == 237)
c = subset(C, ID == 237)
b = subset(B_BIC, ID == 237)
r = subset(R_BIC, ID == 237)
d = subset(data, ID == 237)
temp = seq(min(d$ConTemp), max(d$ConTemp), 0.1)

preq = q$B0 + q$B1*temp + q$B2*temp^2
prec = c$B0 + c$B1*temp + c$B2*temp^2 + c$B3*temp^3
preb = b$B0 * temp * (temp-b$T0) * (abs(b$Tm-temp))^0.5
prer = ((r$a * (temp - r$T0)) * (1 - exp(r$b * (temp - r$Tm))))^2

preq = data.frame(Model = rep("Quadratic", length(temp)),
                  ConTemp = temp,
                  OriginalTraitValue = preq)
prec = data.frame(Model = rep("Cubic", length(temp)),
                  ConTemp = temp,
                  OriginalTraitValue = prec)
preb = data.frame(Model = rep("Briere", length(temp)),
                  ConTemp = temp,
                  OriginalTraitValue = preb)
prer = data.frame(Model = rep("Ratkowsky", length(temp)),
                  ConTemp = temp,
                  OriginalTraitValue = prer)
p5 = ggplot(d, aes(x = ConTemp, y = OriginalTraitValue)) + geom_point() +
  labs(title = "e") +
  xlab("Temperature") +
  ylab("Trait Value") +
  geom_line(data = rbind(preq, prec, preb, prer), 
            aes(x = ConTemp, y = OriginalTraitValue, colour = Model))
#subplot f of Fig. 1
q = subset(Q, ID == 519)
c = subset(C, ID == 519)
b = subset(B_BIC, ID == 519)
r = subset(R_BIC, ID == 519)
d = subset(data, ID == 519)
temp = seq(min(d$ConTemp), max(d$ConTemp), 0.1)

preq = q$B0 + q$B1*temp + q$B2*temp^2
prec = c$B0 + c$B1*temp + c$B2*temp^2 + c$B3*temp^3
preb = b$B0 * temp * (temp-b$T0) * (abs(b$Tm-temp))^0.5
prer = ((r$a * (temp - r$T0)) * (1 - exp(r$b * (temp - r$Tm))))^2

preq = data.frame(Model = rep("Quadratic", length(temp)),
                  ConTemp = temp,
                  OriginalTraitValue = preq)
prec = data.frame(Model = rep("Cubic", length(temp)),
                  ConTemp = temp,
                  OriginalTraitValue = prec)
preb = data.frame(Model = rep("Briere", length(temp)),
                  ConTemp = temp,
                  OriginalTraitValue = preb)
prer = data.frame(Model = rep("Ratkowsky", length(temp)),
                  ConTemp = temp,
                  OriginalTraitValue = prer)
p6 = ggplot(d, aes(x = ConTemp, y = OriginalTraitValue)) + geom_point() +
  labs(title = "f") +
  xlab("Temperature") +
  ylab("Trait Value") +
  geom_line(data = rbind(preq, prec, preb, prer), 
            aes(x = ConTemp, y = OriginalTraitValue, colour = Model))

pdf("../Results/Fig1.pdf")
grid.arrange(p1,p4,p2,p5,p3,p6, nrow = 3, ncol = 2)
dev.off()
###############################################################

###############################################################
#Figure 3
model_1a = subset(q_AIC, ID == 456)
data_1a = subset(data, ID == 456)
temp = seq(min(data_1a$ConTemp), max(data_1a$ConTemp), 0.1)
pre1 = model_1a$B0 + model_1a$B1*temp + model_1a$B2*temp^2
a1 = ggplot(data_1a, aes(x = ConTemp, y = OriginalTraitValue)) + geom_point() +
  labs(title = "a", parse = T) +
  xlab("Temperature (T)") +
  ylab("Trait Value (B)") + 
  geom_line(data = data.frame(ConTemp = temp,
                              OriginalTraitValue = pre1))

a1 = add_sub(a1, expression(paste("B=830.24-54.23T+1.08", T^2)), size = 10)
a1 = ggdraw(a1)

model_1a = subset(q_AIC, ID == 841)
data_1a = subset(data, ID == 841)
temp = seq(min(data_1a$ConTemp), max(data_1a$ConTemp), 0.1)
pre1 = model_1a$B0 + model_1a$B1*temp + model_1a$B2*temp^2
a2 = ggplot(data_1a, aes(x = ConTemp, y = OriginalTraitValue)) + geom_point() +
  labs(title = "b", parse = T) +
  xlab("Temperature (T)") +
  ylab("Trait Value (B)") + 
  geom_line(data = data.frame(ConTemp = temp,
                              OriginalTraitValue = pre1))

a2 = add_sub(a2, expression(paste("B=4.28-0.35T+0.0089", T^2)), size = 10)
a2 = ggdraw(a2)

model_1a = subset(c_AIC, ID == 455)
data_1a = subset(data, ID == 455)
temp = seq(min(data_1a$ConTemp), max(data_1a$ConTemp), 0.1)
pre1 = model_1a$B0 + model_1a$B1*temp + model_1a$B2*temp^2 + model_1a$B3*temp^3
a3 = ggplot(data_1a, aes(x = ConTemp, y = OriginalTraitValue)) + geom_point() +
  labs(title = "c", parse = T) +
  xlab("Temperature (T)") +
  ylab("Trait Value (B)") + 
  geom_line(data = data.frame(ConTemp = temp,
                              OriginalTraitValue = pre1))

a3 = add_sub(a3, expression(paste("B=-709.59-133.79T-6.00", T^2, "+0.081", T^3)),
             size = 10)
a3 = ggdraw(a3)

model_1a = subset(c_AIC, ID == 600)
data_1a = subset(data, ID == 600)
temp = seq(min(data_1a$ConTemp), max(data_1a$ConTemp), 0.1)
pre1 = model_1a$B0 + model_1a$B1*temp + model_1a$B2*temp^2 + model_1a$B3*temp^3
a4 = ggplot(data_1a, aes(x = ConTemp, y = OriginalTraitValue)) + geom_point() +
  labs(title = "d", parse = T) +
  xlab("Temperature (T)") +
  ylab("Trait Value (B)") + 
  geom_line(data = data.frame(ConTemp = temp,
                              OriginalTraitValue = pre1))

a4 = add_sub(a4, expression(paste("B=0.080+0.13T-0.0083", T^2, "+0.00017", T^3)),
             size = 10)
a4 = ggdraw(a4)


pdf("../Results/Fig2.pdf")
grid.arrange(a1,a2,a3,a4)
dev.off()
######################################################################

######################################################################
#Figure 2
alpha = data.frame(ID = Q$ID, Model = rep("Quadratic", nrow(Q)), AIC = Q$AIC)
beta = data.frame(ID = C$ID, Model = rep("Cubic", nrow(C)), AIC = C$AIC)
gamma = data.frame(ID = B_AIC$ID, Model = rep("Briere", nrow(B_AIC)), 
                   AIC = B_AIC$AIC)
deta = data.frame(ID = R_AIC$ID, Model = rep("Ratkowsky", nrow(R_AIC)), 
                  AIC = R_AIC$AIC)
p1 = ggplot(data = rbind(alpha, beta, gamma, deta),
       aes(x = ID, y = AIC, colour = Model)) +
  geom_line(size = 0.3)+labs(title = "a")

alpha = data.frame(ID = Q$ID, Model = rep("Quadratic", nrow(Q)), BIC = Q$BIC)
beta = data.frame(ID = C$ID, Model = rep("Cubic", nrow(C)), BIC = C$BIC)
gamma = data.frame(ID = B_BIC$ID, Model = rep("Briere", nrow(B_BIC)), 
                   BIC = B_BIC$BIC)
deta = data.frame(ID = R_BIC$ID, Model = rep("Ratkowsky", nrow(R_BIC)), 
                  BIC = R_BIC$BIC)
p2 = ggplot(data = rbind(alpha, beta, gamma, deta),
            aes(x = ID, y = BIC, colour = Model)) +
  geom_line(size = 0.2) + labs(title = "b")

pdf("../Results/a.pdf")
grid.arrange(p1,p2)
dev.off()
##################################################################

##################################################################
#Figure 4
ID81 = subset(b_AIC, ID == 81)
data_1a = subset(data, ID == 81)
temp = seq(min(data_1a$ConTemp), max(data_1a$ConTemp), 0.1)
pre1 = ID81$B0 * temp * (temp-ID81$T0) * (abs(ID81$Tm-temp))^0.5
p1 = ggplot(data_1a, aes(x = ConTemp, y = OriginalTraitValue)) + geom_point() +
  labs(title = "a") +
  xlab("Temperature (T)") +
  ylab("Trait Value (B)") + 
  geom_line(data = data.frame(ConTemp = temp,
                              OriginalTraitValue = pre1))

p1 = add_sub(p1, expression(paste(T[0],"=-2376.4, ", T[m],"=44.07, ","Briere model")),
             size = 10)
p1 = ggdraw(p1)

ID81 = subset(b_AIC, ID == 215)
data_1a = subset(data, ID == 215)
temp = seq(min(data_1a$ConTemp), max(data_1a$ConTemp), 0.1)
pre1 = ID81$B0 * temp * (temp-ID81$T0) * (abs(ID81$Tm-temp))^0.5
p2 = ggplot(data_1a, aes(x = ConTemp, y = OriginalTraitValue)) + geom_point() +
  labs(title = "b") +
  xlab("Temperature (T)") +
  ylab("Trait Value (B)") + 
  geom_line(data = data.frame(ConTemp = temp,
                              OriginalTraitValue = pre1))

p2 = add_sub(p2, expression(paste(T[0],"=-21.08, ", T[m],"=2037.81, ","Briere model")),
             size = 10)
p2 = ggdraw(p2)

ID81 = subset(r_AIC, ID == 46)
data_1a = subset(data, ID == 46)
temp = seq(min(data_1a$ConTemp), max(data_1a$ConTemp), 0.1)
pre1 = ((ID81$a * (temp - ID81$T0)) * (1 - exp(ID81$b * (temp - ID81$Tm))))^2
p3 = ggplot(data_1a, aes(x = ConTemp, y = OriginalTraitValue)) + geom_point() +
  labs(title = "c") +
  xlab("Temperature (T)") +
  ylab("Trait Value (B)") + 
  geom_line(data = data.frame(ConTemp = temp,
                              OriginalTraitValue = pre1))

p3 = add_sub(p3, expression(paste(T[0],"=-60.29, ", T[m],"=1778.88, ","Ratkowsky model")),
             size = 10)
p3 = ggdraw(p3)

ID81 = subset(r_AIC, ID == 254)
data_1a = subset(data, ID == 254)
temp = seq(min(data_1a$ConTemp), max(data_1a$ConTemp), 0.1)
pre1 = ((ID81$a * (temp - ID81$T0)) * (1 - exp(ID81$b * (temp - ID81$Tm))))^2
p4 = ggplot(data_1a, aes(x = ConTemp, y = OriginalTraitValue)) + geom_point() +
  labs(title = "d") +
  xlab("Temperature (T)") +
  ylab("Trait Value (B)") + 
  geom_line(data = data.frame(ConTemp = temp,
                              OriginalTraitValue = pre1))

p4 = add_sub(p4, expression(paste(T[0],"=-991.45, ", T[m],"=68.19, ","Ratkowsky model")),
             size = 10)
p4 = ggdraw(p4)

pdf("../Results/b.pdf")
grid.arrange(p1,p2,p3,p4)
dev.off()
