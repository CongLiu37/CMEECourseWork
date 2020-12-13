# CMEE 2020 HPC excercises R code HPC run code proforma

rm(list=ls()) # good practice in this instance
source("cl3820/cl3820_HPC_2020_main.R")
# it should take a faction of a second to source your file
# if it takes longer you're using the main file to do actual simulations
# it should be used only for defining functions that will be useful for your cluster run and which will be marked automatically

# do what you like here to test your functions (this won't be marked)
# for example
#1
species_richness(c(1,4,4,5,1,6,1))
# should return 4 when you've written the function correctly for question 1

# you may also like to use this file for playing around and debugging
# but please make sure it's all tidied up by the time it's made its way into the main.R file or other files.
#2
init_community_max(7)
#should return a vector {1 2 3 4 5 6 7}
#3
init_community_min(4)
#should return a vector {1 1 1 1}

#Test
species_richness(init_community_min(100))
species_richness(init_community_max(100))
#4
choose_two(4)
#should return one of the following vectors:
#{1 2}, {1 3}, {1 4}, {2 1}, {2 3}, {2 4}, {3 1}, {3 2}, {3 4}, {4 1}, {4 2}, {4 3}
#5
neutral_step(c(10,5,13))
#6
neutral_generation(c(1,2,3,1,2,3,1,2,3))
#7
neutral_time_series(community = init_community_max(7), duration = 20)
#8
question_8()
#9
neutral_step_speciation(c(10,5,12),0.2)
#10
neutral_generation_speciation(c(10,5,12,1,2,3,4,5,6,7),0.2)
#11
neutral_time_series_speciation(c(10,5,12,1,2,3,4,5,6,7),0.2,200)
#12
question_12()
#13
species_abundance(c(1,2,2,2,3))
#14
octaves(c(100,64,63,5,4,3,2,2,1,1,1,1))
#15
sum_vect(c(1,3),c(1,0,5,2))
#16
question_16()
#17
cluster_run(speciation_rate = 0.1,
            size = 100,
            wall_time = 0.05,
            interval_rich = 1,
            interval_oct = 10, burn_in_generations = 200,
            output_file_name = "my_test_file_1.rda")
#20
process_cluster_results()
plot_cluster_results()
#21
question_21()
#22
question_22()
#23
chaos_game()
#24
plot(0,0,cex=0.1, xlim = c(-10,10),ylim = c(-10,10))
turtle(c(0,0), 4*pi/3, 10)
#25
plot(0,0,cex=0.1, xlim = c(-10,10),ylim = c(-10,10))
elbow(c(0,0), pi/3, 1)
#26
plot(0,0,cex=0.1, xlim = c(-10,10),ylim = c(-10,10))
spiral(c(0,0), pi/3, 1)
#27
draw_spiral()
#28
plot(0,0,cex=0.1, xlim = c(-10,10),ylim = c(-10,10))
tree(c(0,0), pi/3, 1)
draw_tree()
#29
plot(0,0,cex=0.1, xlim = c(-10,10),ylim = c(-10,10))
fern(c(0,0), 4*pi/3, 1)
draw_fern()
#30
plot(0,0,cex=0.1, xlim = c(-10,10),ylim = c(-10,10))
fern2(c(0,0), 4*pi/3, 1, 1)
draw_fern2()

