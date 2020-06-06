# pull last year cashflow from the cashflow vector
last_year_cashflow <- cashflow[length(___)]
last_period_n <- length(___) - 1

# calculate terminal value for different discount rates
terminal_value_1 <- last_year_cashflow / ((0.15 - ___)*(1 + 0.15)^last_period_n)
terminal_value_2 <- last_year_cashflow / ((0.15 - ___)*(1 + 0.15)^last_period_n)
terminal_value_3 <- last_year_cashflow / ((0.15 - ___)*(1 + 0.15)^last_period_n)

# inspect results
terminal_value_1 
terminal_value_2
terminal_value_3
