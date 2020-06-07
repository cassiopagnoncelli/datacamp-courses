# Calculate the Mylan Unlevered Beta
myl_unl_beta <- (myl_beta + debt_beta * (1 - 0.4) * myl_debt_eq) / (1 + (1 - 0.4) * myl_debt_eq)
myl_unl_beta
