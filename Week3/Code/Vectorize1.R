#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: Vectoriza1.R
#Work Path: CMEECourseWork/Week3
#Input:
#Function: Exemplify vectorization's effect in computing efficiency and low speed of loops
#Output:
#Usage: Rscript Vectorize1.R
#Date: Oct, 2020

M <- matrix(runif(1000000),1000,1000)
dim(M)
SumAllElements <- function(M){
  Dimensions <- dim(M)
  Tot <- 0
  for (i in 1:Dimensions[1]){
    for (j in 1:Dimensions[2]){
      Tot <- Tot + M[i,j]
    }
  }
  return (Tot)
}

print("Using loops, the time taken by Vectorize1.R is:")
print(system.time(SumAllElements(M)))

print("Using the in-built vectorized function, the time taken by Vectorize1.R is:")
print(system.time(sum(M)))
