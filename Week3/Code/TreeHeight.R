#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: TreeHeight.R
#Work Path: CMEECourseWork/Week3/Code
#Input: Data/trees.csv
#Function: Calculate heights of trees given distance of each tree 
#          from its base and angle to its top, using  the trigonometric formula 
#Output: Results/TreeHts.csv
#Usage: Rscript TreeHeight.R
#Date: Oct, 2020

# Calculate heights of trees
# height = distance * tan(radians)
# ARGUMENTS
# degrees: The angle of elevation of tree
# distance: The distance from base of tree (e.g., meters)
# OUTPUT
# The heights of the tree, same units as "distance"
TreeHeight <- function(degrees, distance){
  radians <- degrees * pi / 180
  height <- distance * tan(radians)
  print(paste("Tree height is:", height))
  
  return (height)
}

data = read.csv("../Data/trees.csv", header = T)
a = nrow(data)
head(data)

Tree.Height.m = c()
for ( i in 1:a ){
  distance = as.numeric(data$Distance.m[i])
  degree = as.numeric(data$Angle.degrees[i])
  height = TreeHeight(degree, distance)
  Tree.Height.m[i] = height 
}

data_more = data.frame(data, Tree.Height.m)
head(data_more)
write.csv(data_more, "../Results/TreeHts.csv", row.names = F)

