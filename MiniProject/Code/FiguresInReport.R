

rm(list = ls())
library(ggplot2)
library(gridExtra)

rescale = read.csv("../Results/move_curves.csv", header = T)
IDs = subset(rescale, minus == 0)$ID

data = read.csv("../Results/filtered_data.csv", header = T)

b_AIC = subset(read.csv("../Results/bestAIC_Briere.csv", header = T),
               ID %in% IDs)
r_AIC = subset(read.csv("../Results/bestAIC_Ratkowsky.csv", header = T),
               ID %in% IDs)
b_BIC = subset(read.csv("../Results/bestBIC_Briere.csv", header = T),
               ID %in% IDs)
r_BIC = subset(read.csv("../Results/bestBIC_Ratkowsky.csv", header = T),
               ID %in% IDs)


model_1a = subset(r_AIC, ID == 294)
data_1a = subset(data, ID == 294)
temp = seq(min(data_1a$ConTemp), max(data_1a$ConTemp), 0.1)
a = ggplot(data_1a, aes(x = ConTemp, y = OriginalTraitValue)) + geom_point() +
  labs(title = "a") +
  xlab("Temperature") +
  ylab("Trait Value")
for (j in 1:nrow(model_1a)){
  pre = ((as.numeric(model_1a$a[j]) * (temp - as.numeric(model_1a$T0[j]))) * (1 - exp(as.numeric(model_1a$b[j]) * (temp - as.numeric(model_1a$Tm[j])))))^2
  a = a + geom_line(data = data.frame(ConTemp = temp, OriginalTraitValue = pre),
                    aes(x = ConTemp, y = OriginalTraitValue))}
v1 = paste(nrow(model_1a), "combinations of parameters are used, ID: 294, Criterion: AIC")
print(v1)


model_2a = subset(r_AIC, ID == 372)
data_2a = subset(data, ID == 372)
temp = seq(min(data_2a$ConTemp), max(data_2a$ConTemp), 0.1)
b = ggplot(data_2a, aes(x = ConTemp, y = OriginalTraitValue)) + geom_point() +
  labs(title = "b") +
  xlab("Temperature") +
  ylab("Trait Value")
for (j in 1:nrow(model_2a)){
  pre = ((as.numeric(model_2a$a[j]) * (temp - as.numeric(model_2a$T0[j]))) * (1 - exp(as.numeric(model_2a$b[j]) * (temp - as.numeric(model_2a$Tm[j])))))^2
  b = b + geom_line(data = data.frame(ConTemp = temp, OriginalTraitValue = pre),
                    aes(x = ConTemp, y = OriginalTraitValue))}
v2 = paste(nrow(model_2a), "combinations of parameters are used. ID: 372, Criterion: AIC")
print(v2)


model_1b = subset(r_BIC, ID == 22)
data_1b = subset(data, ID == 22)
temp = seq(min(data_1b$ConTemp), max(data_1b$ConTemp), 0.1)
c = ggplot(data_1b, aes(x = ConTemp, y = OriginalTraitValue)) + geom_point() +
  labs(title = "c") +
  xlab("Temperature") +
  ylab("Trait Value")
for (j in 1:nrow(model_1b)){
  pre = ((as.numeric(model_1b$a[j]) * (temp - as.numeric(model_1b$T0[j]))) * (1 - exp(as.numeric(model_1b$b[j]) * (temp - as.numeric(model_1b$Tm[j])))))^2
  c = c + geom_line(data = data.frame(ConTemp = temp, OriginalTraitValue = pre),
                    aes(x = ConTemp, y = OriginalTraitValue))}
v3 = paste(nrow(model_1b), "combinations of parameters are used, ID: 22, Criterion: BIC")
print(v3)


model_2b = subset(r_BIC, ID == 682)
data_2b = subset(data, ID == 682)
temp = seq(min(data_2b$ConTemp), max(data_2b$ConTemp), 0.1)
d = ggplot(data_2b, aes(x = ConTemp, y = OriginalTraitValue)) + geom_point() +
  labs(title = "d") +
  xlab("Temperature") +
  ylab("Trait Value")
for (j in 1:nrow(model_2b)){
  pre = ((as.numeric(model_2b$a[j]) * (temp - as.numeric(model_2b$T0[j]))) * (1 - exp(as.numeric(model_2b$b[j]) * (temp - as.numeric(model_2b$Tm[j])))))^2
  d = d + geom_line(data = data.frame(ConTemp = temp, OriginalTraitValue = pre),
                    aes(x = ConTemp, y = OriginalTraitValue))}
v4 = paste(nrow(model_2b), "combinations of parameters are used, ID: 22, Criterion: BIC")
print(v4)


pdf("../Results/Fig1.pdf")
grid.arrange(a,b,c,d)
dev.off()
