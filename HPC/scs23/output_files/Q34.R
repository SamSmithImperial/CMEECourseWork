rm(list=ls()) # good practice 
source("scs23_HPC_2023_main.R")

iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))

set.seed(iter)

file_output_name <- paste0("Q34_", iter, ".rda")

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

clutch_distribution <- c(0.06,0.08,0.13,0.15,0.16,0.18,0.15,0.06,0.03)

initial_state <- c(list(state_initialise_adult(4,100)), list(state_initialise_adult(4,10)), list(state_initialise_spread(4,100)), list(state_initialise_spread(4,10)))



if (iter >= 1 && iter <= 25) {
results_adult_big <- list()
  for (i in 1:150) {
    popsize <- stochastic_simulation(initial_state[[1]], growth_matrix, reproduction_matrix, clutch_distribution, 120)
    results_adult_big <- c(results_adult_big, list(popsize))
  }
  save(results_adult_big, file = file_output_name)
}

if (iter >= 26 && iter <= 50) {
results_adult_small <- list()
  for (i in 1:150) {
    popsize <- stochastic_simulation(initial_state[[2]], growth_matrix, reproduction_matrix, clutch_distribution, 120)
    results_adult_small <- c(results_adult_small, list(popsize))
  }
  save(results_adult_small, file = file_output_name)
}
if (iter >= 51 && iter <= 75) {
results_spread_big <- list()
  for (i in 1:150) {
    popsize <- stochastic_simulation(initial_state[[3]], growth_matrix, reproduction_matrix, clutch_distribution, 120)
    results_spread_big <- c(results_spread_big, list(popsize))
  }
  save(results_spread_big, file = file_output_name)
}
if (iter >= 76 && iter <= 100) {
results_spread_small <- list()
  for (i in 1:150) {
    popsize <- stochastic_simulation(initial_state[[4]], growth_matrix, reproduction_matrix, clutch_distribution, 120)
    results_spread_small <- c(results_spread_small, list(popsize))
  }
  save(results_spread_small, file = file_output_name)
}








