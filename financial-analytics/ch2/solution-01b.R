# Define PV function: calc_pv
calc_pv <- function(fv, r, n){
    pv <- fv / (1+r)^n
    pv
}

# Use PV function for a single input
calc_pv(100, 0.08, 5)

# Use PV function for range of inputs
n_range <- 1:10
pv_range <- calc_pv(100, 0.08, n_range)
pv_range
