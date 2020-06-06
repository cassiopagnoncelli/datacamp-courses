# Define NPV function: calc_npv
calc_npv <- function(cashflows, r) {
  
  n <- 0:(length(cashflows) - 1)
  npv <- sum( calc_pv(cashflows, r, n) )
  npv

}
