rm(list=ls())
load("../data/KeyWestAnnualMeanTemperature.RData")
set.seed(1)
n <- length(ats$Year)
Perm <- 100000
variable <- ats$Temp
TrueCorrelation <- cor(ats$Year, ats$Temp)

# Generate permutations
PermSamples <- replicate(Perm, sample(variable, size = n, replace = FALSE))
PermSamples <- cbind(ats$Year, PermSamples)

# Calculate correlations
CorrelationCoefficients <- cor(PermSamples[, 1], PermSamples[, 2:(Perm + 1)])
print(range(CorrelationCoefficients))

# Plot the histogram
hist(CorrelationCoefficients, xlim = c(-0.4, 0.6))
abline(v = TrueCorrelation, col = "red", lwd = 3)

Coef_more_than_realCor <- CorrelationCoefficients>TrueCorrelation
count_true <- sum(Coef_more_than_realCor == TRUE)
print(count_true/Perm)
