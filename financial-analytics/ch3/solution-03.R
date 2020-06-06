# Pull last year cashflow from the cashflow vector
last_year_cashflow <- cashflow[length(cashflow)]
last_period_n <- length(cashflow) - 1

# Calculate terminal value for different discount rates
terminal_value_1 <- last_year_cashflow / ((0.15 - 0.10)*(1 + 0.15)^last_period_n)
terminal_value_2 <- last_year_cashflow / ((0.15 - 0.01)*(1 + 0.15)^last_period_n)
terminal_value_3 <- last_year_cashflow / ((0.15 + 0.05)*(1 + 0.15)^last_period_n)

# Inspect results
terminal_value_1 
terminal_value_2
terminal_value_3
