# Calculate levered beta
beta <- med_beta + (med_beta - debt_beta) * (1 - 0.4) * debt_eq
beta
