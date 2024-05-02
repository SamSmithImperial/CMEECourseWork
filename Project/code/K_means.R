### load in pairwise matrix csv

###############################################
### Standardize Pairwise Matrix for K-means ###
###############################################

zst_PairwiseMatrix_Seq <- scale(PairwiseMatrix_Sequence) # NB. no longer identity matrix and, direct pairs do not equal 1.

############################################
### k means - optimal number of clusters ###
############################################

### Elbow Method ###

wcss <- numeric(10)  
for (i in 1:10) {
  kmeans_model <- kmeans(zst_PairwiseMatrix_Seq, centers = i, nstart = 10)
  wcss[i] <- kmeans_model$tot.withinss
}
plot(1:10, wcss, type = "b",
     main = "Elbow Method",
     xlab = "Number of Clusters (K)",
     ylab = "Within-Cluster Sum of Squares")

### Gap Statistic ###

gap_stat <- clusGap(zst_PairwiseMatrix_Seq, FUN = kmeans, K.max = 10, B = 50)
plot(gap_stat, main = "Gap Statistic")

### K means results ### 

result <- kmeans(PairwiseMatrix, centers = 5, nstart = 10)
