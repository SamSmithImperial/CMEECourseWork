################
### packages ###
################

library(flexclust)
library(cluster)

############################
## import data and scale ###
############################

data <- read.csv("../data/PairwiseMatrix.csv") # Matrix data for the kmeans
data_scaled <- scale(data)

SITE_100 <- read.csv("~/Documents/Project/data/SITE-100 Database - mitogenomes.csv")
SITE_100 <- SITE_100 %>% filter(!duplicated(SITE_100$mt_id))

seqs <- read.table("../data/complete_mt_ids.txt")
seqs$V1 <- gsub("\\.gb$", "", seqs$V1)
names(seqs)[names(seqs) == "V1"] <- "mt_id"


merged_df <- merge(SITE_100, seqs, by = "mt_id")
Cluster_df <- merged_df[, c("mt_id", "order", "suborder", "infraorder", "family")]

###################################
### SigClust Clustering Results ###
###################################

COX1_c6 <- read.csv("COX1_c6.cluster", header = FALSE)
COX1_c20 <- read.csv("COX1_c20.cluster", header = FALSE)


Cluster_df$SigClust_COX1_20 <- COX1_c20$V2
Cluster_df$SigClust_COX1_6 <- COX1_c6$V2


##########################
### k means clustering ###
##########################

### using two random columns ###

random_columns <- sample(2:ncol(data),2)
subset_df <- data[, random_columns]
gap_stat <- clusGap(subset_df, FUN = kmeans, K.max = 100, B = 10)
plot(gap_stat, main = "Gap Statistic")
result <- kmeans(subset_df, centers = 15, nstart = 20)
  
### using 15 random columns ###

random_columns <- sample(1:ncol(data),30)
subset_df <- data_scaled[, random_columns]
gap_stat <- clusGap(subset_df, FUN = kmeans, K.max = 100, B = 10)
plot(gap_stat, main = "Gap Statistic")
result2 <- kmeans(subset_df, centers = 6, nstart = 20)
 
###################################################   
### Method for finding how similar clusters are ###
###################################################

# cluster1 <- result$cluster
# cluster2 <- result2$cluster
# randIndex(cluster1, cluster2)

centers <- result2$centers

distances <- as.matrix(dist(rbind(centers, data)))

distances <- distances[-(1:nrow(centers)), 1:nrow(centers)]

closest_observations <- apply(distances, 2, function(column) {
  which.min(column)
})

