# CMEE 2020 HPC excercises R code HPC run code proforma

rm(list=ls()) # good practice in this instance
source("CongLiu37/CongLiu37_HPC_2020_main.R")
# it should take a faction of a second to source your file
# if it takes longer you're using the main file to do actual simulations
# it should be used only for defining functions that will be useful for your cluster run and which will be marked automatically

# do what you like here to test your functions (this won't be marked)
# for example
species_richness(c(1,4,4,5,1,6,1))
# should return 4 when you've written the function correctly for question 1

# you may also like to use this file for playing around and debugging
# but please make sure it's all tidied up by the time it's made its way into the main.R file or other files.

init_community_max(7)
#should return a vector {1 2 3 4 5 6 7}

init_community_min(4)
#should return a vector {1 1 1 1}

#Test
species_richness(init_community_min(100))
species_richness(init_community_max(100))

choose_two(4)
#should return one of the following vectors:
#{1 2}, {1 3}, {1 4}, {2 1}, {2 3}, {2 4}, {3 1}, {3 2}, {3 4}, {4 1}, {4 2}, {4 3}

neutral_step(c(10,5,13))
