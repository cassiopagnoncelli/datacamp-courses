# Plot the return series
plot(ret)

# Specify the garch model to be used
garchspec <- ugarchspec(mean.model = list(armaOrder = c(0,0)),
                       variance.model = list(model = "sGARCH"),
                        distribution = "sstd")

# Estimate the model
garchfit <- ugarchfit(data = ret, spec = garchspec)

# Inspect the coefficients
coef(garchfit)

