# CMEE 2020 HPC excercises R code main proforma
# you don't HAVE to use this but it will be very helpful.  If you opt to write everything yourself from scratch please ensure you use EXACTLY the same function and parameter names and beware that you may loose marks if it doesn't work properly because of not using the proforma.

name <- "Cong Liu"
preferred_name <- "Cong"
email <- "cong.liu20@imperial.ac.uk"
username <- "cl3820"

# please remember *not* to clear the workspace here, or 
#anywhere in this file. If you do, it'll wipe out your username information 
#that you entered just above, and when you 
#use this file as a 'toolbox' as intended it'll 
#also wipe away everything you're doing outside of the toolbox.  
#For example, it would wipe away any automarking code 
#that may be running and that would be annoying!

# Question 1
species_richness <- function(community){
  return(length(unique(community)))
}

# Question 2
init_community_max <- function(size){
  return(seq(size))
}

# Question 3
init_community_min <- function(size){
  return(rep(1,size))
}

# Question 4
choose_two <- function(max_value){
  return(sample(seq(1:max_value), size = 2, replace = F))
}

# Question 5
neutral_step <- function(community){
  a = choose_two(length(community))
  community[a[1]] = community[a[2]]
  return(community)
}

# Question 6
neutral_generation <- function(community){
  a = length(community)
  if (a%%2 == 0){b = 0.5*a}
  else{b = sample(c(0.5*a-0.5, 0.5*a+0.5), size = 1)}
  
  for (i in 1:b){community = neutral_step(community)}
  return(community)
}

# Question 7
neutral_time_series <- function(community,duration){
  richness = rep(NA, duration+1)
  richness[1] = species_richness(community)
  for (i in 1:duration){
    richness[i+1] = species_richness(community)
    community = neutral_generation(community)}
  return(richness)
}

# Question 8
question_8 <- function() {
  series = neutral_time_series(init_community_max(100), duration = 200)
  plot(series, type = "l",
       xlab = "Generation", ylab = "Species richness")
  # clear any existing graphs and plot your graph within the R window
  return("The system will converge to 1 if number of generations are large.
         This is because in each generation, there is a proportion of individuals 
         that die without offsprings. Given time that is long enough, all individuals 
         in the community will be traced back to a common ancestor, and species 
         richness converges to 1.")
}

# Question 9
neutral_step_speciation <- function(community,speciation_rate)  {
  a = runif(1, min = 0, max = 1)
  if (a >= speciation_rate){community = neutral_step(community)}
  else{
    b = sample(1:length(community), 1)
    c = sample(1:10000, 1)
    while (c %in% community){c = sample(1:100000000, 1)}
    community[b] = c}
  return(community)
}

# Question 10
neutral_generation_speciation <- function(community,speciation_rate)  {
  a = length(community)
  if (a%%2 == 0){b = 0.5*a}
  else{b = sample(c(0.5*a-0.5, 0.5*a+0.5), size = 1)}
  
  for (i in 1:b){community = neutral_step_speciation(community,speciation_rate)}
  return(community)
}

# Question 11
neutral_time_series_speciation <- function(community,speciation_rate,duration)  {
  richness = rep(NA, duration+1)
  richness[1] = species_richness(community)
  for (i in 1:duration){
    richness[i+1] = species_richness(community)
    community = neutral_generation_speciation(community, speciation_rate)}
  return(richness)
}

# Question 12
question_12 <- function()  {
  max = neutral_time_series_speciation(community = init_community_max(100),
                                          speciation_rate = 0.1, duration = 200)
  min = neutral_time_series_speciation(community = init_community_min(100),
                                       speciation_rate = 0.1, duration = 200)
  plot(max, type = "l",
       xlab = "Generation", ylab = "Species richness", col = "red")
  lines(min, col = "blue")
  legend("topright",cex = 1, c("min","max"), col = c("blue", "red"), lty = 1)
  # clear any existing graphs and plot your graph within the R window
  
  return("The community reaches such a state that its species richness 
         fluctuates in a narrow range, no matter what initial conditions 
         it has. This is caused by a balance between speciation, which 
         leads to the increase of species richness, and random factors, which 
         lead to the decrease of species richness.")
}

# Question 13
species_abundance <- function(community)  {
  return(sort(unname(table(community)), decreasing = T))
}

# Question 14
octaves <- function(abundance_vector) {
  a = floor(log2(abundance_vector))+1
  return(tabulate(a))
}

# Question 15
sum_vect <- function(x, y) {
  if (length(x) <= length(y)){
    sh = x
    lo = y}
  else{
    sh = y
    lo = x}
  sh = c(sh, rep(0, length(lo)-length(sh)))
  return(sh+lo)
}

# Question 16 
question_16 <- function()  {
  # clear any existing graphs and plot your graph within the R window
  community1 = init_community_max(100)
  community2 = init_community_min(100)
  
  sr = 0.1

  for (i in 1:200){
    community1 = neutral_generation_speciation(community1, sr)
    community2 = neutral_generation_speciation(community2, sr)
  }
  sum1 = c(0)
  sum2 = c(0)
  for (i in 1:2000){
    community1 = neutral_generation_speciation(community1, sr)
    community2 = neutral_generation_speciation(community2, sr)
    if (i %% 20 == 0){
    octave1 = octaves(species_abundance(community1))
    octave2 = octaves(species_abundance(community2))
    sum1 = sum_vect(sum1, octave1)
    sum2 = sum_vect(sum2, octave2)}}
  
  average1 = sum1/100
  average2 = sum2/100
  barplot(rbind(average1, average2), names.arg = c(1,2,3,4,5,6), 
          col = c("blue", "red"),
          xlab = "Abundance", ylab = "Species richness", beside = T)
  legend("topright", c("max", "min"), fill = c("blue", "red"))
  return("The initial state does not influence the output obviously. 
  The reason is explained below.
  The abundances and richness of species is dependent on frequencies of species 
  since the overall number of individuals in the community is a constant.
  In the model simulated here, the fluctuation of frequencies of species is 
  driven by two factors: stochastic factor and speciation. Stochastic factor 
         decreases species richness and leads to homogeneity, while 
         speciation leads to diversity. In a long period of time, 
         two opposite factors reach a balance dependent on number of individuals 
         in the community and speciation rate, while the initial state of the community 
         has no influence on it.")
}

# Question 17
cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name)  {
    ptm = unname(proc.time()[1])
    community = init_community_min(size)
    i = 0
    j = 1
    richness = c(species_richness(community))
    octaves_ls = list(octaves(species_abundance(community)))
    while (unname(proc.time()[1]) - ptm <= 60*wall_time){
      community = neutral_generation_speciation(community,speciation_rate)
      i = i + 1
      if (i <= burn_in_generations & i %% interval_rich == 0){
        richness = c(richness, species_richness(community))}
      if (i %% interval_oct == 0){
        j = j + 1
        octaves_ls[[j]] = octaves(species_abundance(community))}}
    time = paste(unname(proc.time()[1]) - ptm, "s")
    save(speciation_rate, size, wall_time, interval_rich, interval_oct, 
         burn_in_generations, community, richness, octaves_ls, time, 
         file = output_file_name)

}
# Questions 18 and 19 involve writing code elsewhere to run your simulations on the cluster

# Question 20 
process_cluster_results <- function()  {
  combined_results <- list() #create your list output here to return
  # save results to an .rda file
  
}

plot_cluster_results <- function()  {
    # clear any existing graphs and plot your graph within the R window
    # load combined_results from your rda file
    # plot the graphs
    
    return(combined_results)
}

# Question 21
question_21 <- function()  {
    
  return("type your written answer here")
}

# Question 22
question_22 <- function()  {
    
  return("type your written answer here")
}

# Question 23
chaos_game <- function()  {
  # clear any existing graphs and plot your graph within the R window
  
  return("type your written answer here")
}

# Question 24
turtle <- function(start_position, direction, length)  {
    
  return() # you should return your endpoint here.
}

# Question 25
elbow <- function(start_position, direction, length)  {
  
}

# Question 26
spiral <- function(start_position, direction, length)  {
  
  return("type your written answer here")
}

# Question 27
draw_spiral <- function()  {
  # clear any existing graphs and plot your graph within the R window
  
}

# Question 28
tree <- function(start_position, direction, length)  {
  
}

draw_tree <- function()  {
  # clear any existing graphs and plot your graph within the R window

}

# Question 29
fern <- function(start_position, direction, length)  {
  
}

draw_fern <- function()  {
  # clear any existing graphs and plot your graph within the R window

}

# Question 30
fern2 <- function(start_position, direction, length)  {
  
}
draw_fern2 <- function()  {
  # clear any existing graphs and plot your graph within the R window

}

# Challenge questions - these are optional, substantially harder, and a maximum of 16% is available for doing them.  

# Challenge question A
Challenge_A <- function() {
  # clear any existing graphs and plot your graph within the R window

}

# Challenge question B
Challenge_B <- function() {
  # clear any existing graphs and plot your graph within the R window

}

# Challenge question C
Challenge_C <- function() {
  # clear any existing graphs and plot your graph within the R window

}

# Challenge question D
Challenge_D <- function() {
  # clear any existing graphs and plot your graph within the R window
  
  return("type your written answer here")
}

# Challenge question E
Challenge_E <- function() {
  # clear any existing graphs and plot your graph within the R window
  
  return("type your written answer here")
}

# Challenge question F
Challenge_F <- function() {
  # clear any existing graphs and plot your graph within the R window
  
  return("type your written answer here")
}

# Challenge question G should be written in a separate file that has no dependencies on any functions here.


