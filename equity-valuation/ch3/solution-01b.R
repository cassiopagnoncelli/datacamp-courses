# Show first six observations of prices
head(prices)

# Calculate MYL monthly return
rets <- Delt(prices$myl)

# Calculate SPY monthly return
rets$spy <- Delt(prices$spy)

# Change label of first variable
names(rets)[1] <- "myl"

# Remove first observation - NA
rets <- rets[-1, ]
