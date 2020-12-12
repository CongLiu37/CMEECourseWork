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
  sum_500 = c()
  k = 0
  for (i in 1:25){
    file = paste("ClusterOutput_",i,".rda", sep = "")
    load(file)
    for (j in 1:length(octaves_ls)){
    generation = (j-1)*interval_oct
    if (generation > burn_in_generations){
      sum_500 = sum_vect(sum_500, octaves_ls[[j]])
      k = k + 1
    }}}
  average_500 = sum_500/k
  
  sum_1000 = c()
  k = 0
  for (i in 26:50){
    file = paste("ClusterOutput_",i,".rda", sep = "")
    load(file)
    for (j in 1:length(octaves_ls)){
      generation = (j-1)*interval_oct
      if (generation > burn_in_generations){
        sum_1000 = sum_vect(sum_1000, octaves_ls[[j]])
        k = k + 1
      }}}
  average_1000 = sum_1000/k
  
  sum_2500 = c()
  k = 0
  for (i in 51:75){
    file = paste("ClusterOutput_",i,".rda", sep = "")
    load(file)
    for (j in 1:length(octaves_ls)){
      generation = (j-1)*interval_oct
      if (generation > burn_in_generations){
        sum_2500 = sum_vect(sum_2500, octaves_ls[[j]])
        k = k + 1
      }}}
  average_2500 = sum_2500/k
  
  sum_5000 = c()
  k = 0
  for (i in 76:100){
    file = paste("ClusterOutput_",i,".rda", sep = "")
    load(file)
    for (j in 1:length(octaves_ls)){
      generation = (j-1)*interval_oct
      if (generation > burn_in_generations){
        sum_5000 = sum_vect(sum_5000, octaves_ls[[j]])
        k = k + 1
      }}}
  average_5000 = sum_5000/k
  
  combined_results <- list(average_500,average_1000,
                           average_2500, average_5000) #create your list output here to return
  save(combined_results, file = "process_cluster_results.rda")
  # save results to an .rda file
  
}

plot_cluster_results <- function()  {
  load("process_cluster_results.rda")
  data(mtcars)
  attach(mtcars)
  opar = par(no.readonly = T)
  par(mfrow = c(2,2))
  barplot(combined_results[[1]], names.arg = 1:length(combined_results[[1]]), 
          xlab = "Abundance", ylab = "Species richness",
          main = "Size = 500")
  barplot(combined_results[[2]], names.arg = 1:length(combined_results[[2]]), 
          xlab = "Abundance", ylab = "Species richness",
          main = "Size = 1000")
  barplot(combined_results[[3]], names.arg = 1:length(combined_results[[3]]), 
          xlab = "Abundance", ylab = "Species richness",
          main = "Size = 2500")
  barplot(combined_results[[4]], names.arg = 1:length(combined_results[[4]]), 
          xlab = "Abundance", ylab = "Species richness",
          main = "Size = 5000")
  par(opar)
  return(combined_results)
    # clear any existing graphs and plot your graph within the R window
    # load combined_results from your rda file
    # plot the graphs
    
    return(combined_results)
}

# Question 21
question_21 <- function()  {
  out = list(log(8)/log(3), "In order to get three times width, 8 materials are needed. So denote 
         dimention by x, there is 8 = 3^x, and x = log(8)/log(3)")
  return(out)
}

# Question 22
question_22 <- function()  {
  out = list(log(20)/log(3),"In order to get three times width, 20 materials are needed.
             Denote dimention by x, so 20 = 3^x, x = log(20)/log(3)")
  return(out)
}

# Question 23
chaos_game <- function()  {
  # clear any existing graphs and plot your graph within the R window
  A = c(0,0)
  B = c(3,4)
  C = c(4,1)
  X = c(0,0)

  plot(X[1],X[2],cex=0.1,xlim = c(-2,3),ylim = c(-2,3))
  for (i in 1:100){
  b = sample(c(1,2,3),1)
  if (b==1){a = A}
  if (b==2){a = B}
  if (b==3){a = C}
  segments(x0=X[1],y0=X[2], x1=0.5*(a-X)[1], y1=0.5*(a-X)[2])
  X = 0.5*(a-X)
  }
  return("The point moves in a limited range, which is approximately a 
         rectangle with vertices (-2,-2), (-2,3), (3,-2) and (3,3). In 
         the process of moving, the path pf point X tends to pass by 
         three fixed points.")
}

# Question 24
turtle <- function(start_position, direction, length)  {
  end_point = start_position + c(length*cos(direction), length*sin(direction))
  segments(x0=start_position[1],y0=start_position[2],
           x1=end_point[1],y1=end_point[2])  
  return(end_point) # you should return your endpoint here.
}

# Question 25
elbow <- function(start_position, direction, length)  {
  a = turtle(start_position, direction, length)
  turtle(a, direction-pi/4, 0.95*length)
}

# Question 26
spiral <- function(start_position, direction, length)  {
  a = turtle(start_position, direction, length)
  if (length >= 0.05){
  spiral(a, direction-pi/4, 0.95*length)}
  return("The function plots a spiral starts from the input parameter start_position 
         and converges to a point as the 
         number of iteration tends to infinity. However, when runing the codes, computer 
         cannot do the iteration infinite times and is limited by stack size, an operating 
         system parameter. Thus, an error message would be given.")
}


# Question 27
draw_spiral <- function(start_position=c(0,0), direction=pi/4, length=1)  {
  plot(start_position[1], start_position[2], cex = 0.1,
       xlim = c(start_position[1],start_position[1]+2.5*length),
       ylim = c(start_position[2]-1.5*length, start_position[2]+length))
  spiral(start_position, direction, length)
  # clear any existing graphs and plot your graph within the R window
  return("The function plots a spiral starts from the input parameter start_position 
         and converges to a point as the 
         number of iteration tends to infinity. However, when runing the codes, computer 
         cannot do the iteration infinite times and is limited by stack size, an operating 
         system parameter. Thus, an error message would be given.")
}

# Question 28
tree <- function(start_position, direction, length)  {
  a = turtle(start_position, direction, length)
  if (length >= 0.1){
    tree(a, direction-pi/4, 0.65*length)
    tree(a, direction+pi/4, 0.65*length)}
}

draw_tree <- function(start_position=c(0,0), direction=pi/4, length=1)  {
  plot(start_position[1], start_position[2], cex = 0.1,
       xlim = c(start_position[1]-length,start_position[1]+2.5*length),
       ylim = c(start_position[2]-1.5*length, start_position[2]+2.5*length))
  tree(start_position, direction, length)
  # clear any existing graphs and plot your graph within the R window

}

# Question 29
fern <- function(start_position, direction, length)  {
  a = turtle(start_position, direction, length)
  if (length >= 0.1){
    fern(a, direction, 0.87*length)
    fern(a, direction+pi/4, 0.38*length)}
}

draw_fern <- function(start_position=c(0,0), direction=pi/4, length=1)  {
  plot(start_position[1], start_position[2], cex = 0.1,
       xlim = c(start_position[1]-length,start_position[1]+6*length),
       ylim = c(start_position[2]-1.5*length, start_position[2]+6*length))
  fern(start_position, direction, length)
  # clear any existing graphs and plot your graph within the R window

}

# Question 30
fern2 <- function(start_position, direction, length, dir)  {
  if (dir != 1 & dir != -1){return("Error! Variable dir should be either 1 or -1")}
  else{
    a = turtle(start_position, direction, length)
    if (length >= 0.1){
      fern2(a, direction, 0.87*length, -1*dir)
      fern2(a, direction+dir*pi/4, 0.38*length, -1*dir)}}
}
draw_fern2 <- function(start_position=c(0,0), direction=pi/4, length=1, dir=1)  {
  plot(start_position[1], start_position[2], cex = 0.1,
       xlim = c(start_position[1]-length,start_position[1]+6*length),
       ylim = c(start_position[2]-1.5*length, start_position[2]+6*length))
  fern2(start_position, direction, length,dir)
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


