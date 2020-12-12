# CMEE 2020 HPC excercises R code HPC run code proforma

rm(list=ls()) # good practice in this instance
source("cl3820/cl3820_HPC_2020_main.R")
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

neutral_generation(c(1,2,3,1,2,3,1,2,3))
neutral_time_series(community = init_community_max(7), duration = 20)
neutral_step_speciation(c(10,5,12),0.2)
neutral_generation_speciation(c(10,5,12,1,2,3,4,5,6,7),0.2)
neutral_time_series_speciation(c(10,5,12,1,2,3,4,5,6,7),0.2,200)
species_abundance(c(1,2,2,2,3))
octaves(c(100,64,63,5,4,3,2,2,1,1,1,1))
sum_vect(c(1,3),c(1,0,5,2))
cluster_run(speciation_rate = 0.1,
            size = 100,
            wall_time = 0.05,
            interval_rich = 1,
            interval_oct = 10, burn_in_generations = 200,
            output_file_name = "my_test_file_1.rda")
question_8()
question_12()
question_16()
question_21()
question_22()

plot(0,0,cex=0.1, xlim = c(-10,10),ylim = c(-10,10))
turtle(c(0,0), 4*pi/3, 10)
plot(0,0,cex=0.1, xlim = c(-10,10),ylim = c(-10,10))
elbow(c(0,0), pi/3, 1)
plot(0,0,cex=0.1, xlim = c(-10,10),ylim = c(-10,10))
spiral(c(0,0), pi/3, 1)
plot(0,0,cex=0.1, xlim = c(-10,10),ylim = c(-10,10))
tree(c(0,0), pi/3, 1)
plot(0,0,cex=0.1, xlim = c(-10,10),ylim = c(-10,10))
fern(c(0,0), 4*pi/3, 1)
plot(0,0,cex=0.1, xlim = c(-10,10),ylim = c(-10,10))
fern2(c(0,0), 4*pi/3, 1, 1)


draw_spiral()
draw_tree()
draw_fern()
draw_fern2()
