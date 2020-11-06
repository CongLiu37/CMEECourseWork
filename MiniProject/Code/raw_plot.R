rm(list = ls())

data = read.csv("Data/ThermRespData.csv")

T0 = rep(NA,903)
Tm = rep(NA,903)
Trait_T0 = rep(NA,903)
Trait_Tm = rep(NA,903)
for (i in 1:903){
  d = subset(data, ID == i)
  T0[i] = min(d$ConTemp)
  Tm[i] = max(d$ConTemp)
  Trait_T0[i] = mean(subset(d, ConTemp == T0[i])$OriginalTraitValue)
  Trait_Tm[i] = mean(subset(d, ConTemp == Tm[i])$OriginalTraitValue)
}


plot(density(T0))
plot(density(Tm))
density(T0)
density(Tm)

plot(density(sort(data$OriginalTraitValue)[400:900]))

hist(T0,breaks = 1000)
hist(Tm,breaks = 1000)

hist(Trait_T0, breaks = 1000)
hist(Trait_Tm, breaks = 1000)
