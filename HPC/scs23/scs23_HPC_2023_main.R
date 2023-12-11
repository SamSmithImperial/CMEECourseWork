# CMEE 2022 HPC exercises R code main pro forma
# You don't HAVE to use this but it will be very helpful.
# If you opt to write everything yourself from scratch please ensure you use
# EXACTLY the same function and parameter names and beware that you may lose
# marks if it doesn't work properly because of not using the pro-forma.
library(ggplot2)

name <- "Sam Smith"
preferred_name <- "Sam"
email <- "scs23@imperial.ac.uk"
username <- "scs23"

# Please remember *not* to clear the workspace here, or anywhere in this file.
# If you do, it'll wipe out your username information that you entered just
# above, and when you use this file as a 'toolbox' as intended it'll also wipe
# away everything you're doing outside of the toolbox.  For example, it would
# wipe away any automarking code that may be running and that would be annoying!

# Question 1
species_richness <- function(community){
  unique <- unique(community)
  SR <- length(unique)
  return(SR)
}

# Question 2
init_community_max <- function(size){
  output <- seq(1,size,1)
  return(output)
}

# Question 3
init_community_min <- function(size){
  output <- rep(1, size)
  return(output)
}

# Question 4
choose_two <- function(max_value){
  num1 <- sample(1:max_value,1)
  num2 <- sample(setdiff(1:max_value, num1),1)
  return(c(num1,num2))
}

# Question 5
neutral_step <- function(community){
  maxvalue <- length(community)
  twonums <- choose_two(max_value = maxvalue)
  community[twonums[1]] = community[twonums[2]]
  return(community)
}

# Question 6
neutral_generation <- function(community){
  length <- length(community)+sample(c(0-length(community)%%2,length(community)%%2),1)
  gentime <- round(length/2,0)
  for (i in seq_len(gentime)) {
  community <- neutral_step(community)
  }
  return(community)
}

# Question 7
neutral_time_series <- function(community,duration)  {
  SR <- length(unique(community)) # initial species richness
  for (i in seq_len(duration)){
    community <- neutral_generation(community)
    SR <- c(SR,length(unique(community)))
  }
  return(SR)
}

  # Question 8
question_8 <- function() {
  png(filename="question_8", width = 600, height = 400)
  community <- init_community_max(100)
  timeseries <- seq(1,201,1)
  SRs <- neutral_time_series(community = community, duration = 200)
  df <- data.frame(timeseries, SRs)
  ggplot(df,aes(timeseries, SRs))+geom_line()
  Sys.sleep(0.1)
  dev.off()
  
  return("The community system will always converge to a species richness of one. This is because the random extinction species results in the random increase in alternative species abundance. The increase in abundance of one species in turn further increases its likelihood of replacing another extinct species. Therefore this 'positive feedback' results in one species totally dominating.")
}

# Question 9
neutral_step_speciation <- function(community,speciation_rate)  {
  RandomNumber <- runif(1)
  if (RandomNumber>speciation_rate){
    return(neutral_step(community))
  } else {
    maxvalue <- length(community)
    twonums <- choose_two(max_value = maxvalue)
    community[twonums[1]] = max(community)+1 # is this right?
    return(community)
  }
}

# Question 10
neutral_generation_speciation <- function(community,speciation_rate)  {
  length <- length(community)+sample(c(0-length(community)%%2,length(community)%%2),1)
  gentime <- round(length/2,0)
  for (i in seq_len(gentime)) {
    community <- neutral_step_speciation(community,speciation_rate)
  }
  return(community)
}

# Question 11
neutral_time_series_speciation <- function(community,speciation_rate,duration)  {
  SR <- length(unique(community))
  for (i in seq_len(duration)){
    community <- neutral_generation_speciation(community,speciation_rate)
    SR <- c(SR, length(unique(community)))
  }
  return(SR)
}

# Question 12
question_12 <- function()  {
  
  
  
  png(filename="question_12", width = 600, height = 400)
  communitymax <- init_community_max(100)
  communitymin <- init_community_min(100)

  timeseries <- seq(1,201,1)
  SRsMax <- neutral_time_series_speciation(community = communitymax, duration = 200, speciation_rate = 0.1)
  SRsMin <- neutral_time_series_speciation(community = communitymin, duration = 200, speciation_rate = 0.1)
  df <- data.frame(timeseries, SRsMax, SRsMin)
  ggplot()+geom_line(aes(timeseries, SRsMax))+geom_line(aes(timeseries, SRsMin))
  Sys.sleep(0.1)
  dev.off()
  
  return("The plot illustrates that speciation is integral for finding an equilibrium for species richness that is not 1. 200 is a sufficiently long duration for a clear balance to be observed on the plot. Under these circumstances the balance occurs at 25-30 SR. ")
}

# Question 13
species_abundance <- function(community)  {
  abundances <- as.vector(sort(table(community), decreasing = TRUE))
  return(abundances)
}

# Question 14
octaves <- function(abundance_vector) {
  log_vector_floored <- floor(log2(abundance_vector))+1
  tabulation <- tabulate(log_vector_floored)
  return(tabulation)
}


# Question 15
sum_vect <- function(x, y) {
  max_length <- max(length(x), length(y))
  x <- c(x, rep(0, max_length - length(x)))
  y <- c(y, rep(0, max_length - length(y)))
  return(x + y)
}

# Question 16 
question_16 <- function() {
  sum1 <- vector()
  sum2 <- vector()
  communitymax <- init_community_max(100)
  communitymin <- init_community_min(100)
  duration <- 2200
  
  for (i in seq_len(duration)) {
  communitymax <- neutral_generation_speciation(communitymax,speciation_rate = 0.1)
  if (i >= 200 & i%%20 == 0) {
      y <-species_abundance(communitymax)
      k <- octaves(y)
      sum1 <- sum_vect(sum1,k)
    }
  } 
  sum1/100 # there are 100 different stages
  dataframe1 <- data.frame(sum1, c(1,2,3,4,5,6))
  colnames(dataframe1)[2] <- "octaves"

  for (i in seq_len(duration)) {
    communitymin <- neutral_generation_speciation(communitymin,speciation_rate = 0.1)
    if (i >= 200 & i%%20 == 0) {
      y <-species_abundance(communitymin)
      k <- octaves(y)
      sum2 <- sum_vect(sum2,k)
    }
  } 
  
  sum2/100 # there are 100 different stages
  dataframe2 <- data.frame(sum2, c(1,2,3,4,5,6))
  colnames(dataframe2)[2] <- "octaves"
  
  png(filename="question_16_max", width = 600, height = 400)
  ggplot(data = dataframe1, aes(x = octaves, y = sum1/100)) +
    geom_bar(stat = "identity", fill = "skyblue") +
    labs(x = "Abundance", y = "Mean Number of Species", title = "Mean Species Abundance for Each Octave")+theme_minimal()
  
  Sys.sleep(0.1)
  dev.off()
  
  png(filename="question_16_min", width = 600, height = 400)
  ggplot(data = dataframe2, aes(x = octaves, y = sum2/100)) +
    geom_bar(stat = "identity", fill = "skyblue") +
    labs(x = "Abundance", y = "Mean Number of Species", title = "Mean Species Abundance for Each Octave")+theme_minimal()
  
  Sys.sleep(0.1)
  dev.off()
  
  return("The initial condition of the system clearly does not matter as the relative  abundances after 2200 generations are very similar regardless of whether the populations started with a maximum or minimum possible species richness. This is because the relative abundances of species converge to a dynamic equilibrium.")
}

# Question 17
neutral_cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name) {
  t1 <- proc.time()[3]
  i <- 0
  community <- init_community_min(100)
  time_series <- vector()
  abundance_list <- list()
  
  while (proc.time()[3] - t1 < wall_time) {
    i <- i + 1 
    community <- neutral_generation_speciation(community, speciation_rate)
    if (i %% interval_rich == 0 & i < burn_in_generations) {
      SR <- species_richness(community)
      time_series <- c(time_series, SR)
    } 
    if (i %% interval_oct == 0) {
      x <- species_abundance(community)
      abundance_list <- c(abundance_list, octaves(x))
    }
  }
  
  total_time <- proc.time()[3] - t1
  save(time_series = time_series, abundance_list = abundance_list, community = community, total_time = total_time, file = output_file_name)
}

neutral_cluster_run(speciation_rate=0.1, size=100, wall_time=10, interval_rich=1, interval_oct=10, burn_in_generations=200, output_file_name="my_test_file_1234567.rda")

# Questions 18 and 19 involve writing code elsewhere to run your simulations on
# the cluster

# Question 20 
process_neutral_cluster_results <- function() {
  
  
  combined_results <- list() #create your list output here to return
  # save results to an .rda file
  
}

plot_neutral_cluster_results <- function(){
  
  # load combined_results from your rda file
  
  
  
  png(filename="plot_neutral_cluster_results", width = 600, height = 400)
  # plot your graph here
  Sys.sleep(0.1)
  dev.off()
  
  return(combined_results)
}


# Question 21
state_initialise_adult <- function(num_stages,initial_size){
  
}

# Question 22
state_initialise_spread <- function(num_stages,initial_size){
  
}

# Question 23
deterministic_step <- function(state,projection_matrix){
  
}

# Question 24
deterministic_simulation <- function(initial_state,projection_matrix,simulation_length){
  
}

# Question 25
question_25 <- function(){
  
  png(filename="question_25", width = 600, height = 400)
  # plot your graph here
  Sys.sleep(0.1)
  dev.off()
  
  return("type your written answer here")
}

# Question 26
multinomial <- function(pool,probs) {
  
}

# Question 27
survival_maturation <- function(state,growth_matrix) {
  
}

# Question 28
random_draw <- function(probability_distribution) {
  
}

# Question 29
stochastic_recruitment <- function(reproduction_matrix,clutch_distribution){
  
}

# Question 30
offspring_calc <- function(state,clutch_distribution,recruitment_probability){
  
}

# Question 31
stochastic_step <- function(state,growth_matrix,reproduction_matrix,clutch_distribution,recruitment_probability){
  
}

# Question 32
stochastic_simulation <- function(initial_state,growth_matrix,reproduction_matrix,clutch_distribution,simulation_length){
  
}

# Question 33
question_33 <- function(){
  
  
  
  png(filename="question_33", width = 600, height = 400)
  # plot your graph here
  Sys.sleep(0.1)
  dev.off()
  
  return("type your written answer here")
}

# Questions 34 and 35 involve writing code elsewhere to run your simulations on the cluster

# Question 36
question_36 <- function(){
  
  png(filename="question_36", width = 600, height = 400)
  # plot your graph here
  Sys.sleep(0.1)
  dev.off()
  
  return("type your written answer here")
}

# Question 37
question_37 <- function(){
  
  png(filename="question_37_small", width = 600, height = 400)
  # plot your graph for the small initial population size here
  Sys.sleep(0.1)
  dev.off()
  
  png(filename="question_37_large", width = 600, height = 400)
  # plot your graph for the large initial population size here
  Sys.sleep(0.1)
  dev.off()
  
  return("type your written answer here")
}

# Challenge questions - these are optional, substantially harder, and a maximum
# of 14% is available for doing them. 

# Challenge question A
Challenge_A <- function() {
  
  
  
  png(filename="Challenge_A_min", width = 600, height = 400)
  # plot your graph here
  Sys.sleep(0.1)
  dev.off()
  
  png(filename="Challenge_A_max", width = 600, height = 400)
  # plot your graph here
  Sys.sleep(0.1)
  dev.off()
  
}

# Challenge question B
Challenge_B <- function() {
  
  
  
  png(filename="Challenge_B", width = 600, height = 400)
  # plot your graph here
  Sys.sleep(0.1)
  dev.off()
  
}

# Challenge question C
Challenge_C <- function() {
  
  
  
  png(filename="Challenge_C", width = 600, height = 400)
  # plot your graph here
  Sys.sleep(0.1)
  dev.off()
  
}

# Challenge question D
Challenge_D <- function() {
  
  
  
  png(filename="Challenge_D", width = 600, height = 400)
  # plot your graph here
  Sys.sleep(0.1)
  dev.off()
  
  return("type your written answer here")
}

# Challenge question E
Challenge_E <- function(){
  
  
  
  png(filename="Challenge_E", width = 600, height = 400)
  # plot your graph here
  Sys.sleep(0.1)
  dev.off()
  
  return("type your written answer here")
}

# Challenge question F
Challenge_F <- function(){
  
  
  
  png(filename="Challenge_F", width = 600, height = 400)
  # plot your graph here
  Sys.sleep(0.1)
  dev.off()
  
}
