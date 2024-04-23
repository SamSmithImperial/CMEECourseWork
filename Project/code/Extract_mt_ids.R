data <- read.csv("SITE-100 Database - mitogenomes.csv", header = TRUE)
Staphylinidae <- data[data$family == "Staphylinidae",] 

mt_ids <- unique(Staphylinidae$mt_id)

filepath <- "mt_ids.txt"
writeLines(mt_ids, filepath)
