# Review treas
head(treas)

# Extract 2016-12-30 yield 
rf <- subset(treas, treas$date == "2016-12-30")
rf

# Keep only the observation in the second column
rf_yield <- rf[, 2]
rf_yield

# Convert yield to decimal terms
rf_yield_dec <- rf_yield / 100
rf_yield_dec
