# CMEE 2020 HPC excercises R code HPC run code proforma

rm(list=ls()) # good practice 
source("/rds/general/user/cl3820/home/HPCtest/cl3820_HPC_2020_main.R")
graphics.off()
iter = as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))

if (iter %in% 1:25){size = 500}
if (iter %in% 26:50){size = 1000}
if (iter %in% 51:75){size = 2500}
if (iter %in% 76:100){size = 5000}
speciation_rate = 0.0047648
wall_time = 11.5*60
filename = paste("/rds/general/user/cl3820/home/HPCtest/ClusterOutput_",
                 iter,".rda", sep = "")
set.seed(iter)
cluster_run(speciation_rate, size, wall_time, interval_rich = 1, 
            interval_oct = size/10, burn_in_generations = 8*size, 
            output_file_name = filename)
