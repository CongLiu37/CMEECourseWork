#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: control_flow.R
#Work Path: CMEECourseWork/Week3/Code
#Input:
#Function: Illustrate R control flow tools 
#Output:
#Usage: Rscript control_flow.R
#Date: Oct, 2020

a <- TRUE
if (a == TRUE){
  print ("a is TRUE")
} else {
  print ("a is FALSE")
}

z <- runif(1) ## Generate a uniformly distributed random number
if (z <= 0.5) {print ("Less than a half")}

z <- runif(1)
if (z <= 0.5) {
  print ("Less than a half")
}

for (i in 1:10){
  j <- i * i
  print(paste(i, " squared is", j ))
}

for(species in c('Heliodoxa rubinoides', 
                 'Boissonneaua jardini', 
                 'Sula nebouxii')){
  print(paste('The species is', species))
}

v1 <- c("a","bc","def")
for (i in v1){
  print(i)
}

i <- 0
while (i < 10){
  i <- i+1
  print(i^2)
}

