### load in pairwise matrix csv

library(cluster)
data <- read.csv("../data/PairwiseMatrix.csv")

###############################################
### Standardize Pairwise Matrix for K-means ###
###############################################

zst_PairwiseMatrix <- scale(data) # NB. no longer identity matrix and, direct pairs do not equal 1.

############################################
### k means - optimal number of clusters ###
############################################

### Elbow Method ###

for (i in 1:20) {
  kmeans_model <- kmeans(zst_PairwiseMatrix, centers = i, nstart = 10)
  wcss[i] <- kmeans_model$tot.withinss
}
plot(1:20, wcss, type = "b",
     main = "Elbow Method",
     xlab = "Number of Clusters (K)",
     ylab = "Within-Cluster Sum of Squares")

### Gap Statistic ###

gap_stat <- clusGap(zst_PairwiseMatrix, FUN = kmeans, K.max = 100, B = 100)
plot(gap_stat, main = "Gap Statistic")

### K means results ### 

result <- kmeans(PairwiseMatrix, centers = 5, nstart = 10)
