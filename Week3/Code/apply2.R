#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: apply2.R
#Work Path: CMEECourseWork/Week3/Code
#Input:
#Function: Exemplify the usage of *apply functions
#Output:
#Usage: Rscript apply2.R
#Date: Oct, 2020

SomeOperation <- function(v){
  if (sum(v) > 0){
    return (v * 100)
  }
  return (v)
}

M <- matrix(rnorm(100), 10, 10)
print (apply(M, 1, SomeOperation))
