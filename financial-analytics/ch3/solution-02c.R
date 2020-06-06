# Define profitability index function: calc_profitability_index
calc_profitability_index <- function(init_investment, future_cashflows, r) {
    discounted_future_cashflows <- calc_npv(future_cashflows, r)
    discounted_future_cashflows / abs(init_investment)
}

# Try out function on valid input
init_investment <- -100
cashflows <- c(0, 20, 20, 20, 20, 20, 20, 10, 5)
calc_profitability_index(init_investment, cashflows, 0.08)
