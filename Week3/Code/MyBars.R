#Language: R
#Auther: Cong Liu (cong.liu20@imperial.ac.uk)
#Script: MyBars.R
#Work Path: CMEECourseWork/Week3/Code
#Dependency: ggplot2
#Input: Data/Results.txt
#Function: Exemplify annotating a plot
#Output: Results/MyBars.pdf
#Usage: Rscript MyBars.R
#Date: Oct, 2020

library("ggplot2")
a <- read.table("../Data/Results.txt", header = TRUE)
head(a)

a$ymin <- rep(0, dim(a)[1]) # append a column of zeros

pdf("../Results/MyBars.pdf")

# Print the first linerange
p <- ggplot(a)
p <- p + geom_linerange(data = a, aes(
  x = x,
  ymin = ymin,
  ymax = y1,
  size = (0.5)
),
colour = "#E69F00",
alpha = 1/2, show.legend = FALSE)

# Print the second linerange
p <- p + geom_linerange(data = a, aes(
  x = x,
  ymin = ymin,
  ymax = y2,
  size = (0.5)
),
colour = "#56B4E9",
alpha = 1/2, show.legend = FALSE)

# Print the third linerange:
p <- p + geom_linerange(data = a, aes(
  x = x,
  ymin = ymin,
  ymax = y3,
  size = (0.5)
),
colour = "#D55E00",
alpha = 1/2, show.legend = FALSE)

# Annotate the plot with labels:
p <- p + geom_text(data = a, aes(x = x, y = -500, label = Label))

# now set the axis labels, remove the legend, and prepare for bw printing
p <- p + scale_x_continuous("My x axis",
                            breaks = seq(3, 5, by = 0.05)) + 
  scale_y_continuous("My y axis") + 
  theme_bw() + 
  theme(legend.position = "none") 
p


dev.off()
