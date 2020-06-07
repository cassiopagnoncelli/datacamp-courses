# Calculate Discount Periods to 12/31/2016
fcfe$disc_periods <- seq(1, 5, 1)

# Calculate discount factor
fcfe$disc_factor <- 1 / (1 + ke)^fcfe$disc_periods

# Calculate PV of each period's total free cash flow
fcfe$pv <- fcfe$fcfe * fcfe$disc_factor

# Calculate Projection Period Value
pv_proj_period <- sum(fcfe$pv)
pv_proj_period
