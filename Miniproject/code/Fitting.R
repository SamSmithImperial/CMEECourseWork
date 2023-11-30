Data <- read.csv("../data/WrangledData.csv")

class(Data)
# required packages
library(ggplot2)
library(dplyr)

# subset the data into individual growth curves or 'plates'
id_subsets <- Data %>% group_split(ID)
id_subsets[[1]]

# Get unique values of the ID variable and prepare subset list for the for loop
unique_ids <- unique(Data$ID)
subsets <- list()
names(id_subsets)
# Use a for loop to create subsets
for (id in unique_ids) {
  subset_name <- paste("subset_ID", id, sep="_")
  subsets[[subset_name]] <- Data[Data$ID == id, ]
}


# cubic work
modelsdataset <- names(subsets)
modelsdataset <- data.frame(modelsdataset)

list2 <- list()
for (i in names(subsets)) {
  # i have added a plus 1 to remove negative numbers - I will need to remember to alter the K value later on
  model <- lm(log(PopBio+1) ~ poly(Time,3), data = subsets[[i]])
  summary <- summary(model)
  list2 <- c(list2, summary$adj.r.squared)
}

modelsdataset$adj.r.squaredcubic <- list2


# find reasonable starting values for r before moving onto NLLS
slopelist <- list()
for (i in names(subsets)) {
  slope <- lm(log(PopBio+1) ~ Time, data = subsets[[i]])$coef[2]
  slopelist <- c(slopelist, slope)
}

modelsdataset$StartingRvalues <- slopelist

# add temperature, species, and medium to data frame
TempList <- list()
for (i in names(subsets)) {
  TempList <- c(TempList, unique(subsets[[i]]$Temp))
}

modelsdataset$Temp <- TempList


