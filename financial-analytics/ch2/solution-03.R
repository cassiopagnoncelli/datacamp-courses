# Define cashflows
cashflow_a <- c(5000, rep(0,6))
cashflow_b <- c(0, rep(1000,6))

# Calculate pv for each time period
disc_cashflow_a <- calc_pv(cashflow_a, 0.06, 0:6)
disc_cashflow_b <- calc_pv(cashflow_b, 0.06, 0:6)

# Calculate and report total present value for each option
(pv_a <- sum(disc_cashflow_a))
(pv_b <- sum(disc_cashflow_b))
