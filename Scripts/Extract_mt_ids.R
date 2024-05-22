data <- read.csv("../data/SITE-100 Database - mitogenomes.csv", header = TRUE)

data_with_family <- data[!is.na(data$family) & data$family != "" & data$order == "Coleoptera", ]

mt_ids <- unique(data_with_family$mt_id)

filepath <- "../data/mt_ids.txt"
writeLines(mt_ids, filepath)

