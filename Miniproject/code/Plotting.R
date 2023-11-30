# import packages
library(ggplot2)
library(dplyr)
library(purrr)

# Logistic Model Formula
logistic_model <- function(t, r_max, K, N_0){ # The classic logistic equation
  return(N_0 * K * exp(r_max * t)/(K + N_0 * (exp(r_max * t) - 1)))
}

# Gompertz Model Formula
gompertz_model <- function(t, r_max, K, N_0, t_lag){
  return(N_0 + (K - N_0) * exp(-exp(r_max * exp(1) * (t_lag - t)/((K - N_0) * log(10)) + 1)))
} 

# import Data & Subset
data <- read.csv("../results/stats_data.csv")
Data <- read.csv("../data/WrangledData.csv")

# Subset Data into unique IDs corresponding to individual growth curves
Data2 <- group_split(Data, ID)
data2 <- group_split(data, Temperature)

###############################
### PLOT EVERY SINGLE GRAPH ###
###############################
graph_func = function(x,sdf){
  df <- x
  data_id <- unique(df$ID)
  Stats_d <- sdf
  subset_stats <- Stats_d[Stats_d$SubsetID == data_id,]
  timepoints <- seq(min(df$Time), max(df$Time), 0.1)
  
  c_mod <- lm(log(PopBio) ~ poly(Time, 3), data = df)
  
  predicted_cubic <- exp(predict(c_mod, newdata = data.frame(Time = timepoints)))
  
  predicted_gompertz <- exp(gompertz_model(t = timepoints,
                                           r_max = subset_stats$Gompertz_r_max,
                                           K = subset_stats$Gompertz_K,
                                           N_0 = subset_stats$Gompertz_N_0,
                                           t_lag = subset_stats$Gompertz_t_lag))
  
  predicted_logistic <- logistic_model(t = timepoints,
                                       r_max = subset_stats$Logistic_r_max,
                                       K = subset_stats$Logistic_K,
                                       N_0 = subset_stats$Logistic_N_0)
  
  df1 <- data.frame(timepoints, predicted_gompertz, predicted_logistic, predicted_cubic)
  
  p <- ggplot(data = df, aes(x = Time, y = PopBio))+
    geom_point(aes(x=Time, y =PopBio, color="Observed"),size=3) +
    geom_line(data = df1, aes(x = timepoints, y = predicted_cubic, color = "Cubic Fit"), linewidth = 1.5) +
    geom_line(data = df1 ,aes(x = timepoints, y = predicted_gompertz, color = "Gompertz Fit"), linewidth = 1.5) +
    geom_line(data= df1, aes(x = timepoints, y = predicted_logistic, color = "Logistic Fit"), linewidth = 1.5) +
    
    labs(
      title = paste("Population Growth Curves for ID: ", data_id),
      subtitle = paste("Temperature: ", unique(df$Temp),"C", ",", "Population Units: ", unique(df$PopBio_units)),
      x = "Time",
      y = "Population",
      color = "Model"
    ) +
    
    scale_color_manual(values = c("Cubic Fit" = "blue", "Gompertz Fit" = "red", "Logistic Fit" = "green")) +
    theme_minimal()+theme(aspect.ratio = 1)
  
  ggsave(paste0("../plots", "/plot", data_id, ".pdf"),p)
  
}

fixthis_graph_func = possibly(.f = graph_func, quiet = TRUE)
lapply(Data2, function(df) fixthis_graph_func(df, data))

###############################################
### PLOT SAME CURVE IN LOG AND LINEAR SPACE ###
###############################################
# First in Linear Space

df <- Data2[[226]]
data_id <- unique(df$ID)
Stats_d <- data
subset_stats <- Stats_d[Stats_d$SubsetID == data_id,]
timepoints <- seq(min(df$Time), max(df$Time), 0.1)

c_mod <- lm(log(PopBio) ~ poly(Time, 3), data = df)

predicted_cubic <- exp(predict(c_mod, newdata = data.frame(Time = timepoints)))

predicted_gompertz <- exp(gompertz_model(t = timepoints,
                                         r_max = subset_stats$Gompertz_r_max,
                                         K = subset_stats$Gompertz_K,
                                         N_0 = subset_stats$Gompertz_N_0,
                                         t_lag = subset_stats$Gompertz_t_lag))

predicted_logistic <- logistic_model(t = timepoints,
                                     r_max = subset_stats$Logistic_r_max,
                                     K = subset_stats$Logistic_K,
                                     N_0 = subset_stats$Logistic_N_0)

df1 <- data.frame(timepoints, predicted_gompertz, predicted_logistic, predicted_cubic)
png("../results/LinearMod.png", height = 3500, width = 3500, res = 500)
ggplot(data = df, aes(x = Time, y = PopBio)) +
  geom_point(aes(x = Time, y = PopBio, color = "Observed"), size = 3) +
  geom_line(data = df1, aes(x = timepoints, y = predicted_cubic, color = "Cubic"), size = 1.5) +
  geom_line(data = df1, aes(x = timepoints, y = predicted_gompertz, color = "Gompertz"), size = 1.5) +
  geom_line(data = df1, aes(x = timepoints, y = predicted_logistic, color = "Logistic"), size = 1.5) +
  labs(
    title = paste("Population Growth Curves for ID: ", data_id),
    subtitle = paste("Temperature: ", unique(df$Temp), "C", ",", "Population Units: ", unique(df$PopBio_units)),
    x = "Time",
    y = "Population",
    color = "Model"
  ) +
  scale_color_manual(values = c("Cubic" = "blue", "Gompertz" = "red", "Logistic" = "green")) +
  theme_minimal() +
  theme(
    legend.position = c(0.3,0.75),
    text = element_text(family = "Times New Roman", size = 16),  # Adjust font family and size
    plot.title = element_text(face = "bold", size = 20),  # Main title font size
    axis.title.x = element_text(size = 18),  # X-axis title font size
    axis.title.y = element_text(size = 18),  # Y-axis title font size
    axis.text = element_text(size = 14),  # Axis text font size
    legend.title = element_text(size = 17),  # Legend title font size
    legend.text = element_text(size = 16),
    aspect.ratio = 1,
    legend.key = element_rect(fill = "white", colour = "white"),
    legend.background = element_rect(fill = "white", colour = "white")
  )+labs(color = NULL) +
  guides(color = guide_legend(title = NULL)) 
graphics.off()

# Secondly in Log Space
df <- Data2[[226]]
data_id <- unique(df$ID)
Stats_d <- data
subset_stats <- Stats_d[Stats_d$SubsetID == data_id,]
timepoints <- seq(min(df$Time), max(df$Time), 0.1)

c_mod <- lm(log(PopBio) ~ poly(Time, 3), data = df)

predicted_cubicL <- predict(c_mod, newdata = data.frame(Time = timepoints))

predicted_gompertzL <- gompertz_model(t = timepoints,
                                         r_max = subset_stats$Gompertz_r_max,
                                         K = subset_stats$Gompertz_K,
                                         N_0 = subset_stats$Gompertz_N_0,
                                         t_lag = subset_stats$Gompertz_t_lag)

predicted_logisticL <- log(logistic_model(t = timepoints,
                                     r_max = subset_stats$Logistic_r_max,
                                     K = subset_stats$Logistic_K,
                                     N_0 = subset_stats$Logistic_N_0))

df2 <- data.frame(timepoints, predicted_gompertzL, predicted_logisticL, predicted_cubicL)

png("../results/LogMod.png",width = 3500, height = 3500, res = 500)
ggplot(data = df, aes(x = Time, y = log(PopBio))) +
  geom_point(aes(x = Time, y = log(PopBio), color = "Observed"), size = 3) +
  geom_line(data = df2, aes(x = timepoints, y = predicted_cubicL, color = "Cubic Fit"), size = 1.5) +
  geom_line(data = df2, aes(x = timepoints, y = predicted_gompertzL, color = "Gompertz Fit"), size = 1.5) +
  geom_line(data = df2, aes(x = timepoints, y = predicted_logisticL, color = "Logistic Fit"), size = 1.5) +
  labs(
    title = paste("Population Growth Curves for ID: ", data_id),
    subtitle = paste("Temperature: ", unique(df$Temp), "C", ",", "Population Units: ", unique(df$PopBio_units)),
    x = "Time",
    y = "Log Population",
    color = "Model"
  ) +
  scale_color_manual(values = c("Cubic Fit" = "blue", "Gompertz Fit" = "red", "Logistic Fit" = "green")) +
  theme_minimal() +
  theme(
    legend.position = "none",
    text = element_text(family = "Times New Roman", size = 16),  # Adjust font family and size
    plot.title = element_text(face = "bold", size = 20),  # Main title font size
    axis.title.x = element_text(size = 18),  # X-axis title font size
    axis.title.y = element_text(size = 18),  # Y-axis title font size
    axis.text = element_text(size = 14),  # Axis text font size
    legend.title = element_text(size = 17),  # Legend title font size
    legend.text = element_text(size = 16),
    aspect.ratio = 1# Legend text font size
  )

graphics.off()

#############################################################################################
### DATA FRAME SHOWING WHICH MODELS PERFORM BEST AT DIFFERENT TEMPERATRURES PER CRITERION ###
#############################################################################################

AIC_winner_temp <- bind_rows(lapply(data2, function(data) {
  data.frame(
    Temperature = unique(data$Temperature),
    Logistic = sum(data$AIC_Winner == "Logistic"),
    Gompertz = sum(data$AIC_Winner == "Gompertz"),
    Cubic = sum(data$AIC_Winner == "Cubic"),
    Logistic_proportion = sum(data$AIC_Winner == "Logistic")/(sum(data$AIC_Winner == "Logistic")+sum(data$AIC_Winner == "Gompertz")+sum(data$AIC_Winner == "Cubic")),
    Gompertz_proportion = sum(data$AIC_Winner == "Gompertz")/(sum(data$AIC_Winner == "Logistic")+sum(data$AIC_Winner == "Gompertz")+sum(data$AIC_Winner == "Cubic")),
    Cubic_proportion = sum(data$AIC_Winner == "Cubic")/(sum(data$AIC_Winner == "Logistic")+sum(data$AIC_Winner == "Gompertz")+sum(data$AIC_Winner == "Cubic"))
  )
}))

######################################################################
### PLOT PERFORMANCE OF EACH MODEL THROUGH ALL UNIQUE TEMPERATURES ###
######################################################################

png("../results/proportionplot.png", height = 2000, width = 4000, res = 500)
ggplot(data = AIC_winner_temp, aes(x = Temperature)) +
  geom_line(aes(y = Logistic_proportion, color = "Logistic"), size = 1.2) +
  geom_line(aes(y = Gompertz_proportion, color = "Gompertz"), size = 1.2) +
  geom_line(aes(y = Cubic_proportion, color = "Cubic"), size = 1.2) +
  labs(title = "Proportion of AIC Winners by Temperature",
       x = "Temperature",
       y = "Proportion of Best Fits",
       color = "Model") +
  scale_color_manual(values = c("Logistic" = "blue", "Gompertz" = "darkgreen", "Cubic" = "red")) +
  theme_minimal() +
  theme(legend.position = c(0.65,0.8),
        legend.title = element_blank(),
        legend.text = element_text(size = 16),
        axis.text = element_text(size = 14),
        axis.title = element_text(size = 18),
        title = element_text(size =20),
        aspect.ratio = 0.4,
        text = element_text(family = "Times New Roman"),
        legend.background = element_rect(fill = "white", colour = "white"))
graphics.off()

################################
### PLOT RMAX VS TEMPERATURE ###
################################
datadataCFU <- subset(data, Units == "CFU")

modelly1 <- lm(Akaike_r_max ~ poly(Temperature, 2), data = datadataCFU)
modell2 <- lm(Gompertz_r_max ~ poly(Temperature, 2), data = datadataCFU)

temp_points <- seq(0, 40, 0.1)
predPointsCFU <- data.frame(Temperature = temp_points, 
                         Akaike_r_max = predict(modelly1, data.frame(Temperature = temp_points)))
predpointscfugomp <- data.frame(Temperature = temp_points, 
                                Akaike_r_max = predict(modell2, data.frame(Temperature = temp_points)))

pdf("../results/rmaxvstemp.pdf")
ggplot() +
  geom_jitter(data = datadataCFU, aes(x = Temperature, y = Akaike_r_max), color = "blue", width = 0.3, size =2, alpha = 0.7) +
  geom_line(data = predPointsCFU, aes(x = Temperature, y = Akaike_r_max), color = "blue", size = 1.3) +
  geom_jitter(data = datadataCFU, aes(x = Temperature, y = Gompertz_r_max), color = "red", size = 1.3)+
  geom_line(data = predpointscfugomp, aes(x = Temperature, y = Akaike_r_max), color = "red", size = 1.3) +
  
  labs(title = "Rmax vs Temperature",
       x = "Temperature",
       y = "Maximum Growth Rate") +
  theme_minimal()+ylim(0,1)+theme(aspect.ratio = 0.9)
graphics.off()
#############################
### TABLE FOR BEST MODELS ###
#############################

Logistic_bestfits <- data.frame(AICc = sum(data$AIC_Winner == "Logistic"),
                                BIC = sum(data$BIC_Winner == "Logistic"),
                                Rsqrd = sum(data$Rsqrd_Winner == "Logistic"),
                                AkaikeW = sum(data$Akaike_Winner == "Logistic"))

Cubic_bestfits <- data.frame(AICc = sum(data$AIC_Winner == "Cubic"),
                             BIC = sum(data$BIC_Winner == "Cubic"),
                             Rsqrd = sum(data$Rsqrd_Winner == "Cubic"),
                             AkaikeW = sum(data$Akaike_Winner == "Cubic"))

Gompertz_bestfits <- data.frame(AICc = sum(data$AIC_Winner == "Gompertz"),
                                BIC = sum(data$BIC_Winner == "Gompertz"),
                                Rsqrd = sum(data$Rsqrd_Winner == "Gompertz"),
                                AkaikeW = sum(data$Akaike_Winner == "Gompertz"))

# Combine data frames into one
sammt <- rbind(c("Model", "AICc", "BIC", "Rsqrd", "AkaikeW"),
               c("Logistic", Logistic_bestfits$AICc, Logistic_bestfits$BIC, Logistic_bestfits$Rsqrd, Logistic_bestfits$AkaikeW),c("Cubic", Cubic_bestfits$AICc, Cubic_bestfits$BIC, Cubic_bestfits$Rsqrd, Cubic_bestfits$AkaikeW), c("Gompertz", Gompertz_bestfits$AICc, Gompertz_bestfits$BIC, Gompertz_bestfits$Rsqrd, Gompertz_bestfits$AkaikeW))

sammy <- as.data.frame(sammt)
rownames(sammy) <- NULL
colnames(sammy) <- NULL



write.csv(sammy,"../results/bestmodeltable.csv", row.names = FALSE, quote = FALSE)



