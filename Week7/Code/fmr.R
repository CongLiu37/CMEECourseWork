#Language: R 4.0.3
#Author: Cong Liu (cong.liu20@imperial.ac.uk)
#Work Path: CMEECourseWork/Week7/Code
#Dependencies:
#Input: ../Data/NagyEtAl1999.csv
#Function: Plots log(field metabolic rate) against log(body mass) for the Nagy et al 
#          1999 dataset to a file fmr.pdf.
#Output: ../Results/fmr_plot.pdf
#Usage: Rscript fmr.R
#Date: Nov, 2020


# Plots log(field metabolic rate) against log(body mass) for the Nagy et al 
# 1999 dataset to a file fmr.pdf.

cat("Reading CSV\n")

#Import files
nagy <- read.csv('../Data/NagyEtAl1999.csv', stringsAsFactors = FALSE)

cat("Creating graph\n")

#Plot
pdf('../Results/fmr_plot.pdf', 11, 8.5)
col <- c(Aves='purple3', Mammalia='red3', Reptilia='green3')
plot(log10(nagy$M.g), log10(nagy$FMR.kJ.day.1), pch=19, col=col[nagy$Class], 
     xlab=~log[10](M), ylab=~log[10](FMR))
for(class in unique(nagy$Class)){
    model <- lm(log10(FMR.kJ.day.1) ~ log10(M.g), data=nagy[nagy$Class==class,])
    abline(model, col=col[class])
}
dev.off()

cat("Finished in R!\n")
