# Set x-axis range
x.range <- c(___(cons_disc$roe), 
             ___(cons_disc$roe))

# Set y-axis range
y.range <- c(___(cons_disc$p_bv), 
             ___(cons_disc$p_bv))

# Plot data
plot(y = ___,
     x = ___,
     xlab = "___",
     ylab = "___",
     xlim = x.range,
     ylim = y.range,
     col = "blue",
     main = "Price-to-Book Value and Return on Equity
     Of Mid-Cap Consumer Discretionary Firms")

# Regress roe on p_bv
reg <- lm(p_bv ~ roe, data = cons_disc)

# Add trend line in red
___(___, col = "red")
