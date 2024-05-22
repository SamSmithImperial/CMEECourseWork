##############################
### Load Packages and Data ###
##############################

data <- read.csv("../data/sequences123.csv")

###############################
### Initialize empty matrix ###
###############################

Initialise_Matrix <- function(data) {
  PairwiseMatrix <- as.data.frame(matrix(nrow = nrow(data), ncol = nrow(data)))
  dimnames(PairwiseMatrix) <- list(data$Name, data$Name)
  return(PairwiseMatrix) 
}

Pairwise_Matrix <- Initialise_Matrix(data)

#######################################################
### Convert Character string sequences into vectors ###
#######################################################

for (i in 1:length(data$Sequence)) {
  data$Sequence[[i]] <- strsplit(data$Sequence[[i]], "")
}


#####################
### Compute Score ###
#####################

score <- function(seq1, seq2) {
  total_points <- 0
  length <- min(length(seq1), length(seq2))
  for (i in 1:length) {
    if (seq1[i] != "-" && seq2[i] != "-" && seq1[i] == seq2[i]) {
      total_points <- total_points + 1
    }
  }
  total_points <- total_points/length
  return(total_points)
}

############################
### Fill Pairwise Matrix ###
############################

fill_matrix <- function(data) {

for (i in 1:ncol(Pairwise_Matrix)){
  for (j in i:ncol(Pairwise_Matrix)) {
    
    seq1 <- data$Sequence[[i]][[1]]
    seq2 <- data$Sequence[[j]][[1]]
    
    score <- score(seq1, seq2)
    Pairwise_Matrix[i,j] <- score
  }
  if (i == 100) {
    print("i is 100!!")
  }
}
  Pairwise_Matrix[lower.tri(Pairwise_Matrix)] <- t(Pairwise_Matrix)[lower.tri(Pairwise_Matrix)]
  return(Pairwise_Matrix)
}

matrix <- fill_matrix(data)
write.csv(matrix, "../data/PairwiseMatrix.csv", row.names = FALSE)
