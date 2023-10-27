rm(list=ls())
load("../data/KeyWestAnnualMeanTemperature.RData")

ats <- transform(ats, dy=c(NA, diff(ats$Temp)))

plot(ats$Year, ats$dy)

install.packages("tseries")

library(tseries)
acf(ats$Temp)
Temp1 <- ats$Temp[1:99]
Temp2 <- ats$Temp[2:100]

cor(Temp1, Temp2)

PermTemps <- 
