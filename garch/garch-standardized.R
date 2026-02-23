# Compute the standardized returns
stdret <- residuals(garchfit, standardize = TRUE)

# Compute the standardized returns using fitted() and sigma()
stdret <- (ret - fitted(garchfit)) / sigma(garchfit)

# Load the package PerformanceAnalytics and make the histogram
library("PerformanceAnalytics")
chart.Histogram(stdret, methods = c("add.normal","add.density" ), 
                colorset = c("gray","red","blue"))


