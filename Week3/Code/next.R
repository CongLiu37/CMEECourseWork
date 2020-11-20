#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: next.R
#Work Path: CMEECourseWork/Week3/Code
#Input:
#Function: Illustrate skipping to next iteration of a loop
#Output:
#Usage: Rscript next.R
#Date: Oct, 2020

for (i in 1:10) {
  if ((i %% 2) == 0) # check if the number is odd
    next # pass to next iteration of loop 
  print(i)
}
