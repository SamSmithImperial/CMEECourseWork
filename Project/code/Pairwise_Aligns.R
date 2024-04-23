library(Biostrings)

########################################################
### Load Data, Rename Column & Remove File extension ##
########################################################

data <- read.csv("../data/sequences.csv")
colnames(data)[which(colnames(data) == 'FileName')] <- 'Mito_ID'
attach(data)

####################################
### Pairwise Alignments Function ###
####################################

Pairwise_Score_Function <- function(seq1, seq2) {
  alignment <- pairwiseAlignment(seq1, seq2) # Perform Alignment
  
  aligned_seq2 <- subject(alignment) # Extract Alignments including gap characters
  aligned_seq1 <- pattern(alignment)
  
  vector_aligned_s2 <- as.vector(as.character(aligned_seq2[1])) # Vectorise the Sequences
  vector_aligned_s1 <- as.vector(as.character(aligned_seq1[1]))
  
  individual_letters_seq2 <- strsplit(vector_aligned_s2, "")[[1]] # Split String into Individual Characters
  individual_letters_seq1 <- strsplit(vector_aligned_s1, "")[[1]]
  
  array_seq2 <- unlist(individual_letters_seq2) # Turn Sequences into Arrays to make Matrix
  array_seq1 <- unlist(individual_letters_seq1)
  
  Align_Matrix <- rbind(array_seq1,array_seq2) # Create Pairwise Matrix
  AlignLength <- ncol(Align_Matrix) # Length of Alignment - used to calculate percentage similarity
  num_matches <- sum(Align_Matrix[1, ] == Align_Matrix[2, ] & Align_Matrix[1, ] != "-") #
  Score <- num_matches/AlignLength
  
  return(Score)
}

############################################
### Pairwise Score Data Frame using COX1 ###
############################################

data1 <- head(data)

PairwiseMatrix <- data.frame(matrix(nrow = nrow(data1), ncol = nrow(data1)))
SquareDFSize <- nrow(PairwiseMatrix)

for (i in 1:SquareDFSize) {
  for (j in 1:SquareDFSize) {
    
    seq1_ID <- data1$Mito_ID[i]
    seq2_ID <- data1$Mito_ID[j]
    
    seq1 <- DNAString(data1$COX1[data1$Mito_ID == seq1_ID])
    seq2 <- DNAString(data1$COX1[data1$Mito_ID == seq2_ID])
    
    Score <- Pairwise_Score_Function(seq1, seq2)
    
    PairwiseMatrix[i,j] <- Score
  }
}




