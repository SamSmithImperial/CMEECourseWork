# CMEE 2022 HPC exercises R code pro forma
# For neutral model cluster run

rm(list=ls()) # good practice 
source("scs23_HPC_2023_main.R")

iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))

set.seed(iter)

communitysizes <- c(500,1000,2500,5000)

speciationrate <- 0.006996
  
samsfilename <- paste0("HPC_CLUSTER_",iter,".rda",sep="")

neutral_cluster_run(speciationrate = speciationrate, size = communitysizes[iter %% 4+1], wall_time = 690, interval_rich = 1, interval_oct = communitysizes[iter %% 4+1]/10, burn_in_generations = 8*communitysizes[iter %% 4+1], output_file_name = samsfilename)
