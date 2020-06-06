# Define IRR function: calc_irr
calc_irr <- function(cashflows) {

    uniroot(calc_npv, 
        interval = c(0, 1), 
        cashflows = cashflows)$root
    
}

# Try out function on valid input
cashflows <- c(-100, 20, 20, 20, 20, 20, 20, 10, 5)
calc_irr(cashflows)
