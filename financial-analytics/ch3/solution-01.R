# Inspect variables
cashflows

# Calculate cumulative cashflows
cum_cashflows <- cumsum(cashflows)

# Identify payback period
payback_period <- min(which(cum_cashflows >= 0)) - 1

# View result
payback_period
