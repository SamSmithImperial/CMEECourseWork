data <- read.csv("../data/Other/SITE-100 Database - mitogenomes.csv", header = TRUE)

data_Coleopterans <- data[data$order == "Coleoptera", ]

mt_ids <- unique(data_Coleopterans$mt_id)

filepath <- "../data/Other/mt_ids.txt"
writeLines(mt_ids, filepath)

write.csv(data_Coleopterans, "../data/Other/ColeopteranSite100.csv")
