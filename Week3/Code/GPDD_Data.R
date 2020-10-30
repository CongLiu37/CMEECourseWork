#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: GPDD.R
#Work Path: CMEECourseWork/Week3
#Dependency: ggplot2, maps
#Input: Data/GPDDFiltered.RData
#Function: Create a world map, 
#          superimposes on the map all the locations 
#          from which there is data in the GPDD dataframe
#Output:
#Usage: Rscript GPDD.R
#Date: Oct, 2020

load("Data/GPDDFiltered.RData")
library(ggplot2)
library(ggmap)
library(sp)
library(maptools)
library(maps)

visit.x<-gpdd$long
visit.y<-gpdd$lat

mp<-NULL
mapworld<-borders("world",colour = "gray50",fill="white")

mp<-ggplot()+mapworld

mp1<-mp + geom_point(aes(x=visit.x,
                       y=visit.y),
                   size = 0.1) +
  scale_size(range=c(1,1))
mp1
#The locations from which there is data are distributed unevenly among the world.
#Most locations are in Europe and North America, especially in United Kingdom
#and western coastal line of America and Canada. One is in Japan, and one in Africa.
#No location in South America and Australia.
#When the data is analysized at global level, areas including South America, Africa, Asia
#and Australia are not represented appropriately, which cause biase.
#When focus on data from North America, most locations are in western coastal line and Canada,
#while other areas are not represented appropriately, resulting in biase.
#When focus on data from Europe, most locations are in United Kingdom, especially
#England and Scotland, while there are seldom locations in other European countries,
#causing biase.
