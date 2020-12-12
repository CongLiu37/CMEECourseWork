#!/bin/bash
#PBS -l walltime=12:00:00
#PBS -l select=1:ncpus=1:mem=1gb
module load anaconda3/personal
echo "R is about to run"
Rscript --vanilla /rds/general/user/cl3820/home/HPCtest/cl3820_HPC_2020_cluster.R
echo "R has finished running" 