# Set x-axis range
x.range <- c(min(cons_disc$roe), 
             max(cons_disc$roe))

# Set y-axis range
y.range <- c(min(cons_disc$p_bv), 
             max(cons_disc$p_bv))

# Plot data
plot(y = cons_disc$p_bv, 
     x = cons_disc$roe,
     xlab = "Return on Equity",
     ylab = "Price-to-Book",
     xlim = x.range,
     ylim = y.range,
     col = "blue",
     main = "Price-to-Book Value and Return on Equity
     Of Mid-Cap Consumer Discretionary Firms")

# Regress roe on p_bv
reg <- lm(p_bv ~ roe, data = cons_disc)

# Add trend line in red
abline(reg, col = "red")
