#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: PP_Regress.R
#Work Path: CMEECourseWork/Week3/Code
#Dependency: ggplot2, scales, broom
#Input: Data/EcolArchives-E089-51-D1.csv
#Function: Regress prey mass and predator mass for each 
#          Feeding Type+Predator life Stage combination and
#          save results in Results/PP_Regress_Results.csv.
#          For each combination, if it has only two sample poits or 
#          there is no correlation (R-square = 0), it will not be saved in csv file.
#          Plot the regression, saved as Results/PP_Regress_Results.pdf
#Output: Results/PP_Regress_Results.pdf 
#        Results/PP_Regress_Results.csv
#Usage: Rscript PP_Regress.R
#Date: Oct, 2020

rm(list = ls())

#Import data
data = read.csv("../Data/EcolArchives-E089-51-D1.csv")

#Convert unit of mass
for (i in 1:nrow(data)){
  if (data$Prey.mass.unit[i] == "mg"){
    data$Prey.mass.unit[i] = "g"
    data$Predator.mass[i] = data$Predator.mass[i] / 1000
  }
}

FeedType = names(table(data$Type.of.feeding.interaction))
PredatorStage = names(table(data$Predator.lifestage))

RegTitle = c("slope", "intercept", "R^2","adjusted-R^2", 
             "F-statistic", "p-value")

library(broom)
#Summary of linear model
lmSum = function(a,b){
  c = rep(NA, 6)
  mol = lm(a~b)
  sum = unlist(summary(mol))
  c[1] = sum$coefficients2
  c[2] = sum$coefficients1
  c[3] = sum$r.squared
  c[4] = sum$adj.r.square
  c[5] = sum$fstatistic.value
  c[6] = unname(glance(mol)$p.value)
  return(c)
}

Reg = data.frame(RegTitle)
n = names(Reg)
k = 2
#Regression
for (i in FeedType){
  for (j in PredatorStage){
    d = subset(data,
               data$Type.of.feeding.interaction == i &
                 data$Predator.lifestage == j)
    if (nrow(d) > 2){
      n[k] = paste(i,"_",j,sep = "")
      k = k + 1
      a = lmSum(log(d$Prey.mass), log(d$Predator.mass))
      Reg = cbind(Reg, a)
    names(Reg) = n
    }
  }
}

write.csv(Reg,"../Results/PP_Regress_Results.csv",row.names = F)

#Picture

library(scales)
library(ggplot2)

pdf("../Results/PP_Regress_Results.pdf")

ggplot(data, aes(x = Prey.mass, 
                 y = Predator.mass, 
                 colour = Predator.lifestage)) +
  geom_point(size = 0.5, shape = 3) +
  facet_grid(Type.of.feeding.interaction ~ .) + #Divide figure horizontally
  theme(strip.text.y = element_text(size = 6)) + #Adjust size of tags of y
  scale_y_continuous(trans = "log10") + #Show y in form of log10
  scale_x_continuous(trans = "log10") + #show x in form of log10
  stat_smooth(method = lm, fullrange = T, level = 0.95,size = 0.5)+ #Draw regression curve
  xlab("Prey Mass in grams") +
  ylab("Predator Mass in grams") +
  theme(legend.position = "bottom",
        legend.title = element_text(size = 10),
        legend.key.size = unit("5", "pt"))

dev.off()
