#!/usr/bin/env Rscript

# Script Name: SigClust_centers.R
# Author: Sam Smith
# Description: This Script finds cluster centers using a pairwise matrix

###############################
### Load in data & packages ###
###############################

library(patchwork)
library(ggplot2)
library(cluster)

seqnames <- read.csv("../data/Other/sequence_names.csv")
pairwisematrix <- read.csv("../data/PairwiseMatrices/PairwiseMatrix_k2p.csv", row.names = 1)
pairwisematrix <- pairwisematrix[as.character(seqnames$Sequence.Name), as.character(seqnames$Sequence.Name)]
Site100 <- read.csv("../data/Other/SITE-100 Database - mitogenomes.csv")
Site100 <- Site100[Site100$mt_id %in% rownames(pairwisematrix), ]

# remove <- c('BIOD04715', 'BIOD04993', 'GBDL01032', 'BIOD00989')
# data <- data[!(rownames(data) %in% remove), ]
# data <- data[, !(colnames(data) %in% remove)]

#############################
### Find SigClust Centers ###
#############################

sigclustK <- c(4,5,6,7,10,15,20,25)

for (i in sigclustK) {
  
  centers <- c()
  
  sigclusts <- read.csv(paste("../data/Sig_Clusters/COX1_200_k", i, ".csv", sep = ""), header = FALSE)
  pairwisematrix$clusters <- sigclusts$V2
  
  unique_clusters <- unique(pairwisematrix$clusters)
  
  for (j in unique_clusters) {
    cluster_sequences <- rownames(pairwisematrix[pairwisematrix$clusters == j,])
    df <- pairwisematrix[cluster_sequences, cluster_sequences, drop = FALSE] # subset pairwise matrix
    
    df$clusters <- NULL
    row_averages <- rowMeans(df, na.rm = TRUE)
    
    most_similar_index <- which.max(row_averages)
    most_similar_observation <- rownames(df)[most_similar_index]
    
    centers <- c(centers, most_similar_observation)
    
    centers_name <- paste("Centers_200_k", i, sep = "")
    assign(centers_name, centers)

    subset_name <- paste("Site100_subset_", i, sep = "")
    assign(subset_name, Site100[Site100$mt_id %in% centers, ])
    pairwise_submatrix <- pairwisematrix[centers,centers, drop = FALSE]
    
    write.table(centers, file = paste("../data/Sig_Clusters/200_k2p_k", i , "_centers.txt", sep = ""), row.names = FALSE, col.names = FALSE)
    write.csv(pairwise_submatrix, file = paste("../data/PairwiseMatrices/pm_K2P_200_k",i,".csv", sep = ""))
    
  }
}

#######################
### Plot Bar Charts ###
#######################

plot_bars <- function(taxa) {

  for (i in sigclustK) {
    plotname <- paste("p", i, sep = "")
    
    data_name <- paste("Site100_subset_", i, sep = "")
    data <- get(data_name)
    
    plot <- ggplot(data, aes(x = {{taxa}})) +
      geom_bar(fill = "blue") +
      labs(title = paste("200 Cluster Centers k", i, sep = ""),
           x = "Superfamily",
           y = "Frequency") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    assign(plotname, plot)
  }
  
  pdata <- ggplot(Site100, aes(x = {{taxa}})) +
    geom_bar(fill = "red") +
    labs(title = "Total Data Set",
         x = "Superfamily",
         y = "Frequency") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  pdata + p4 + p5 + p6 + p7 + p10 + p15 + p20 + p25
  
}

# end of script