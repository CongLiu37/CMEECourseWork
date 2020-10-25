#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: apply1.R
#Work Path: CMEECourseWork/Week3
#Input:
#Function: Exemplify the usage of *apply functions
#Output:
#Usage: Rscript apply1.R
#Date: Oct, 2020

## Build a random matrix
M <- matrix(rnorm(100), 10, 10)

## Take the mean of each row
RowMeans <- apply(M, 1, mean)
print (RowMeans)

## Now the variance
RowVars <- apply(M, 1, var)
print (RowVars)

## By column
ColMeans <- apply(M, 2, mean)
print (ColMeans)
