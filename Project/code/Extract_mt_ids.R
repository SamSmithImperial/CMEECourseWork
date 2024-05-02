data <- read.csv("SITE-100 Database - mitogenomes.csv", header = TRUE)

data_with_family <- data[!is.na(data$family), ]

mt_ids <- unique(data_with_family$mt_id)

filepath <- "mt_ids.txt"
writeLines(mt_ids, filepath)

length(mt_ids)
