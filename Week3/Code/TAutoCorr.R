#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: TAutoCorr.R
#Work Directory: CMEECourseWork/Week3
#Dependency: ggplot2
#Input: Data/KeyWestAnnualMeanTemperature.RData
#Function: Test autocorrelation of each year's temperature 
#Output: TAutoCorr_Figure1.pdf
#Usage:
#Date: Oct, 2020

setwd("CMEECourseWork/Week3")
load("Data/KeyWestAnnualMeanTemperature.RData") #Import data
setwd("Code")

library(ggplot2)

pdf("TAutoCorr_Figure1.pdf")
p0 = ggplot(data = ats, aes(x = Year, y = Temp)) + #Plot temperatures 
  geom_point(size = 0.5) + #Adjust point size
  labs(x = "Year",
       y = "Temperature") + #Set titles for the plot, x axis and y axis
  theme(plot.title  = element_text(size = 10, hjust = 0.5), #Adjust word size of title and put it in the center
        axis.title.x = element_text(size = 10), #Adjust word size of x axis title
        axis.title.y = element_text(size = 10)) #Adjust word size of y axis title
p0
dev.off()

yr0 = ats$Temp[1:99]
yr1 = ats$Temp[2:100]
autoco = cor(yr0,yr1)
autoco

#Simulation
corrs = rep(NA, 10000)
for (i in 1:10000) {
  yr = sample(ats$Temp, size = 100, replace = F)
  yr0 = yr[1:99]
  yr1 = yr[2:100]
  corrs[i] = cor(yr0, yr1)
}
corrs

#Approximate p-value
j = 0
for (corr in corrs) {
  if (abs(corr) > abs(autoco)) {
    j = j + 1
  }
}
j/10000
