#!/usr/bin/env Rscript

# Script Name: Density_Plots.R
# Author: Sam Smith

# Packages 
library(ggplot2)

####################
### Load in Data ###
####################

seqnames <- read.csv("../data/Other/sequence_names.csv")
pairwisematrix <- read.csv("../data/PairwiseMatrices/PairwiseMatrix_k2p.csv", row.names = 1)
pairwisematrix <- pairwisematrix[as.character(seqnames$Sequence.Name), as.character(seqnames$Sequence.Name)]

submatrix_50_k2p_kmeans <- read.csv("../data/PairwiseMatrices/pm_k2p_50.csv", row.names = 1)
submatrix_100_k2p_kmeans <- read.csv("../data/PairwiseMatrices/pm_k2p_100.csv", row.names = 1)

sigclustK <- c(4, 5, 6, 7, 10, 15, 20, 25)
c_values <- c(200, 50)

for (c_val in c_values) {
  for (k_val in sigclustK) {
    file_path <- sprintf("../data/PairwiseMatrices/pm_K2P_%d_k%d.csv", c_val, k_val)
    var_name <- sprintf("sm_sg_c%d_k%d", c_val, k_val)
    assign(var_name, read.csv(file_path, row.names = 1))
  }
}

##############################
### Plot K2P Distributions ###
##############################

density_plots <- function(data, ...) {
  arg_names <- as.list(substitute(list(...)))[-1L] # -1L excludes first argument
  
  submatrices <- list(...)
  
  diag(data) <- NA
  data_values <- na.omit(as.vector(as.matrix(data)))
  
  combined_df <- data.frame(value = data_values, group = "Entire Pairwise Matrix")
  
  colors <- c("Entire Pairwise Matrix" = rgb(0, 0, 1, 0.5))
  fills <- c("Entire Pairwise Matrix" = rgb(0, 0, 1, 0.5))
  
  for (i in seq_along(submatrices)) {
    submatrix <- submatrices[[i]]
    diag(submatrix) <- NA
    submatrix_values <- na.omit(as.vector(as.matrix(submatrix)))
    
    group_label <- deparse(arg_names[[i]])
    combined_df <- rbind(combined_df, data.frame(value = submatrix_values, group = group_label))
    
    colors[[group_label]] <- rgb(1 - (i - 1) * 0.2, 0, i * 0.2, 0.5)
    fills[[group_label]] <- rgb(1 - (i - 1) * 0.2, 0, i * 0.2, 0.5)
  }
  
  p <- ggplot(combined_df, aes(x = value, fill = group, color = group)) +
    geom_density(alpha = 0.5, adjust = 1.7) +
    xlim(0.1, 0.5) +
    labs(title = "Distribution of Cluster Centers relative to entire Pairwise Matrix",
         x = "Values", y = "Density") +
    scale_fill_manual(values = fills) + scale_color_manual(values = colors) +
    theme_classic() + theme(legend.title = element_blank(),
                            legend.position = c(0.8, 0.8))
  p <- print(p)
  return(p)
}

for (c in c_values) {
  for (k in sigclustK) {
    variable_name <- sprintf("sm_sg_c%d_k%d", c, k)
    sm <- get(variable_name) 
    
    png(paste("../plots/", variable_name, ".png", sep = ""))
    density_plots(pairwisematrix, sm)
    graphics.off()
  }
}

