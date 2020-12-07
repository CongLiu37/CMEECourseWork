#Language: R 4.0.3
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: StatisticsResults.R
#Work Path: CMEECourseWork/MiniProject/Code
#Dependency:
#Input: ../Results/move_curves.csv
#       ../Results/Briere_model.csv
#       ../Results/Ratkowsky_model.csv
#       ../Results/bestAIC_quadratic.csv
#       ../Results/bestAIC_cubic.csv
#       ../Results/bestAIC_Briere.csv
#       ../Results/bestAIC_Ratkowsky.csv
#       ../Results/bestBIC_quadratic.csv
#       ../Results/bestBIC_cubic.csv
#       ../Results/bestBIC_Briere.csv
#       ../Results/bestBIC_Ratkowsky.csv
#Function: Do something statistical to the results of model fitting and selection.
#Output: 
#Usage: Rscript StatisticsResults.R
#Date: Nov, 2020

rm(list = ls())

rescale = read.csv("../Results/move_curves.csv", header = T)

p1 = paste(nrow(subset(rescale, minus == 0)), "curves have no negative trait value")
print(p1)

IDs = subset(rescale, minus == 0)$ID

briere = read.csv("../Results/Briere_model.csv", header = T)
briere_positive = subset(briere, briere$X %in% IDs)
p2 = paste(length(table(briere_positive$X)), "of 841 curves can be fitted by Briere function")
print(p2)

ratkowsky = read.csv("../Results/Ratkowsky_model.csv", header = T)
ratkowsky_positive = subset(ratkowsky, X %in% IDs)
p3 = paste(length(table(ratkowsky_positive$X)), "of 841 curves can be fitted by Ratkowsky function")
print(p3)

print("When AIC is used for model selection:")
q_AIC = subset(read.csv("../Results/bestAIC_quadratic.csv", header = T),
               ID %in% IDs)
c_AIC = subset(read.csv("../Results/bestAIC_cubic.csv", header = T),
               ID %in% IDs)
b_AIC = subset(read.csv("../Results/bestAIC_Briere.csv", header = T),
               ID %in% IDs)
r_AIC = subset(read.csv("../Results/bestAIC_Ratkowsky.csv", header = T),
               ID %in% IDs)
p4 = paste(length(table(q_AIC$ID)), "curves are best fitted by quadratic polynomial function")
print(p4)
p5 = paste(length(table(c_AIC$ID)), "curves are best fitted by cubic polynomial function")
print(p5)
p6 = paste(length(table(b_AIC$ID)), "curves are best fitted by Briere function")
print(p6)
p7 = paste(length(table(r_AIC$ID)), "curves are best fitted by Ratkowsky function")
print(p7)

print("When BIC is used for model selection:")
q_BIC = subset(read.csv("../Results/bestBIC_quadratic.csv", header = T),
               ID %in% IDs)
c_BIC = subset(read.csv("../Results/bestBIC_cubic.csv", header = T),
               ID %in% IDs)
b_BIC = subset(read.csv("../Results/bestBIC_Briere.csv", header = T),
               ID %in% IDs)
r_BIC = subset(read.csv("../Results/bestBIC_Ratkowsky.csv", header = T),
               ID %in% IDs)
p8 = paste(length(table(q_BIC$ID)), "curves are best fitted by quadratic polynomial function")
print(p8)
p9 = paste(length(table(c_BIC$ID)), "curves are best fitted by cubic polynomial function")
print(p9)
p10 = paste(length(table(b_BIC$ID)), "curves are best fitted by Briere function")
print(p10)
p11 = paste(length(table(r_BIC$ID)), "curves are best fitted by Ratkowsky function")
print(p11)

if(length(intersect(q_AIC$ID,b_AIC$ID)) == 0 &
   length(intersect(q_AIC$ID,c_AIC$ID)) == 0 &
   length(intersect(q_AIC$ID,r_AIC$ID)) == 0 &
   length(intersect(c_AIC$ID,b_AIC$ID)) == 0 &
   length(intersect(c_AIC$ID,r_AIC$ID)) == 0 &
   length(intersect(b_AIC$ID,r_AIC$ID)) == 0){
  print("No curve has best models from multiple categories of functions when AIC is used as criterion")
}

if(length(intersect(q_BIC$ID,b_BIC$ID)) == 0 &
   length(intersect(q_BIC$ID,c_BIC$ID)) == 0 &
   length(intersect(q_BIC$ID,r_BIC$ID)) == 0 &
   length(intersect(c_BIC$ID,b_BIC$ID)) == 0 &
   length(intersect(c_BIC$ID,r_BIC$ID)) == 0 &
   length(intersect(b_BIC$ID,r_BIC$ID)) == 0){
  print("No curve has best models from multiple categories of functions when BIC is used as criterion")
}

mod = data.frame(ID = 1:903,
                 bestAIC = rep(NA,903),
                 bestBIC = rep(NA,903))
for (i in IDs){
  if (i %in% q_AIC$ID){mod[i,2] = "quadratic"}
  if (i %in% c_AIC$ID){mod[i,2] = "cubic"}
  if (i %in% b_AIC$ID){mod[i,2] = "Briere"}
  if (i %in% r_AIC$ID){mod[i,2] = "Ratkowsky"}
  
  if (i %in% q_BIC$ID){mod[i,3] = "quadratic"}
  if (i %in% c_BIC$ID){mod[i,3] = "cubic"}
  if (i %in% b_BIC$ID){mod[i,3] = "Briere"}
  if (i %in% r_BIC$ID){mod[i,3] = "Ratkowsky"}
}

data = read.csv("../Data/ThermRespData.csv")
a = subset(mod, bestAIC != bestBIC)

p12 = paste(nrow(a), "curves are best fitted by different functions when different criterion",
            "of model selection is used")
print(p12)
print(a)
write.csv(a, "../Results/a.csv", row.names = F)




Metabolic = rep(NA, 903)
Hab =  rep(NA, 903)
for (i in 1:903){
  d = subset(data, ID == i)
  Metabolic[i] = d$StandardisedTraitName[1]
  Hab[i] = d$Habitat[1]
}

mod = cbind(mod, Metabolic = Metabolic, Habitat = Hab)
mod = mod[!is.na(mod$bestAIC),]
mod = subset(mod, bestAIC == bestBIC)


print("For gross photosynthesis rate")
table(subset(mod, Metabolic == "gross photosynthesis rate")$bestAIC)
print("For net photosynthesis rate")
table(subset(mod, Metabolic == "net photosynthesis rate")$bestAIC)
print("For respiration rate")
table(subset(mod, Metabolic == "respiration rate")$bestAIC)

print("For species living in terrestrial habitat")
table(subset(mod,Habitat == "terrestrial")$bestAIC)
print("For species living in non-terrestrial habitat")
table(subset(mod,Habitat != "terrestrial")$bestAIC)
