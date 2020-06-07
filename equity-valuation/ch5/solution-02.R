# Subset Treasury data to 12/30/16
rf <- subset(treas, treas$date == "2016-12-30")

# Keep 2nd column
rf_yield <- rf[, 2]

# Convert to decimal terms
rf_yield_dec <- rf_yield/100
rf_yield_dec

# Calcualte difference between S&P 500 Return and Treasury Return
diff <- damodaran$sp_500 - damodaran$tbond_10yr

# Calculate average difference
erp <- mean(diff)
erp

# Calculate CAPM Cost of Equity
ke <- rf_yield_dec + beta * erp
ke
