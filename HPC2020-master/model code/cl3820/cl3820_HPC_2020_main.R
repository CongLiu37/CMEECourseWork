# CMEE 2020 HPC excercises R code main proforma
# you don't HAVE to use this but it will be very helpful.  If you opt to write everything yourself from scratch please ensure you use EXACTLY the same function and parameter names and beware that you may loose marks if it doesn't work properly because of not using the proforma.

name <- "Cong Liu"
preferred_name <- "Cong"
email <- "cong.liu20@imperial.ac.uk"
username <- "cl3820"
personal_speciation_rate <- 0.0047648

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
  graphics.off()# clear any existing graphs and plot your graph within the R window
  series = neutral_time_series(init_community_max(100), duration = 200)
  plot(series, type = "l",
       xlab = "Generation", ylab = "Species richness",
       main = "Fluctuation of Species Ricness")
  
  return("The system will converge to 1 if number of generations is large.
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
  graphics.off()# clear any existing graphs and plot your graph within the R window
  max = neutral_time_series_speciation(community = init_community_max(100),
                                          speciation_rate = 0.1, duration = 200)
  min = neutral_time_series_speciation(community = init_community_min(100),
                                       speciation_rate = 0.1, duration = 200)
  plot(max, type = "l",
       xlab = "Generation", ylab = "Species richness", col = "red",
       main = "Fluctuation of Species Richness", ylim = c(0,100))
  lines(min, col = "blue")
  legend("topright",cex = 0.5, c("min","max"), adj = c(1,1),
         col = c("blue", "red"), lty = 1,lwd=2, bty = "n",ncol = 2,
         text.width = 0.4)
  
  return("The community reaches such a state that its species richness 
         fluctuates in a narrow range, no matter what initial condition 
         it has. This is caused by a dynamic balance between speciation, which 
         leads to the increase of species richness; and random factors, which 
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
  graphics.off()# clear any existing graphs and plot your graph within the R window
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
  barplot(data_frame(average1, average2), names.arg = names(ncol(data_frame(average1, average2))), 
          col = c("blue", "red"),
          xlab = "Abundance", ylab = "Species richness", beside = T,
          main = "Species Richness of Different Octave Abundance", cex.main = 0.8)
  legend("topright",cex = 0.5, c("max", "min"), adj = c(1,1),
         col = c("blue", "red"), lty = 1,lwd=2, bty = "n",ncol = 2,
         text.width = 0.4)
  return("The initial state does not influence the output significantly. 
  In the model simulated here, the state of community is 
  driven by two factors: stochastic factor and speciation. Stochastic factor 
         decreases species richness and leads to homogeneity, while 
         speciation leads to diversity in the community. In a long period of time, 
         two opposite factors reach a dynamic equilibrium which is not influenced 
         by initial condition.")
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
#Return the names.arg in barplots
names = function(length){
  nam = c(1, rep(NA, length-1))
  for (i in 2:length){
    nam[i] = paste(2^(i-1),"-",2^i-1, sep = "")}
  return(as.character(nam))
}

plot_cluster_results <- function()  {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  load("process_cluster_results.rda") # load combined_results from your rda file
  # plot the graphs
  data(mtcars)
  attach(mtcars)
  opar = par(no.readonly = T)
  par(mfrow = c(2,2))
  par(mar=c(4,4,3,0))
  
  barplot(combined_results[[1]], names.arg = names(length(combined_results[[1]])), 
          xlab = "Abundance (Community Size: 500)", ylab = "Species richness", las=2,
          cex.lab = 0.6, cex.main = 0.6, cex.axis = 0.4,cex.names = 0.4,border = NA,
          main = "Species Richness among Abundance",
          ylim = c(0, ceiling(max(combined_results[[1]]))))
  par(mar=c(4,4,3,0))
  barplot(combined_results[[2]], names.arg = names(length(combined_results[[2]])), 
          xlab = "Abundance (Community Size: 1000)", ylab = "Species richness", las=2,
          cex.lab = 0.6,cex.main = 0.6, cex.axis = 0.6,cex.names = 0.4,border = NA,
          main = "Species Richness among Abundance",
          ylim = c(0, ceiling(max(combined_results[[2]])+1)))
  par(mar=c(4,4,3,0))
  barplot(combined_results[[3]], names.arg = names(length(combined_results[[3]])), 
          xlab = "Abundance (Community Size: 2500)", ylab = "Species richness", las=2,
          cex.lab = 0.6,cex.main = 0.6, cex.axis = 0.6,cex.names = 0.4,border = NA,
          main = "Species Richness among Abundance",
          ylim = c(0, ceiling(max(combined_results[[3]])+1)))
  par(mar=c(4,4,3,0))
  barplot(combined_results[[4]], 
          names.arg =  names(length(combined_results[[4]])),
          xlab = "Abundance (Community Size: 5000)", ylab = "Species richness",las=2, 
          cex.lab = 0.6,cex.main = 0.6, cex.axis = 0.6, cex.names = 0.4,border = NA,
          main = "Species Richness among Abundance",
          ylim = c(0, ceiling(max(combined_results[[4]])+1)))
  par(opar)
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
  graphics.off()# clear any existing graphs and plot your graph within the R window
  A = c(0,0)
  B = c(3,4)
  C = c(4,1)
  X = c(0,0)

  plot(X[1],X[2],cex=0.1, xlim = c(0,5), ylim = c(0,6), xlab = "", ylab = "",
       main = "Chaos Game")
  for (i in 1:2000){
  b = sample(c(1,2,3),1)
  if (b==1){a = A}
  if (b==2){a = B}
  if (b==3){a = C}
  X = X + 0.5*(a-X)
  points(X[1],X[2])
  }
  return("The points form a Sierpinski gasket within the triangle as A, B, C.")
}

# Question 24
turtle <- function(start_position, direction,length)  {
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
  
  if (length >= 0.1){
    a = turtle(start_position, direction, length)
    spiral(a, direction-pi/4, 0.95*length)
    length = 0.95*length}
  return("The function plots a spiral starts from the input parameter start_position 
         and converges to a point as the 
         number of iteration tends to infinity. However, when runing the codes, computer 
         cannot do the iteration infinite times and is limited by stack size, an operating 
         system parameter. Thus, an error message would be given.")
}


# Question 27
draw_spiral <- function(start_position=c(0,0), direction=pi/4, length=1)  {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  plot(start_position[1], start_position[2], cex = 0.1,
       xlim = c(start_position[1],start_position[1]+2.5*length),
       ylim = c(start_position[2]-1.5*length, start_position[2]+2*length),
       main = "Spiral", xlab = "", ylab = "")
  spiral(start_position, direction, length)
  
  return("The function plots a spiral starts from the input parameter start_position 
         and converges to a point as the 
         number of iteration tends to infinity. However, when runing the codes, computer 
         cannot do the iteration infinite times and is limited by stack size, an operating 
         system parameter. Thus, an error message would be given.")
}


# Question 28
tree <- function(start_position, direction, length, threshold=0.1)  {
  a = turtle(start_position, direction, length)
  if (length >= threshold){
    length = 0.65*length
    tree(a, direction-pi/4, length, threshold=0.1)
    tree(a, direction+pi/4, length, threshold=0.1)
    }
}

draw_tree <- function(start_position=c(0,0), direction=pi/4, length=1, threshold=0.1) {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  plot(start_position[1], start_position[2], cex = 0.1,
       xlim = c(start_position[1]-2*length,start_position[1]+2.5*length),
       ylim = c(start_position[2]-1.5*length, start_position[2]+2.5*length),
       main = "Tree", xlab = "", ylab = "")
  tree(start_position, direction, length,threshold=0.1)
}

# Question 29
fern <- function(start_position, direction, length)  {
  a = turtle(start_position, direction, length)
  if (length >= 0.1){
    fern(a, direction, 0.87*length)
    fern(a, direction+pi/4, 0.38*length)}
}

draw_fern <- function(start_position=c(0,0), direction=pi/4, length=1)  {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  plot(start_position[1], start_position[2], cex = 0.1,
       xlim = c(start_position[1]-length,start_position[1]+6*length),
       ylim = c(start_position[2]-1.5*length, start_position[2]+6*length),
       main = "Fern", xlab = "", ylab = "")
  fern(start_position, direction, length)
  

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
  graphics.off()# clear any existing graphs and plot your graph within the R window
  plot(start_position[1], start_position[2], cex = 0.1,
       xlim = c(start_position[1]-length,start_position[1]+6*length),
       ylim = c(start_position[2]-1.5*length, start_position[2]+6*length),
       main = "Fern2", xlab = "", ylab = "")
  fern2(start_position, direction, length,dir)
}

# Challenge questions - these are optional, substantially harder, and a maximum of 16% is available for doing them.  

# Challenge question A
#Calculate confident interval without variant value
confint = function(data, alpha){
  n = length(data)
  mean = mean(data)
  tmp = sd(data)/sqrt(n)*qt(1-alpha/2, n-1);df = n-1
  return(c(mean-tmp, mean+tmp))
}

Challenge_A <- function() {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  community1 = init_community_max(100)
  community2 = init_community_min(100)
  sum1 = rep(0,100)
  sum2 = rep(0,100)
  richness_data1 = matrix(NA, nrow = 100, ncol = 100)
  richness_data2 = matrix(NA, nrow = 100, ncol = 100)
  #Simulate 100 generations for 100 times
  for (i in 1:100){
    series1 = neutral_time_series_speciation(community1, 0.1, 99)
    series2 = neutral_time_series_speciation(community2, 0.1, 99)
    richness_data1[i,] = series1
    richness_data2[i,] = series2
    sum1 = sum1+series1
    sum2 = sum2+series2}
  mean1 = sum1/100
  mean2 = sum2/100
  
  #Plot functuation of species richness
  plot(mean1, type = "l",
       xlab = "Generation", ylab = "Species richness", col = "red",
       main = "Fluctuation of Species Richness", xlim = c(0,100), ylim = c(0,100))
  lines(mean2, col = "blue")
  legend("topright",cex = 0.5, c("min","max"), adj = c(1,1),
         col = c("blue", "red"), lty = 1,lwd=2, bty = "n",ncol = 2,
         text.width = 0.4)
  #Calculate 97.2% confident interval
  for (i in 1:100){
    interval1 = confint(richness_data1[,i], alpha = 0.028)
    segments(x0 = i, y0 = interval1[1], x1 = i, y1 = interval1[2], col = "red")
    
    interval2 = confint(richness_data2[,i], alpha = 0.028)
    segments(x0 = i, y0 = interval2[1], x1 = i, y1 = interval2[2], col = "blue")
  }
  
  #Estimate generations needed for reaching dynamic equilibrium
  for (i in 1:100){
  p = try(t.test(richness_data1[,i],richness_data2[,i])$p.value, silent = T)
  if (class(p) != "try-error" & p > 0.05){break}}
  segments(x0 = i, y0 = 0, x1 = i, y1 = 100, col = "green")#Green line indicates when equilibrium reached
}

# Challenge question B
#Return a community with given size and species richness
community = function(size,species_richness){
  com = rep(NA, size)
  com[1:species_richness] = 1:species_richness
  if (species_richness < size){
    com[species_richness+1:size] = sample(1:species_richness, 
                                          size-species_richness,
                                          replace = T)}
  return(com)
}

Challenge_B <- function() {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  plot(x = 0, y = 0, cex = 0.1, xlim = c(0,100), ylim = c(0,100),
       main = "Fulctuation of Species Richness among Generations",
       xlab = "Generation", ylab = "SPecies Richness")
  for (i in c(1,10,20,30,40,50,60,70,80,90,100)){
    com = community(100,i)
    sum = c()
    for (j in 1:10){
    series = neutral_time_series_speciation(com,0.1,100)
    sum = sum_vect(sum,series)}
    mean = sum/10
    lines(mean)}
}


# Challenge question C
Challenge_C <- function() {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  richness_500 = c()
  for (i in 1:25){
    file = paste("ClusterOutput_",i,".rda", sep = "")
    load(file)
    richness_500 = sum_vect(richness_500, richness)}
  richness_500 = richness_500/25

  richness_1000 = c()
  for (i in 26:50){
    file = paste("ClusterOutput_",i,".rda", sep = "")
    load(file)
    richness_1000 = sum_vect(richness_1000, richness)}
  richness_1000 = richness_1000/25
  
  richness_2500 = c()
  for (i in 51:75){
    file = paste("ClusterOutput_",i,".rda", sep = "")
    load(file)
    richness_2500 = sum_vect(richness_2500, richness)}
  richness_2500 = richness_2500/25
  
  richness_5000 = c()
  for (i in 76:100){
    file = paste("ClusterOutput_",i,".rda", sep = "")
    load(file)
    richness_5000 = sum_vect(richness_5000, richness)}
  richness_5000 = richness_5000/25
  par(mar=c(4,4,1,1))
  plot(richness_500, type = "l", xlab = "Generations", ylab = "Richness",
       col = "red", ylim = c(0,250))
  lines(richness_1000, col="black")
  lines(richness_2500, col="blue")
  lines(richness_5000, col = "green")
  legend(x=0,y=250,cex = 0.5, c("500","1000","2500","5000"), adj = c(1,1),
         col = c("red","black","blue","green"), lty = 1,lwd=2, bty = "n",ncol = 4,
         text.width = 0.4)
  
}

# Challenge question D
coalescence_simulation = function(size, speciation_rate){
  lineages = rep(1, size)
  abundances = c()
  N = size
  theta = speciation_rate*(size-1)/(1-speciation_rate)
  while (N != 1){
  j = sample(1:N,1)
  randnum = runif(1)
  
  if (randnum < theta/(theta+N-1)){
    abundances = c(abundances, lineages[j])}else{
    i = sample(1:N,1)
    while(i == j){i = sample(1:N,1)}
    lineages[i] = lineages[i] + lineages[j]}

  lineages = lineages[-j]
  N = N - 1 }
  abundances = c(abundances, lineages)
  return(abundances)
}
#Bind two vectors of different length by row
data_frame <- function(x, y) {
  if (length(x) <= length(y)){
    sh = x
    lo = y
    sh = c(sh, rep(0, length(lo)-length(sh)))
    data = rbind(sh, lo)}
  else{
    sh = y
    lo = x
    sh = c(sh, rep(0, length(lo)-length(sh)))
    data = rbind(lo, sh)}
  return(data)
}

Challenge_D <- function() {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  sr = 0.0047648
  sum_500 = c()
  sum_1000 = c()
  sum_2500 = c()
  sum_5000 = c()
  
  for (i in 1:25){
  coal1 = octaves(coalescence_simulation(500, sr))
  coal2 = octaves(coalescence_simulation(1000, sr))
  coal3 = octaves(coalescence_simulation(2500, sr))
  coal4 = octaves(coalescence_simulation(5000, sr))
  sum_500 = sum_vect(sum_500, coal1)
  sum_1000 = sum_vect(sum_1000, coal2)
  sum_2500 = sum_vect(sum_2500, coal3)
  sum_5000 = sum_vect(sum_5000, coal4)}
  
  ave_500 = sum_500/25
  ave_1000 = sum_1000/25
  ave_2500 = sum_2500/25
  ave_5000 = sum_5000/25
  
  load("process_cluster_results.rda") # load combined_results from your rda file

  data(mtcars)
  attach(mtcars)
  opar = par(no.readonly = T)
  par(mfrow = c(2,2))
  par(mar=c(4,4,3,0))
  
  barplot(data_frame(ave_500, combined_results[[1]]), 
          names.arg = names(ncol(data_frame(ave_500, combined_results[[1]]))), 
          beside = T, col = c("red","blue"),
          xlab = "Abundance from Coalescence (red)/Cluster (blue)\nCommunity Size: 5000", ylab = "Species richness", las=2,
          cex.lab = 0.6, cex.main = 0.6, cex.axis = 0.4,cex.names = 0.4,border = NA,
          main = "Species Richness among Abundance",
          ylim = c(0, ceiling(max(ave_500))))
  par(mar=c(4,4,3,0))
  barplot(data_frame(ave_1000, combined_results[[2]]), 
          names.arg = names(ncol(data_frame(ave_1000, combined_results[[2]]))), 
          beside = T, col = c("red","blue"),
          xlab = "Abundance from Coalescence (red)/Cluster (blue)\nCommunity Size: 5000", ylab = "Species richness", las=2,
          cex.lab = 0.6,cex.main = 0.6, cex.axis = 0.6,cex.names = 0.4,border = NA,
          main = "Species Richness among Abundance",
          ylim = c(0, ceiling(max(ave_1000))))
  par(mar=c(4,4,3,0))
  barplot(data_frame(ave_2500, combined_results[[3]]), 
          names.arg = names(ncol(data_frame(ave_2500, combined_results[[3]]))), 
          beside = T, col = c("red","blue"),
          xlab = "Abundance from Coalescence (red)/Cluster (blue)\nCommunity Size: 5000", ylab = "Species richness", las=2,
          cex.lab = 0.6,cex.main = 0.6, cex.axis = 0.6,cex.names = 0.4,border = NA,
          main = "Species Richness among Abundance",
          ylim = c(0, ceiling(max(coal3))))
  par(mar=c(4,4,3,0))
  barplot(data_frame(ave_5000, combined_results[[4]]), 
          names.arg = names(ncol(data_frame(ave_5000, combined_results[[4]]))),
          beside = T, col = c("red","blue"), 
          xlab = "Abundance from Coalescence (red)/Cluster (blue)\nCommunity Size: 5000", ylab = "Species richness",las=2, 
          cex.lab = 0.6,cex.main = 0.6, cex.axis = 0.6, cex.names = 0.4,border = NA,
          main = "Species Richness among Abundance",
          ylim = c(0, ceiling(max(coal4))))
  par(opar)
  return("Simulating by cluster took 11.5 hours, while through coalescence, it took 
         6.219 seconds. This is because: (1) when simulating by coalescence, the system
         is always at equilibrium and does not need burn in time; (2) coalescence 
         simulation does not simulate individuals fail to survival and leave offsprings in
         observed community.")
}

# Challenge question E
#A,B,C: Given points
#X: Initial position
#n: First n steps are plotted in red, while the rest in black
Challenge_E <- function(A=c(0,0),B=c(3,4),C=c(4,1),X=c(0,0),n=100) {
  graphics.off()# clear any existing graphs and plot your graph within the R window
  plot(X[1],X[2],cex=0.1, xlim = c(0,5), ylim = c(0,6), xlab = "", ylab = "",
       main = "Chaos Game")
  for (i in 1:2000){
    b = sample(c(1,2,3),1)
    if (b==1){a = A}
    if (b==2){a = B}
    if (b==3){a = C}
    X = X + 0.5*(a-X)
    if (i <= n){points(X[1],X[2],col = "red", cex = 0.5)}
    else{points(X[1],X[2], cex = 0.1)}}
  return("No matter what initial position is, a Sierpinski gasket within the triangle
         A, B, C is produced. This is because, in the process, the position of point 
         is approximately distributed on edges of the Sierpinski gasket within the triangle in an 
         approximately uniform way.")
}

# Challenge question F
Challenge_F <- function() {
  graphics.off()# clear any existing graphs and plot your graph within the R window

  start_position=c(10,10)
  length=1
  threshold=0.1
  plot(start_position[1], start_position[2], cex = 0.1,
       xlim = c(start_position[1]-2.5*length,start_position[1]+2.5*length),
       ylim = c(start_position[2]-2.5*length, start_position[2]+3.5*length),
       main = "Tree", xlab = "", ylab = "")

  tree(start_position, direction = pi/2, length,threshold=0.1)
  tree(start_position, direction = -pi/2, length,threshold=0.1)
  tree(start_position, direction = 0, length,threshold=0.1)
  tree(start_position, direction = pi, length,threshold=0.1)
  return("The smaller the line size threshold is, the more branches of the tree will be got,
         and the program will take longer time to run.")
}

# Challenge question G should be written in a separate file that has no dependencies on any functions here.


