#Language: R 4.0.3
#Author: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/MiniProject/Code
#Dependency: ggplot2 
#Input:  ../Results/bestAIC_quadratic.csv
#        ../Results/bestBIC_quadratic.csv
#        ../Results/bestAIC_cubic.csv
#        ../Results/bestBIC_cubic.csv
#        ../Results/bestAIC_Briere.csv
#        ../Results/bestBIC_Briere.csv
#        ../Results/bestAIC_Ratkowsky.csv
#        ../Results/bestBIC_Ratkowsky.csv
#        ../Results/filtered_data.csv
#Function: Plot best model of each curve under either AIC or BIC.
#Output: ../Results/AIC_bestmodels.pdf (AIC-selected)
#        ../Results/BIC_bestmodels.pdf (BIC-selected)
#Usage: Rscript PlotBestModels.R
#Date: Nov, 2020
rm(list = ls())
library(ggplot2)

#Import models
q_AIC = read.csv("../Results/bestAIC_quadratic.csv", header = T)
c_AIC = read.csv("../Results/bestAIC_cubic.csv", header = T)
b_AIC = read.csv("../Results/bestAIC_Briere.csv", header = T)
r_AIC = read.csv("../Results/bestAIC_Ratkowsky.csv", header = T)

q_BIC = read.csv("../Results/bestBIC_quadratic.csv", header = T)
c_BIC = read.csv("../Results/bestBIC_cubic.csv", header = T)
b_BIC = read.csv("../Results/bestBIC_Briere.csv", header = T)
r_BIC = read.csv("../Results/bestBIC_Ratkowsky.csv", header = T)

data = read.csv("../Results/filtered_data.csv", header = T)

#Plotting
pdf("../Results/AIC_bestmodels.pdf")
for (i in 1:903){
  modq = subset(q_AIC, ID == i)
  modc = subset(c_AIC, ID == i)
  modb = subset(b_AIC, ID == i)
  modr = subset(r_AIC, ID == i)
  d = subset(data, ID == i)
  temp = seq(min(d$ConTemp), max(d$ConTemp), 0.1)
  
  p = ggplot(d, aes(x = ConTemp, y = OriginalTraitValue)) + geom_point() +
    labs(title = paste("ID:", as.character(i))) +
    xlab("Temperature") +
    ylab("Trait Value") +
    theme(plot.title = element_text(hjust = 0.5))
  
  pre1 = data.frame()
  if (nrow(modq) != 0){
    pre1 = modq$B0 + modq$B1*temp + modq$B2*temp^2
    pre1 = data.frame(Model = rep("Quadratic", length(temp)),
                      ConTemp = temp,
                      OriginalTraitValue = pre1)}
  pre2 = data.frame()
  if (nrow(modc) != 0){
    pre2 = modc$B0 + modc$B1*temp + modc$B2*temp^2 + modc$B3*temp^3
    pre2 = data.frame(Model = rep("Cubic", length(temp)),
                      ConTemp = temp,
                      OriginalTraitValue = pre2)}
  pre3 = data.frame()
  if (nrow(modb) != 0){
    pre3 = as.numeric(modb$B0) * temp * (temp-as.numeric(modb$T0)) * (abs(as.numeric(modb$Tm)-temp))^0.5
    pre3 = data.frame(Model = rep("Briere", length(pre3)),
                      ConTemp = temp,
                      OriginalTraitValue = pre3)}
  pre4 = data.frame()
  if (nrow(modr) != 0){
    pre4 = ((as.numeric(modr$a) * (temp - as.numeric(modr$T0))) * (1 - exp(as.numeric(modr$b) * (temp - as.numeric(modr$Tm)))))^2
    pre4 = data.frame(Model = rep("Ratkowsky", length(temp)),
                      ConTemp = temp,
                      OriginalTraitValue = pre4)}
  p = p + geom_line(data = rbind(pre1, pre2, pre3, pre4), 
                    aes(x = ConTemp, y = OriginalTraitValue, colour = Model))
  print(p)
}
dev.off()

pdf("../Results/BIC_bestmodels.pdf")
for (i in 1:903){
  modq = subset(q_BIC, ID == i)
  modc = subset(c_BIC, ID == i)
  modb = subset(b_BIC, ID == i)
  modr = subset(r_BIC, ID == i)
  d = subset(data, ID == i)
  temp = seq(min(d$ConTemp), max(d$ConTemp), 0.1)
  
  p = ggplot(d, aes(x = ConTemp, y = OriginalTraitValue)) + geom_point() +
    labs(title = paste("ID:", as.character(i))) +
    xlab("Temperature") +
    ylab("Trait Value") +
    theme(plot.title = element_text(hjust = 0.5))
  pre1 = data.frame()
  if (nrow(modq) != 0){
    pre1 = modq$B0 + modq$B1*temp + modq$B2*temp^2
    pre1 = data.frame(Model = rep("Quadratic", length(temp)),
                      ConTemp = temp,
                      OriginalTraitValue = pre1)}
  pre2 = data.frame()
  if (nrow(modc) != 0){
    pre2 = modc$B0 + modc$B1*temp + modc$B2*temp^2 + modc$B3*temp^3
    pre2 = data.frame(Model = rep("Cubic", length(temp)),
                      ConTemp = temp,
                      OriginalTraitValue = pre2)}
  pre3 = data.frame()
  if (nrow(modb) != 0){
    pre3 = as.numeric(modb$B0) * temp * (temp-as.numeric(modb$T0)) * (abs(as.numeric(modb$Tm)-temp))^0.5
    pre3 = data.frame(Model = rep("Briere", length(pre3)),
                      ConTemp = temp,
                      OriginalTraitValue = pre3)}
  pre4 = data.frame()
  if (nrow(modr) != 0){
    pre4 = ((as.numeric(modr$a) * (temp - as.numeric(modr$T0))) * (1 - exp(as.numeric(modr$b) * (temp - as.numeric(modr$Tm)))))^2
    pre4 = data.frame(Model = rep("Ratkowsky", length(temp)),
                      ConTemp = temp,
                      OriginalTraitValue = pre4)}
  p = p + geom_line(data = rbind(pre1, pre2, pre3, pre4), 
                    aes(x = ConTemp, y = OriginalTraitValue, colour = Model))
  print(p)
}
dev.off()
