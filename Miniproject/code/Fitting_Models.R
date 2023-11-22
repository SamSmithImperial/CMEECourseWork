# Import Packages
library(dplyr)
library(minpack.lm) # Contains the NLLSLM function
library(import) # Contains the import function used for importing my Formula
library(purrr) # Contains the Possibly function used to continue iterations after error

# Import Data & Formula
Data <- read.csv("../data/WrangledData.csv")
import::from(Formula.R, logistic_model, gompertz_model, get_AICc, get_BIC, get_AICc_gomp)

# Subset Data into unique IDs corresponding to individual growth curves
Data2 <- group_split(Data, ID)

###############################
### FIT ALL LOGISTIC MODELS ###
###############################

num_iterations <- 100
Logi_func = function(x) {
  for (i in 1:num_iterations) {
    
    tryCatch({
      
      df <- x
      N0_start_logi <- rnorm(1,min(df$PopBio),3)
      # rnorm(1, mean = min(df$PopBio), sd = abs(min(df$PopBio))/5)
      popbio_values <- df$PopBio
      top_10_perc <- quantile(popbio_values,0.80)
      top_10_values <- popbio_values[popbio_values>top_10_perc]
      K_start_Log <- rnorm(1, mean(top_10_values), sd = mean(top_10_values)/10)
      max_pop_index <- which.max(df$PopBio)
      t_max_pop <- df$Time[max_pop_index]
      t_lag_start <- rnorm(1, df$Time[which.max(diff(diff(df$PopBio)))], df$Time[which.max(diff(diff(df$PopBio)))]/5)
      r_max_start_Logi <- abs(rnorm(1, 0,5))
      # rnorm(1, coef(lm(df$PopBio ~ df$Time, data = df[df$Time > t_lag_start & df$Time < t_max_pop,]))[2], 5)
      
      fit_model <- nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0),
                         data = df,
                         start = list(r_max = 0.1, N_0 = N0_start_logi, K = K_start_Log),
                         lower = c(r_max = 0, N_0 = -1, K = 0),
                         upper = c(r_max = 1000, N_0 = 200, K = 10000000000),
                         control = nls.lm.control(maxiter = 100))
      
      df$predicted_logistic <- predict(fit_model)
      df$residuals <- df$PopBio - df$predicted_logistic
      df$residuals_sqrd <- (df$residuals)^2
      SS_Residual <- sum(df$residuals_sqrd)
      df$total_resids <- df$PopBio - mean(df$PopBio)
      df$total_resids_sqrds <- df$total_resids^2
      SS_total <- sum(df$total_resids_sqrds)
      R_squared_Log <- 1 - (SS_Residual / SS_total)
      
      summary <- summary(fit_model)
      r_max_logi <- summary$parameters[1]
      N_0_logi <- summary$parameters[2]
      K_logi <- summary$parameters[3]
      
      result <- data.frame(SubsetID = unique(df$ID),
                           Logistic_AICc = get_AICc(fit_model,df),
                           Logistic_Rsqrd = R_squared_Log,
                           Logistic_BIC = get_BIC(fit_model,df),
                           Logistic_r_max = r_max_logi,
                           Logistic_N_0 = N_0_logi,
                            Logistic_K = K_logi)
      
      if (i == 1 || R_squared_Log > max(final_result_logi$Logistic_Rsqrd)) {
        final_result_logi <- result
      }
    })
  }
  return(final_result_logi)
}
fixthis_Logi = possibly(.f = Logi_func, quiet = TRUE)
MyResLogi<- bind_rows(lapply(Data2, fixthis_Logi))

###############################
### FIT ALL GOMPERTZ MODELS ###
###############################

num_iterations_gomp <- 100
Gomp_func = function(x) {
  for (i in 1:num_iterations_gomp){
    tryCatch({
      df <- x
      N0_start_Gomp <- rnorm(1, mean = min(log(df$PopBio)), sd = 0.1)
      popbio_values <- log(df$PopBio)
      top_10_perc <- quantile(popbio_values,0.8)
      top_10_values <- log(popbio_values[popbio_values>top_10_perc])
      K_start_Gomp <- mean(top_10_values)
      max_pop_index <- which.max(df$PopBio)
      t_max_pop <- df$Time[max_pop_index]
      t_lag_start <- rnorm(1, df$Time[which.max(diff(diff(log(df$PopBio))))], 1)
      r_max_start_Gomp <- abs(rnorm(1, coef(lm(log(df$PopBio) ~ df$Time, data = df[df$Time > t_lag_start & df$Time < t_max_pop,]))[2], 5))
      
      
      fit_model <- nlsLM(log(PopBio) ~ gompertz_model(t = Time, r_max, K, N_0, t_lag), 
                         data = df, 
                         start = list(r_max = 0.1, t_lag =t_lag_start, N_0 = -5, K = 0),
                         lower = c(t_lag = 0, r_max = 0, N_0 = -25, K = -10),
                         control = nls.lm.control(maxiter = 100))
      
      
      df$total_resids <- df$PopBio-mean(df$PopBio)
      df$total_resids_sqrds <- df$total_resids^2
      SS_total <- sum(df$total_resids_sqrds)
      
      df$predicted_gomp <- exp(predict(fit_model))
      df$residuals <- df$PopBio-df$predicted_gomp
      df$residuals_sqrd_gomp <- (df$residuals)^2
      SS_Residual <- sum(df$residuals_sqrd_gomp)
      R_squared_Gomp <- 1 - (SS_Residual/SS_total)

      summary <- summary(fit_model)
      r_max_gomp <- summary$parameters[1]
      t_lag_gomp <- summary$parameters[2]
      N_0_gomp <- summary$parameters[3]
      K_gomp <- summary$parameters[4]
      
      result <- data.frame(SubsetID = unique(df$ID),
                           Gompertz_AICc = get_AICc_gomp(fit_model,df,SS_Residual),
                           Gompertz_AICc_real = AICc(fit_model),
                           Gompertz_Rsqrd = R_squared_Gomp,
                           Gompertz_BIC = get_BIC(fit_model,df),
                           Gompertz_r_max = r_max_gomp,
                           Gompertz_t_lag = t_lag_gomp,
                           Gompertz_N_0 = N_0_gomp,
                           Gompertz_K = K_gomp)
      
      if (i == 1 || R_squared_Gomp > max(final_result_Gomp$Gompertz_Rsqrd)) {
        final_result_Gomp <- result
      }
    })
  } 
  return(final_result_Gomp)
}

fixthis_Gomp = possibly(.f = Gomp_func, quiet = TRUE)
MyResGomp <- bind_rows(lapply(Data2, fixthis_Gomp))

############################
### FIT ALL CUBIC MODELS ###
############################

Cubic_func = function(x){
  df <- x
  model <- lm(PopBio ~ poly(Time, 3), data = df)
  summary <- summary(model)
  R_Squared <- summary$r.squared
  
  result <- data.frame(SubsetID = unique(df$ID),
                       Cubic_AICc = get_AICc(model, df),
                       Cubic_Rsqrd = R_Squared,
                       Temperature = unique(df$Temp),
                       Cubic_BIC = get_BIC(model,df))
  return(result)
}

fixthis_Cubic = possibly(.f = Cubic_func, quiet = TRUE)
MyResCubic<- bind_rows(lapply(Data2, fixthis_Cubic))

#######################
### MERGE DATA SETS ###
#######################

Stats_data <- merge(MyResGomp, MyResLogi, by = "SubsetID")
Stats_data <- merge(Stats_data, MyResCubic, by = "SubsetID")

######################################
### ADD COLUMN FOR R SQRD BEST FIT ###
######################################

Stats_data$Rsqrd_Winner <- ifelse(
  Stats_data$Logistic_Rsqrd == pmax(Stats_data$Gompertz_Rsqrd,
                                    Stats_data$Logistic_Rsqrd,
                                    Stats_data$Cubic_Rsqrd), "Logistic",
                          ifelse(
  Stats_data$Cubic_Rsqrd == pmax(Stats_data$Gompertz_Rsqrd,
                                 Stats_data$Logistic_Rsqrd,
                                 Stats_data$Cubic_Rsqrd), "Cubic Polynomial", "Gompertz"))

#########################################
### ADD COLUMN FOR AIC & BIC BEST FIT ###
#########################################

Stats_data <- Stats_data %>%
  mutate(AIC_winner = case_when(
    Logistic_AICc - Gompertz_AICc <= 2 & Logistic_AICc - Cubic_AICc <= 2 ~ "Logistic",
    Gompertz_AICc - Logistic_AICc <= 2 & Gompertz_AICc - Cubic_AICc <= 2 ~ "Gompertz",
    Cubic_AICc - Logistic_AICc <= 2 & Cubic_AICc - Gompertz_AICc <= 2 ~ "Cubic",
    TRUE ~ "No clear winner"
  ))

Stats_data <- Stats_data %>%
  mutate(BIC_winner = case_when(
    Logistic_BIC - Gompertz_BIC <= 2 & Logistic_BIC - Cubic_BIC <= 2 ~ "Logistic",
    Gompertz_BIC - Logistic_BIC <= 2 & Gompertz_BIC - Cubic_BIC <= 2 ~ "Gompertz",
    Cubic_BIC - Logistic_BIC <= 2 & Cubic_BIC - Gompertz_BIC <= 2 ~ "Cubic",
    TRUE ~ "No clear winner"
  ))

#####################################
### EXPORT STATS DATAFRAME TO CSV ###
#####################################

write.csv(Stats_data, "../results/stats_data.csv")


