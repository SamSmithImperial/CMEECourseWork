# CMEE 2022 HPC exercises R code main pro forma
# You don't HAVE to use this but it will be very helpful.
# If you opt to write everything yourself from scratch please ensure you use
# EXACTLY the same function and parameter names and beware that you may lose
# marks if it doesn't work properly because of not using the pro-forma.
library(ggplot2)
library(gridExtra)

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
  unique <- unique(community) # number of unique values
  SR <- length(unique)
  return(SR)
}

# Question 2
# Function to initialize a community with values increasing from 1 to size
init_community_max <- function(size){
  output <- seq(1,size,1)
  return(output)
}

# Question 3
# Function to initialize a community with all values set to 1
init_community_min <- function(size){
  output <- rep(1, size)
  return(output)
}

# Question 4
# Function to choose two random numbers between 1 and max_value, ensuring they are different
choose_two <- function(max_value){
  num1 <- sample(1:max_value,1)
  num2 <- sample(setdiff(1:max_value, num1),1)
  return(c(num1,num2))
}

# Question 5
# Function to perform neutral step in community where one individual in the community is replaced by another different member of the community
neutral_step <- function(community){
  maxvalue <- length(community)
  twonums <- choose_two(max_value = maxvalue)
  community[twonums[1]] = community[twonums[2]]
  return(community)
}

# Question 6
# Simulating several steps whereby one generation is assumed to be the number of inds/2
neutral_generation <- function(community){
  length <- length(community)+sample(c(0-length(community)%%2,length(community)%%2),1) # this line chooses at random whether to round up or down in the number of individuals is an odd number
  gentime <- round(length/2,0)
  for (i in seq_len(gentime)) {
  community <- neutral_step(community)
  }
  return(community)
}

# Question 7
# This function generates a series of species richness values for each generation that passes
neutral_time_series <- function(community,duration)  {
  SR <- length(unique(community)) # initial species richness
  for (i in seq_len(duration)){
    community <- neutral_generation(community)
    SR <- c(SR,length(unique(community))) # Species Richness is the Length of unique values
  }
  return(SR)
}

  # Question 8
question_8 <- function() {
  community <- init_community_max(100) # Community with Maximum Species Richness
  timeseries <- seq(0,200,1)
  SRs <- neutral_time_series(community = community, duration = 200)
  df <- data.frame(timeseries, SRs)
  png(filename="Plots/question_8", width = 600, height = 400)
  ggplot(df,aes(timeseries, SRs))+geom_line()+theme_classic()+theme(aspect.ratio = 1)+xlab("Number of Generations")+ylab("Species Richness")+ggtitle("Species Richness over 200 generations of a Neutral Model Simulation")
  Sys.sleep(0.1)
  dev.off()
  
  return("The community system will always converge to a species richness of one. This is because the random extinction of a species results in the random increase in an alternative species abundance. The increase in abundance of one species in turn further increases its likelihood of replacing another extinct species. Therefore this 'positive feedback' results in one species totally dominating.")
}

# Question 9
neutral_step_speciation <- function(community,speciation_rate)  {
  RandomNumber <- runif(1)
  if (RandomNumber>speciation_rate){ # If the random number (between 0 and 1) is more than the speciation rate than there is no speciation event
    return(neutral_step(community))
  } else {
    maxvalue <- length(community)
    twonums <- choose_two(max_value = maxvalue)
    community[twonums[1]] = max(community)+1 # This line of code ensures that the new species has a different value to all of the current numbers in the community
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
  
  communitymax <- init_community_max(100)
  communitymin <- init_community_min(100)

  timeseries <- seq(1,201,1)
  SRsMax <- neutral_time_series_speciation(community = communitymax, duration = 200, speciation_rate = 0.1)
  SRsMin <- neutral_time_series_speciation(community = communitymin, duration = 200, speciation_rate = 0.1)
  
  df <- data.frame(timeseries, SRsMax, SRsMin)
  png(filename="Plots/question_12", width = 600, height = 400)
  ggplot(df, aes(timeseries)) +
    geom_line(aes(y = SRsMax, color = "Maximum"), size = 1.2) +
    geom_line(aes(y = SRsMin, color = "Minimum"), size = 1.2) +
    
    labs(title = "Species Richness for Different Initial Communities",
         x = "Generations",
         y = "Species Richness") +
    
    theme_classic() +
    theme(axis.text = element_text(size = 12),
          axis.title = element_text(size = 14),
          plot.title = element_text(size = 16, face = "bold"),
          legend.text = element_text(size = 12),
          legend.position = c(0.8, 0.8),
          aspect.ratio = 0.8) +
    
    scale_color_manual(name = "Initial Pop Species Richness",
                       values = c("Maximum" = "blue", "Minimum" = "red"),
                       labels = c("Maximum", "Minimum"))
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
  sum1 <- vector() # initialise empty vectors 
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
  dataframe1 <- data.frame(sum1, c("1","2-3","4-7","8-15","16-31", "32-63")) # make dataframe including octave labels before plotting
  colnames(dataframe1)[2] <- "octaves"

  for (i in seq_len(duration)) {
    communitymin <- neutral_generation_speciation(communitymin,speciation_rate = 0.1)
    if (i >= 200 & i%%20 == 0) {
      y <-species_abundance(communitymin)
      k <- octaves(y)
      sum2 <- sum_vect(sum2,k)
    }
  } 
  
  dataframe2 <- data.frame(sum2, c("1","2-3","4-7","8-15","16-31", "32-63"))
  colnames(dataframe2)[2] <- "octaves"
  
  png(filename="Plots/question_16_max", width = 600, height = 400)
  ggplot(data = dataframe1, aes(x = reorder(octaves, -sum1/100), y = sum1/100)) +
    geom_bar(stat = "identity", fill = "skyblue") +
    labs(x = "Abundance", y = "Mean Number of Species", title = "Mean Species Abundance for Each Octave")+theme_classic()+theme(aspect.ratio = 1)
  Sys.sleep(0.1)
  dev.off()
  
  png(filename="Plots/question_16_min", width = 600, height = 400)
  ggplot(data = dataframe2, aes(x = reorder(octaves, -sum2/100), y = sum2/100)) + # reorder function is used here to plot bars in descending order. which also corresponds to increasing octave size
    geom_bar(stat = "identity", fill = "skyblue") +
    labs(x = "Abundance", y = "Mean Number of Species", title = "Mean Species Abundance for Each Octave")+theme_classic()+theme(aspect.ratio = 1)
  
  Sys.sleep(0.1)
  dev.off()
  
  return("The initial condition of the system clearly does not matter as the relative  abundances after 2200 generations are very similar regardless of whether the populations started with a maximum or minimum possible species richness. This is because the relative abundances of species converge to a dynamic equilibrium.")
}

# Question 17
neutral_cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name) {
  t1 <- proc.time()[3]
  i <- 0
  community <- init_community_min(size)
  time_series <- vector()
  abundance_list <- list()
  
  while (proc.time()[3] - t1 < wall_time*60) {
    i <- i + 1 # this code is necessary for a while loop as i is not defined as in for loops
    community <- neutral_generation_speciation(community, speciation_rate)
    if (i %% interval_rich == 0 & i < burn_in_generations) {
      SR <- species_richness(community)
      time_series <- c(time_series, SR)
    } 
    if (i %% interval_oct == 0) { # modulos are used so that if modulo zero is equal to zero then i must be a multiple of the interval_oct value
      x <- species_abundance(community)
      abundance_list <- c(abundance_list, list(octaves(x)))
    }
  }
  
  total_time <- proc.time()[3] - t1
  save(
    time_series = time_series,
    abundance_list = abundance_list,
    community = community,
    total_time = total_time,
    speciation_rate = speciation_rate,
    size = size,
    wall_time = wall_time,
    interval_rich = interval_rich,
    interval_oct = interval_oct,
    burn_in_generations = burn_in_generations,
    file = output_file_name
  )
}

# Questions 18 and 19 involve writing code elsewhere to run your simulations on
# the cluster

# Question 20 
process_neutral_cluster_results <- function() {
  
  list500 <- list()
  list1000 <- list()
  list2500 <- list()
  list5000 <- list()
  s500 <- vector()
  s1000 <- vector()
  s2500 <- vector()
  s5000 <- vector()
  
  for (i in 1:100){
    load(paste0("HPC_CLUSTER_",i,".rda"))
    if (size == 500) {
      
      # burn in generations is divided by interval oct to work out how many indexes to remove before making the list of abundances
      
      indexs_to_remove <- burn_in_generations/interval_oct 
      abundance_list <- abundance_list[-seq_len(indexs_to_remove)] # remove burn in generations
      list500 <- c(list500, abundance_list)
        for (j in 1:length(list500)){
          octave <- list500[[j]]
          s500 <- sum_vect(s500, octave)
        }
    }
    if (size == 1000) {
      indexs_to_remove <- burn_in_generations/interval_oct 
      abundance_list <- abundance_list[-seq_len(indexs_to_remove)]
      list1000 <- c(list1000, abundance_list)
      for (j in 1:length(list1000)){
        octave <- list1000[[j]]
        s1000 <- sum_vect(s1000, octave)
      }
    }
    if (size == 2500) {
      indexs_to_remove <- burn_in_generations/interval_oct 
      abundance_list <- abundance_list[-seq_len(indexs_to_remove)]
      list2500 <- c(list2500, abundance_list)
      for (j in 1:length(list2500)){
        octave <- list2500[[j]]
        s2500 <- sum_vect(s2500, octave)
      }
    }
    if (size == 5000) {
      indexs_to_remove <- burn_in_generations/interval_oct
      abundance_list <- abundance_list[-seq_len(indexs_to_remove)]
      list5000 <- c(list5000, abundance_list)
      for (j in 1:length(list5000)){
        octave <- list5000[[j]]
        s5000 <- sum_vect(s5000, octave)
      }
    }
  }
  
  s500 <- s500/(length(list500)) # make averages by dividing by the length of the lists
  s1000 <- s1000/(length(list1000))
  s2500 <- s2500/(length(list2500))
  s5000 <- s5000/(length(list5000))

  combined_results <- list(s500, s1000, s2500, s5000)
  save(combined_results, file = "Q20.rda") # save to rda file
  
}

plot_neutral_cluster_results <- function(){
  
  load("output_files/Q20.rda") # reload rda file previously saved
  s500 <- combined_results[[1]]
  s1000 <- combined_results[[2]]
  s2500 <- combined_results[[3]]
  s5000 <- combined_results[[4]]
  
  octaves1 <- c("1","2-3","4-7","8-15","16-31","32-63","64-127","128-255","256-511") # octave x axis values
  df1 <- data.frame(s500,octaves1) # make data frame for easy plotting in ggplot
  p1 <- ggplot(df1, aes(x = reorder(octaves1,-s500), y = s500)) +
    geom_bar(stat = "identity", fill = "lightgreen") +
    labs(title = "Community Size: 500",
         x = "Species Abundance",
         y = "Number of Species") +
    theme_classic()+theme(aspect.ratio = 0.65)+theme(axis.text.x = element_text(angle = 35, hjust = 1))
  
  octaves2 <- c("1","2-3","4-7","8-15","16-31","32-63","64-127","128-255","256-511","512-1023")
  df2 <- data.frame(s1000,octaves2)
  p2 <- ggplot(df2, aes(x = reorder(octaves2,-s1000), y = s1000)) +
    geom_bar(stat = "identity", fill = "orange") +
    labs(title = "Community Size: 1000",
         x = "Species Abundance",
         y = "Number of Species") +
    theme_classic()+theme(aspect.ratio = 0.65)+theme(axis.text.x = element_text(angle = 35, hjust = 1))
  
  octaves3 <- c("1","2-3","4-7","8-15","16-31","32-63","64-127","128-255","256-511","512-1023","1024-2047")
  df3 <- data.frame(s2500,octaves3)
  p3 <- ggplot(df3, aes(x = reorder(octaves3,-s2500), y = s2500)) +
    geom_bar(stat = "identity", fill = "violet") +
    labs(title = "Community Size: 2500",
         x = "Species Abundance",
         y = "Number of Species") +
    theme_classic()+theme(aspect.ratio = 0.65)+theme(axis.text.x = element_text(angle = 35, hjust = 1))
  
  
  df4 <- data.frame(s5000,octaves3)
  p4 <- ggplot(df4, aes(x = reorder(octaves4,-s5000), y = s5000)) +
    geom_bar(stat = "identity", fill = "pink") +
    labs(title = "Community Size: 5000",
         x = "Species Abundance",
         y = "Number of Species") +
    theme_classic()+theme(aspect.ratio = 0.65)+theme(axis.text.x = element_text(angle = 35, hjust = 1))
  
  
  png(filename="Plots/plot_neutral_cluster_results", width = 600, height = 400)
  grid.arrange(p1,p2,p3,p4) # grid arrange function make a panel with 4 plots
  Sys.sleep(0.1)
  dev.off()
  
  return(combined_results)
}


# Question 21
state_initialise_adult <- function(num_stages,initial_size){
  state_vector <- rep(0, num_stages)
  state_vector[num_stages] <- initial_size
  return(state_vector)
}


# Question 22
state_initialise_spread <- function(num_stages,initial_size){
  state_vector2 <- rep(floor(initial_size/num_stages), num_stages)
  remaining <- initial_size %% num_stages
  if (remaining >= 1){ # only add 1 remaining values if there are any!!
  state_vector2[1:remaining] <- state_vector2[1:remaining]+1
  }
  return(state_vector2)
}

# Question 23
deterministic_step <- function(state,projection_matrix){
  new_state <- projection_matrix %*% state # %*% is used for matrix multiplication
  return(new_state)
}

# Question 24
deterministic_simulation <- function(initial_state, projection_matrix, simulation_length) {
  new_state <- initial_state
  population_size <- c(sum(initial_state))
  
  for (i in 1:simulation_length) {
    new_state <- deterministic_step(new_state, projection_matrix)
    population_size <- c(population_size, sum(new_state))
  }
  return(population_size)
}

# Question 25
question_25 <- function(){
  
  growth_matrix <- matrix(c(0.1,0.0,0.0,0.0,
                            0.5,0.4,0.0,0.0,
                            0.0,0.4,0.7,0.0,
                            0.0,0.0,0.25,0.4),
                          nrow = 4, ncol = 4, byrow = T)
  
  reproduction_matrix <- matrix(c(0.0,0.0,0.0,2.6,
                                  0.0,0.0,0.0,0.0,
                                  0.0,0.0,0.0,0.0,
                                  0.0,0.0,0.0,0.0),
                                nrow = 4, ncol = 4, byrow = T)
  
  projection_matrix <- reproduction_matrix + growth_matrix
  
  AdultPop <- deterministic_simulation(state_initialise_adult(4,100), projection_matrix, 24)
  EqualPop <- deterministic_simulation(state_initialise_spread(4,100), projection_matrix, 24)
  timepoints <- seq(0,24,1)
  df <- data.frame(timepoints, AdultPop, EqualPop)
  
  plot25 <- ggplot(data = df, aes(x = timepoints)) +
    geom_line(aes(y = AdultPop, color = "Adult"), size = 1.2) +
    geom_line(aes(y = EqualPop, color = "Equal"), size = 1.2) +
   theme_classic() +
    labs(title = "Deterministic Population Growth for Different Initial Populations",
         x = "Generations",
         y = "Population Size",
         color = "")+
    theme(legend.position = c(0.2, 0.8), aspect.ratio = 1, legend.text = element_text(size = 15))
  png(filename="Plots/question_25", width = 600, height = 400)
  plot25
  Sys.sleep(0.1)
  dev.off()
  
  return("The initial population distribution changes the initial and eventual population growth. The adult population showed a greater initial increase in popultation growth due to the greater number of individuals capable of producing offspring - thus resulting in an initial increase in population. The Population consequently decreases due to no available adults to generate offspring whilst a mortility rate still affecting the new offspring. The Population eventually grows again and stabalises as all life stages are filled of individuals. The equal population also shows an initial increase in population growth due to the availability of adults capable of generating offspring. It then shows a slight dip as the number adults is now relativlely less than the previous generation. However, once the populations stabalise and reach a demographic equilibrium, they both show exponential growth.")
}

# Question 26
multinomial <- function(pool,probs) {
  if (sum(probs) > 1) {
    stop("Sum of probabilities must be less than 1.")
  }
  death_prob <- 1 - sum(probs) # probability of death is the 1 minus the sum of all the probabilities of not dying!
  probs <- c(probs, death_prob)
  outcome <- rmultinom(n = 1, size = pool, prob = probs)
  outcome <- as.vector(outcome) # vectorize outcome
  outcome <- outcome[-length(outcome)] # remove final index
  return(outcome)
}



# Question 27
survival_maturation <- function(state,growth_matrix) {
  new_state <- rep(0,length(state)) # make a vector of just zeros with the same length as the input state
  for (i in 1:length(state)) {
    num_ind <- state[i]
    probabilities <- growth_matrix[ ,i]
    new_state1 <- multinomial(num_ind, probabilities)
    new_state <- sum_vect(new_state, new_state1) # add the zero vector ta make sure that the new_state is the same length as the input state
  }
  return(new_state)
}


# Question 28
random_draw <- function(probability_distribution) {
  vector <- 1:length(probability_distribution)
  draw <- sample(vector, size = 1, prob = probability_distribution)
  return(draw)
}

# Question 29
stochastic_recruitment <- function(reproduction_matrix,clutch_distribution){
  top_right_value <- reproduction_matrix[1,ncol(reproduction_matrix)]
  expected_clutch_size <- sum(clutch_distribution*(1:length(clutch_distribution)))
  recruitment_prob <- top_right_value/expected_clutch_size
  return(recruitment_prob)
}


# Question 30
offspring_calc <- function(state,clutch_distribution,recruitment_probability){
  num_adults <- state[length(state)]
  num_recruits <- rbinom(n = 1, size = num_adults, prob = recruitment_probability)
  if (num_recruits == 0) {
    return(NULL)
  }
  offspring <- vector()
  for (i in 1:num_recruits) {
    offspring <- c(offspring, random_draw(clutch_distribution))
  }
  total_offspring <- sum(offspring)
  return(total_offspring)
}



# Question 31
stochastic_step <- function(state,growth_matrix,reproduction_matrix,clutch_distribution,recruitment_probability){
  new_state <- survival_maturation(state, growth_matrix)
  total_offspring <- offspring_calc(new_state, clutch_distribution, recruitment_probability)
  new_state <- sum_vect(as.vector(total_offspring), new_state) # add the total offspring as a vector of length one to the first stage of the new_state
  return(new_state)
}



# Question 32
stochastic_simulation <- function(initial_state,growth_matrix,reproduction_matrix,clutch_distribution,simulation_length){
  recruitment_P <- stochastic_recruitment(reproduction_matrix,clutch_distribution)
  state <- initial_state
  population_sizes <- c(sum(initial_state))
  zeros <- rep(0, (simulation_length+1))
  for (i in 1:simulation_length) {
    if (sum(state) == 0) { # if the population becomes extinct then stop the simulation
      break 
    }
    state <- stochastic_step(state, growth_matrix, reproduction_matrix, clutch_distribution, recruitment_P)
    population_sizes <- c(population_sizes, sum(state))
  }
  population_sizes <- sum_vect(population_sizes, zeros) # ensure that all populations that went extinct have the same pop size length as the non extinct populations. ie. just add zeros to extinct populations so all vectors are the same length
  return(population_sizes)
}


# Question 33
question_33 <- function(){
  
  growth_matrix <- matrix(c(0.1,0.0,0.0,0.0,
                            0.5,0.4,0.0,0.0,
                            0.0,0.4,0.7,0.0,
                            0.0,0.0,0.25,0.4),
                          nrow = 4, ncol = 4, byrow = T)
  
  reproduction_matrix <- matrix(c(0.0,0.0,0.0,2.6,
                                  0.0,0.0,0.0,0.0,
                                  0.0,0.0,0.0,0.0,
                                  0.0,0.0,0.0,0.0),
                                nrow = 4, ncol = 4, byrow = T)
  
  clutch_distribution <- c(0.06,0.08,0.13,0.15,0.16,0.18,0.15,0.06,0.03)
  
  timepoints <- seq(0,24,1)
  
  adultpop <- state_initialise_adult(4,100)
  equalpop <- state_initialise_spread(4,100)
  
  adultpoints <- stochastic_simulation(adultpop, growth_matrix, reproduction_matrix, clutch_distribution, 24)
  equalpoints <- stochastic_simulation(equalpop, growth_matrix, reproduction_matrix, clutch_distribution, 24)
  
  df <- data.frame(timepoints, adultpoints, equalpoints)
  png(filename="Plots/question_33", width = 600, height = 400)
  ggplot(data = df, aes(x = timepoints)) +
    geom_line(aes(y = adultpoints, color = "Adult Points"), size = 1) +
    geom_line(aes(y = equalpoints, color = "Equal Points"), size = 1) +
    theme_classic() +
    theme(aspect.ratio = 1) +
    xlab("Simulation Length") +
    ylab("Population Size") +
    labs(title = "Population Size Over 25 Stochastic Simulations") +
    scale_color_manual(values = c("blue", "red"),
                       labels = c("Adult Points", "Equal Points"))+
    labs(color = NULL)+theme(legend.position = c(0.2,0.9))
  
   Sys.sleep(0.1)
  dev.off()
  
  return("The earlier deterministic simulations produced smoother line graphs. This is because the stochastic simulations introduce randomness. The deterministic simulations are simply the product of the projection matrix whereas the stochastic simulations have randomness at each generations which changes the trajectory of the line as population sizes do not follow a set trend. In addition, the deterministic step does not round to whole numbers therefore the line will be smoother.")
}


# Questions 34 and 35 involve writing code elsewhere to run your simulations on the cluster

# Question 36
question_36 <- function(){
  
  RAB <- list() # initialise empty lists
  RAS <- list()
  RSB <- list()
  RSS <- list() 
  
  for (i in 1:25){
    load(paste0("output_files/Q34_", i, ".rda"))
    RAB <- c(RAB, list(results_adult_big))
  }
  for (i in 26:50){
    load(paste0("output_files/Q34_", i, ".rda"))
    RAS <- c(RAS, list(results_adult_small))
  }
  for (i in 51:75){
    load(paste0("output_files/Q34_", i, ".rda"))
    RSB <- c(RSB, list(results_spread_big))
  }
  for (i in 76:100){
    load(paste0("output_files/Q34_", i, ".rda"))
    RSS <- c(RSS, list(results_spread_small))
  }
  
  # unlist them and then seperatee into chunks of the same length so that there is one list rather than a list of lists!
  
  RABB <- unlist(RAB) 
  RASS <- unlist(RAS)
  RSBB <- unlist(RSB)
  RSSS <- unlist(RSS)
  
  chunk_size <- 121
  num_chunks <- 3750 
  
  list_of_vectors_RAB <- split(RABB, rep(1:num_chunks, each = chunk_size, length.out = length(RABB)))
  list_of_vectors_RAS <- split(RASS, rep(1:num_chunks, each = chunk_size, length.out = length(RASS)))
  list_of_vectors_RSB <- split(RSBB, rep(1:num_chunks, each = chunk_size, length.out = length(RSBB)))
  list_of_vectors_RSS <- split(RSSS, rep(1:num_chunks, each = chunk_size, length.out = length(RSSS)))
  
  # if a population contains a zero then an extinction event has certainly happened!
  
  contains_zero_RAB <- sapply(list_of_vectors_RAB, function(x) any(x == 0)) # which populations contain a zero
  contains_zero_RAS <- sapply(list_of_vectors_RAS, function(x) any(x == 0)) 
  contains_zero_RSB <- sapply(list_of_vectors_RSB, function(x) any(x == 0)) 
  contains_zero_RSS <- sapply(list_of_vectors_RSS, function(x) any(x == 0)) 
  
  proportion_RAB <- sum(contains_zero_RAB)/3750
  proportion_RAS <- sum(contains_zero_RAS)/3750
  proportion_RSB <- sum(contains_zero_RSB)/3750
  proportion_RSS <- sum(contains_zero_RSS)/3750
  
  xaxis <- c("Large Adult Pop", "Small Adult Pop", "Large Spread Pop", "Small Spread Pop")
  yaxis <- c(proportion_RAB, proportion_RAS, proportion_RSB, proportion_RSS)
  data <- data.frame(Category = xaxis, Proportion = yaxis)
  
  png(filename="Plots/question_36", width = 600, height = 400)
  ggplot(data, aes(x = Category, y = Proportion, fill = Category)) +
    geom_bar(stat = "identity") +
    labs(title = "Extinction Likelihood per Stochastic Simulation for each Population",
         x = "Population",
         y = "Proportion") +
    theme_classic()+theme(aspect.ratio = 1)+theme(axis.text.x = element_text(angle = 35, hjust = 1), legend.position = "none")
  Sys.sleep(0.1)
  dev.off()

  return("The Small Adult Population was most likely to go extinct with a proportion of extinctions of over 0.3 as shown in the graph. Therefore, roughly a thrid of all the small adult simulations resulted in a final population size of zero. Fistly, the stochastic nature of the similulation is likely to have potentially more severe implications on small populations as unfortunate decreases in reproduction or increases in death rate may result in extinction rather than jsut a population decline as in larger populations. Secondly, I can not provide any biological reasoning as to why the adult populations went extinct more often than the small spread population. I would have expected the small spread to go extinct more often as there is a mortality rate on individuals who are not yet adults and therefore some individuals are likely to die before there is any chance of producing any offspring. I suggest the random nature of these simulations resulted in this unexpected outcome.")
}

# Question 37
question_37 <- function(){
  
  
  average_RSB <- vector()
  average_RSS <- vector()
  
  for (i in 1:length(RSB)){
    for (j in 1:length(RSB[[i]]))
      average_RSB <- sum_vect(average_RSB, RSB[[i]][[j]])
  }
  for (i in 1:length(RSS)){
    for (j in 1:length(RSS[[i]]))
      average_RSS <- sum_vect(average_RSS, RSS[[i]][[j]])
  }

  # 3750 is the number of simulations for each community size
  
  average_RSB <- average_RSB/3750
  average_RSS <- average_RSS/3750
  
  
  initial_state1 <- state_initialise_spread(4,100)
  initial_state2 <- state_initialise_spread(4,10)
  
  
  sam1 <- deterministic_simulation(initial_state1, projection_matrix, 120)
  sam2 <- deterministic_simulation(initial_state2, projection_matrix, 120)
  
  
  plottingvectorRSB <- average_RSB/sam1
  plottingvectorRSS <- average_RSS/sam2
  
  timepoints <- seq(0,120,1)
  df <- data.frame(timepoints, plottingvectorRSB, plottingvectorRSS)
  plot <- ggplot(data = df) +
    geom_line(aes(x = timepoints, y = plottingvectorRSB, color = "100"), size = 1.1) +
    geom_line(aes(x = timepoints, y = plottingvectorRSS, color = "10"), size = 1.1) +
    geom_hline(yintercept = 1, linetype = "dashed", color = "black") +
    labs(title = "Deviation Ratio of mean Stochastic and Deterministic Model Population Sizes",
         x = "Number of Generations",
         y = "Stochastic Population / Deterministic Population",
         color = "Initial Population Size") +
    scale_color_manual(values = c("100" = "blue", "10" = "red")) +
    theme_classic() +
    theme(aspect.ratio = 1, legend.position = c(0.2, 0.9))
  
  

  png(filename="Plots/question_37", width = 600, height = 400)
  plot
  Sys.sleep(0.1)
  dev.off()
  
  return("The initial condition that is most appropriate to approximate the 'average' behaviour of this stochastic system with a deterministic model would be shown by the line that remains closest to the dashed line on the graph. The line that is overall closest to y=1 resembles the line which deviates less from the deterministic model. It seems that over time both population sizes increasingly deviate from the deterministic model. This is hard to explain in biological terms as one would expect deviations to decrease over time for both models and therefore, i would expect both lines to converge to y=1. I expect deviations to decrease over time because as the populations get larger they are less affected by the stochasticity and therefore would be more easily predicted by the deterministic model. It seems in this case that a deterministic model would better predict a small initial population size (red line) as it is slightly closer overall the y=1.")
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

