rm(list=ls())
graphics.off()

S_data <- seq(1,50,5)
S_data

V_data <- ((12.5*S_data)/(7.1 + S_data))
plot(S_data, V_data)

set.seed(1456)
V_data <- V_data + rnorm(10,0,1)
plot(S_data, V_data)

MM_model <- nls(V_data ~ V_max*S_data/(K_M + S_data))

plot(S_data, V_data, xlab = "", ylab = "")
lines(S_data, predict(MM_model), lty=1, col="blue", lwd=2)

coef(MM_model) # check the coefficients
Substrate2Plot <- seq(min(S_data), max(S_data),len=200) # generate some new x-axis values just for plotting
Predict2Plot <- coef(MM_model)["V_max"] * Substrate2Plot / (coef(MM_model)["K_M"] + Substrate2Plot) # calculate the predicted values by plugging the fitted coefficients into the model equation 
plot(S_data,V_data, xlab = "Substrate Concentration", ylab = "Reaction Rate")  # first plot the data 
lines(Substrate2Plot, Predict2Plot, lty=1,col="blue",lwd=2) # now overlay the fitted model

summary(MM_model)

MM_model2 <- nls(V_data ~ V_max * S_data / (K_M + S_data), start = list(V_max = 12, K_M = 7))
coef(MM_model)
coef(MM_model2)
