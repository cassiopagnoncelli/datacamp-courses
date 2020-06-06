# Define cashflows
cashflow_old <- rep(-500, 11)
cashflow_new <- c(-2200, rep(-300,10))
options <- 
    data.frame(time = rep(0:10, 2),
               option = c(rep("Old",11),rep("New",11)),
               cashflow = c(cashflow_old, cashflow_new))
                
# Calculate total expenditure with and without discounting
options %>%
    group_by(option) %>%
    summarize(sum_cashflow = sum(cashflow),
              sum_disc_cashflow = sum(calc_pv(cashflow, 0.12, time)) )
