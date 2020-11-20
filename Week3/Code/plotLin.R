#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: plotLin.R
#Work Path: CMEECourseWork/Week3/Code
#Dependency: ggplot2
#Input:
#Function: Plot linear regression data
#Output: Results/MyLinReg.pdf
#Usage: Rscript plotLin.R
#Date: Oct, 2020

library(ggplot2)

x <- seq(0, 100, by = 0.1)
y <- -4. + 0.25 * x +
  rnorm(length(x), mean = 0., sd = 2.5)

# and put them in a dataframe
my_data <- data.frame(x = x, y = y)

# perform a linear regression
my_lm <- summary(lm(y ~ x, data = my_data))

pdf("../Results/MyLinReg.pdf")
# plot the data
p <-  ggplot(my_data, aes(x = x, y = y,
                          colour = abs(my_lm$residual))
) +
  geom_point() +
  scale_colour_gradient(low = "black", high = "red") +
  theme(legend.position = "none")

# add the regression line
p <- p + geom_abline(
  intercept = my_lm$coefficients[1][1],
  slope = my_lm$coefficients[2][1],
  colour = "red")
# throw some math on the plot
p <- p + geom_text(aes(x = 60, y = 0,
                       label = "y==0.25*x-4"), 
                   parse = TRUE, size = 6, 
                   colour = "blue")
lab = paste("R^2==", my_lm$adj.r.squared, sep = "")
p <- p + geom_text(aes(x = 60, y = -1.5,
                       label = lab),
                   parse = T, size = 6,
                   colour = "blue")
p
dev.off()

