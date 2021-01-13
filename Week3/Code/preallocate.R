#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: preallocate.R
#Work Path: CMEECourseWork/Week3/Code
#Input:
#Function: Illustrate the effect of pre-allocation in computing efficiency
#Output:
#Usage: Rscript preallocate.R
#Date: Oct, 2020

NoPreallocFun <- function(x){
  a <- vector() # empty vector
  for (i in 1:x) {
    a <- c(a, i)
    print(a)
    print(object.size(a))
  }
}
#Run-time without preallocation
system.time(NoPreallocFun(10))


PreallocFun <- function(x){
  a <- rep(NA, x) # pre-allocated vector
  for (i in 1:x) {
    a[i] <- i
    print(a)
    print(object.size(a))
  }
}
#Run-time with preallocation
system.time(PreallocFun(10))
