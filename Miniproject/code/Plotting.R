# import packages
library(ggplot)

# import Formula
import::from(Formula.R, logistic_model, gompertz_model)

# import Data & Subset
data <- read.csv("../results/stats_data.csv")
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
  
  c_mod <- lm(PopBio ~ poly(Time, 3), data = df)
  
  predicted_cubic <- predict(c_mod, newdata = data.frame(Time = timepoints))
  
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
  
  ggplot(data = df, aes(x = Time, y = PopBio))+
    geom_point(aes(x=Time, y =PopBio, color="Observed"),size=3) +
    geom_line(data = df1, aes(x = timepoints, y = predicted_cubic, color = "Cubic Fit"), size = 1.5) +
    geom_line(data = df1 ,aes(x = timepoints, y = predicted_gompertz, color = "Gompertz Fit"), size = 1.5) +
    geom_line(data= df1, aes(x = timepoints, y = predicted_logistic, color = "Logistic Fit"), size = 1.5) +
    
    labs(
      title = paste("Population Growth Curves for ID: ", data_id),
      subtitle = paste("Temperature: ", unique(df$Temp)),
      x = "Time",
      y = "Population",
      color = "Model"
    ) +
    
    scale_color_manual(values = c("Cubic Fit" = "blue", "Gompertz Fit" = "red", "Logistic Fit" = "green")) +
    theme_minimal()
  
  
}

fixthis_graph_func = possibly(.f = graph_func, quiet = TRUE)
lapply(Data2, function(df) fixthis_graph_func(df, Stats_data))

#########################################################################################
### TALBES SHOWING WHICH MODELS PERFORM BEST AT DIFFERENT TEMPERATRURES PER CRITERION ###
#########################################################################################

AIC_winner_temp <- bind_rows(lapply(data2, function(Stats_data) {
  data.frame(
    Temperature = unique(Stats_data$Temperature),
    Logistic = sum(Stats_data$AIC_winner == "Logistic"),
    Gompertz = sum(Stats_data$AIC_winner == "Gompertz"),
    Cubic = sum(Stats_data$AIC_winner == "Cubic")
  )
}))

BIC_winner_temp <- bind_rows(lapply(data2, function(Stats_data) {
  data.frame(
    Temperature = unique(Stats_data$Temperature),
    Logistic = sum(Stats_data$BIC_winner == "Logistic"),
    Gompertz = sum(Stats_data$BIC_winner == "Gompertz"),
    Cubic = sum(Stats_data$BIC_winner == "Cubic")
  )
}))

R_Sqrd_winner_temp <- bind_rows(lapply(data2, function(Stats_data) {
  data.frame(
    Temperature = unique(Stats_data$Temperature),
    Logistic = sum(Stats_data$Rsqrd_Winner == "Logistic"),
    Gompertz = sum(Stats_data$Rsqrd_Winner == "Gompertz"),
    Cubic = sum(Stats_data$Rsqrd_Winner == "Cubic Polynomial")
  )
}))


#########################









