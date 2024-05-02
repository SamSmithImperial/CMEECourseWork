##############################
### Load Packages and Data ###
##############################

library(dplyr)
data <- read.csv("../data/sequences.csv")
data <- subset(data, select = -Sequence)

###############################################################
### Combine identical genes written in lower and upper case ###
###############################################################

data$COX1[!is.na(data$cox1)] <- data$cox1[!is.na(data$cox1)]
data$COX2[!is.na(data$cox2)] <- data$cox2[!is.na(data$cox2)]
data$COX3[!is.na(data$cox3)] <- data$cox3[!is.na(data$cox3)]

data$ND1[!is.na(data$nad1)] <- data$nad1[!is.na(data$nad1)]
data$ND2[!is.na(data$nad2)] <- data$nad2[!is.na(data$nad2)]
data$ND3[!is.na(data$nd3)] <- data$nad3[!is.na(data$nad3)]
data$ND4[!is.na(data$nad4)] <- data$nad4[!is.na(data$nad4)]
data$ND4L[!is.na(data$nad4l)] <- data$nad4l[!is.na(data$nad4l)]
data$ND5[!is.na(data$nad5)] <- data$nad5[!is.na(data$nad5)]
data$ND6[!is.na(data$nad6)] <- data$nad6[!is.na(data$nad6)]

data$ATP6[!is.na(data$atp6)] <- data$atp6[!is.na(data$atp6)]
data$ATP8[!is.na(data$atp8)] <- data$atp8[!is.na(data$atp8)]

######################################
### Remove lowercase gene columns ###
######################################

colnames(data)[which(colnames(data) == 'FileName')] <- 'MITO_ID'
data <- data %>% 
  select(which(!grepl("[a-z]", names(data))))

#####################################################
### Remove file extensions from mitochondrial ids ###
#####################################################

data$MITO_ID <- gsub("\\.gb$", "", data$MITO_ID)

###############################################
### write csv for only complete mitogenomes ###
###############################################

new_data <- data[complete.cases(data), ]
new_data$Concat_PCG <- apply(new_data[, -which(names(new_data) == "MITO_ID")], 1, function(row) paste(row, collapse = ""))

write.csv(new_data, "../data/Complete_MG_Sequences.csv", row.names = FALSE)
