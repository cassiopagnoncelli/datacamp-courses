# Add discount periods
fcfe$periods <- seq(1, 5, 1)
fcfe

# Calculate Present Value Factor
fcfe$pv_factor <- 1 / (1 + ke)^fcfe$periods
fcfe

# Calculate Present Value of each Cash Flow
fcfe$pv <- fcfe$fcfe * fcfe$pv_factor
fcfe

# Total Present Value
pv_fcfe <- sum(fcfe$pv)
pv_fcfe
