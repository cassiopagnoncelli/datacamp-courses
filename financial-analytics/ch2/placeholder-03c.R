# Define cashflows
cashflow_old <- rep(-500, 11)
cashflow_new <- c(-2200, rep(___,___))
options <- 
    data.frame(time = rep(0:10, 2),
               option = c(rep("Old",11),rep("New",11)),
               cashflow = c(___, ___))
                
# Calculate total expenditure with and without discounting
options %>%
    group_by(___) %>%
    summarize(sum_cashflow = sum(___),
              sum_disc_cashflow = sum(___(cashflow, 0.12, time)) )
