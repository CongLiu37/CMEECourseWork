#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: break.R
#Work Path: CMEECourseWork/Week3
#Input:
#Function: Illustrate breaking out of loops 
#Output:
#Usage: Rscript break.R
#Date: Oct, 2020

i <- 0 #Initialize i
while(i < Inf) {
  if (i == 10) {
    break 
  } # Break out of the while loop! 
  else { 
    cat("i equals " , i , " \n")
    i <- i + 1 # Update i
  }
}
