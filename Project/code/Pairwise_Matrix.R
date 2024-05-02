## GTR model best for mito genomes apparetnly
## do all the workshop stuff and creedy pipeline after i have found good clusters!
## translate and backtranslate sequences so the alignment is perfect for each gene, and then concatenate.
## Use IQ Tree or RAxML!!!! their the most accurate.
## I dont think i can do the translate and back translate to find good clusters because i would have to align the protein sequences for each pair: 13000C2 is a big number ahhaahah.

##############################
### Load Packages and Data ###
##############################

data <- read.csv("../data/Complete_MG_Sequences.csv", row.names = NULL)

library(Biostrings)
library(cluster)  # For silhouette width
library(fpc)      # For gap statistic

#######################################
### Small Subsets for Local Running ###
#######################################

# data1 <- data[1:30,] # Small Subset of Data for Local Running
# View(data1)

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
  Score <- num_matches # if the alignment is with all PCGs then no need to divide my alignment length
  
  return(Score)
}

################################
### Pairwise Matrix Function ###
################################

Pairwise_matrix_function <- function(Gene_Name){
  
  PairwiseMatrix <- as.data.frame(matrix(nrow = nrow(data1), ncol = nrow(data1)))
  dimnames(PairwiseMatrix) <- list(data1$MITO_ID, data1$MITO_ID)
  SquareDFSize <- nrow(PairwiseMatrix)
  
  for (i in 1:SquareDFSize) {
    for (j in i:SquareDFSize) { # start nested loop with i to only make the upper triangle of matrix!
      
      seq1_ID <- data1$MITO_ID[i]
      seq2_ID <- data1$MITO_ID[j]
      
      seq1 <- DNAString(data1[[Gene_Name]][data1$MITO_ID == seq1_ID])
      seq2 <- DNAString(data1[[Gene_Name]][data1$MITO_ID == seq2_ID])
      
      Score <- Pairwise_Score_Function(seq1, seq2)
      
      PairwiseMatrix[i,j] <- Score
    }
  }
  PairwiseMatrix[lower.tri(PairwiseMatrix)] <- t(PairwiseMatrix)[lower.tri(PairwiseMatrix)] # Mirror matrix to complete!
  return(PairwiseMatrix)
}

############################
### Make Pairwise Matrix ###
############################

PairwiseMatrix_Sequence <- Pairwise_matrix_function("Concat_PCG")

write.csv(PairwiseMatrix_Sequence, "PairwiseMatrix.csv", row.names = FALSE)

