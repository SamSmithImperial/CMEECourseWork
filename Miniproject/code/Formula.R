# Logistic Model Formula
logistic_model <- function(t, r_max, K, N_0){ # The classic logistic equation
  return(N_0 * K * exp(r_max * t)/(K + N_0 * (exp(r_max * t) - 1)))
}

# Gompertz Model Formula
gompertz_model <- function(t, r_max, K, N_0, t_lag){
  return(N_0 + (K - N_0) * exp(-exp(r_max * exp(1) * (t_lag - t)/((K - N_0) * log(10)) + 1)))
} 

# Formula for Generating AICc values
get_AICc <- function(x,df){
  n = length(residuals(x))
  residuals = sum(residuals(x)^2)
  params = length(coef(x))
  AIC <- n +2 + n*log((2*pi)/n)+n*log(residuals)+2*params
  #AICc <- n +2 + n*log((2*pi)/n)+n*log(residuals)+(2*params*n*n)-params-1
  AICc <- AIC +(2*params*(params+1))/(n-params-1)
  return(AICc)
}

# Formula for Generating AICc values specific to Gompertz

get_AICc_gomp <- function(x,df,resids) {
  n = nrow(df)
  params = length(coef(x))
  AIC <- n +2 + n*log((2*pi)/n)+n*log(resids)+2*params
  AICc <- AIC +(2*params*(params+1))/(n-params-1)
  return(AICc)
}

# Formula for Generating BIC values
get_BIC <- function(x, df) {
  n = nrow(df)
  residuals = sum(residuals(x)^2)
  params = length(coef(x))
  BIC <- n +2 + n*log((2*pi)/n)+n*log(residuals)+log(n)*params
  return(BIC)
}