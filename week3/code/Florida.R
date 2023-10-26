rm(list=ls())
load("../data/KeyWestAnnualMeanTemperature.RData")
set.seed(1)
n <- length(ats$Year)
Perm <- 100000
variable <- ats$Temp

# Generate permutations
PermSamples <- replicate(Perm, sample(variable, size = n, replace = FALSE))
PermSamples <- cbind(ats$Year, PermSamples)

# Calculate correlations
CorrelationCoefficients <- cor(PermSamples[, 1], PermSamples[, 2:(Perm + 1)])

# Plot the histogram
hist(CorrelationCoefficients, xlim = c(-0.4, 0.6))
abline(v = 0.53, col = "red", lwd = 3)
text(x = 0.5, y = 15000, '0.53')



