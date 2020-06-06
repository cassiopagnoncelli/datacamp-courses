# Define payback function: calc_payback
calc_payback <- function(cashflows) {

  cum_cashflows <- cumsum(cashflows)
  payback_period <- min(which(cum_cashflows >= 0)) - 1
  payback_period

}

# Test out our function
cashflows <- c(-100, 50, 50, 50)
calc_payback(cashflows) == 2
