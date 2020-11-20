#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: PP_Dists.R
#Work Path: CMEECourseWork/Week3/Code
#Dependency: ggplot2
#Input: Data/EcolArchives-E089-51-D1.csv
#Function: Plot distributions of predator mass, prey mass, 
#          and the size ratio of prey mass over predator mass 
#          by feeding interaction type. 
#          Calculate the mean and median log predator mass, prey mass, 
#          and predator-prey size ratio, by feeding type
#Output: Results/Pred_Subplots.pdf, 
#        Results/Prey_Subplots.pdf, 
#        Results/SizeRatio_Subplots.pdf
#        Results/PP_Results.csv
#Usage: Rscript PP_Dists.R
#Date: Oct, 2020

rm(list = ls())

data = read.csv("../Data/EcolArchives-E089-51-D1.csv")

log_predator_mass = log(data$Predator.mass)
log_prey_mass = log(data$Prey.mass)
ratio = data$Prey.mass/data$Predator.mass
log_ratio = log(ratio)

TempData = data.frame(data$Type.of.feeding.interaction, 
                      log_predator_mass,
                      log_prey_mass,
                      log_ratio)


library(ggplot2)

#Plots of Predator
pdf("../Results/Pred_Subplots.pdf")
attach(mtcars)
opar = par(no.readonly = T)
par(mfcol=c(2,3))
par(mfg=c(1,1))
hist(subset(TempData,
            TempData$data.Type.of.feeding.interaction == 
              "insectivorous")$log_predator_mass,
     xlab = "log10(Predator Mass (g))",
     ylab = "Count",
     main = "insectivorous")
par(mfg = c(1,2))
hist(subset(TempData,
            TempData$data.Type.of.feeding.interaction == 
              "piscivorous")$log_predator_mass,
     xlab = "log10(Predator Mass (g))",
     ylab = "Count",
     main = "piscivorous")
par(mfg = c(1,3))
hist(subset(TempData,
            TempData$data.Type.of.feeding.interaction == 
              "planktivorous")$log_predator_mass,
     xlab = "log10(Predator Mass (g))",
     ylab = "Count",
     main = "planktivorous")
par(mfg = c(2,1))
hist(subset(TempData,
            TempData$data.Type.of.feeding.interaction == 
              "predacious")$log_predator_mass,
     xlab = "log10(Predator Mass (g))",
     ylab = "Count",
     main = "predacious")
par(mfg = c(2,2))
hist(subset(TempData,
            TempData$data.Type.of.feeding.interaction == 
              "predacious/piscivorous")$log_predator_mass,
     xlab = "log10(Predator Mass (g))",
     ylab = "Count",
     main = "predacious/piscivorous")
dev.off()

#Plots of Prey
pdf("../Results/Prey_Subplots.pdf")
attach(mtcars)
par(mfcol=c(2,3))
par(mfg=c(1,1))
hist(subset(TempData,
            TempData$data.Type.of.feeding.interaction == 
              "insectivorous")$log_prey_mass,
     xlab = "log10(Prey Mass (g))",
     ylab = "Count",
     main = "insectivorous")
par(mfg = c(1,2))
hist(subset(TempData,
            TempData$data.Type.of.feeding.interaction == 
              "piscivorous")$log_prey_mass,
     xlab = "log10(Prey Mass (g))",
     ylab = "Count",
     main = "piscivorous")
par(mfg = c(1,3))
hist(subset(TempData,
            TempData$data.Type.of.feeding.interaction == 
              "planktivorous")$log_prey_mass,
     xlab = "log10(Prey Mass (g))",
     ylab = "Count",
     main = "planktivorous")
par(mfg = c(2,1))
hist(subset(TempData,
            TempData$data.Type.of.feeding.interaction == 
              "predacious")$log_prey_mass,
     xlab = "log10(Prey Mass (g))",
     ylab = "Count",
     main = "predacious")
par(mfg = c(2,2))
hist(subset(TempData,
            TempData$data.Type.of.feeding.interaction == 
              "predacious/piscivorous")$log_prey_mass,
     xlab = "log10(Prey Mass (g))",
     ylab = "Count",
     main = "predacious/piscivorous")
dev.off()

#Plots of Ratio
pdf("../Results/SizeRatio_Subplots.pdf")
attach(mtcars)
par(mfcol=c(2,3))
par(mfg=c(1,1))
hist(subset(TempData,
            TempData$data.Type.of.feeding.interaction == 
              "insectivorous")$log_ratio,
     xlab = "log10(Prey/Predator)",
     ylab = "Count",
     main = "insectivorous")
par(mfg = c(1,2))
hist(subset(TempData,
            TempData$data.Type.of.feeding.interaction == 
              "piscivorous")$log_ratio,
     xlab = "log10(Prey/Predator)",
     ylab = "Count",
     main = "piscivorous")
par(mfg = c(1,3))
hist(subset(TempData,
            TempData$data.Type.of.feeding.interaction == 
              "planktivorous")$log_ratio,
     xlab = "log10(Prey/Predator)",
     ylab = "Count",
     main = "planktivorous")
par(mfg = c(2,1))
hist(subset(TempData,
            TempData$data.Type.of.feeding.interaction == 
              "predacious")$log_ratio,
     xlab = "log10(Prey/Predator)",
     ylab = "Count",
     main = "predacious")
par(mfg = c(2,2))
hist(subset(TempData,
            TempData$data.Type.of.feeding.interaction == 
              "predacious/piscivorous")$log_ratio,
     xlab = "log10(Prey/Predator)",
     ylab = "Count",
     main = "predacious/piscivorous")
dev.off()

ty = names(table(TempData$data.Type.of.feeding.interaction))
insec = subset(TempData,
               TempData$data.Type.of.feeding.interaction == 
                 "insectivorous")
pisci = subset(TempData,
               TempData$data.Type.of.feeding.interaction == 
                 "piscivorous")
plank = subset(TempData,
               TempData$data.Type.of.feeding.interaction == 
                 "planktivorous")
pred = subset(TempData,
              TempData$data.Type.of.feeding.interaction == 
                "predacious")
prepis = subset(TempData,
                 TempData$data.Type.of.feeding.interaction == 
                   "predacious/piscivorous")
log_Prey_means = c(mean(insec$log_prey_mass),
               mean(pisci$log_prey_mass),
               mean(plank$log_prey_mass),
               mean(pred$log_prey_mass),
               mean(prepis$log_prey_mass))
log_Prey_medians = c(median(insec$log_prey_mass),
                 median(pisci$log_prey_mass),
                 median(plank$log_prey_mass),
                 median(pred$log_prey_mass),
                 median(prepis$log_prey_mass))
log_Predator_means = c(mean(insec$log_predator_mass),
               mean(pisci$log_predator_mass),
               mean(plank$log_predator_mass),
               mean(pred$log_predator_mass),
               mean(prepis$log_predator_mass))
log_Predator_medians = c(median(insec$log_predator_mass),
                 median(pisci$log_predator_mass),
                 median(plank$log_predator_mass),
                 median(pred$log_predator_mass),
                 median(prepis$log_predator_mass))
log_ratio_means = c(mean(insec$log_ratio),
                   mean(pisci$log_ratio),
                   mean(plank$log_ratio),
                   mean(pred$log_ratio),
                   mean(prepis$log_ratio))
log_ratio_medians = c(median(insec$log_ratio),
                 median(pisci$log_ratio),
                 median(plank$log_ratio),
                 median(pred$log_ratio),
                 median(prepis$log_ratio))

re = data.frame(type = ty,log_Prey_means, log_Prey_medians,
                log_Predator_means, log_Predator_medians,
                log_ratio_means,log_ratio_medians)

write.csv(re, "../Results/PP_Results.csv", row.names = F)
