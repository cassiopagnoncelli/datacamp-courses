# Convert monthly to other time periods
r1_mth <- 0.005
r1_quart <- (1 + r1_mth)^3 - 1
r1_semi <- (1 + r1_mth)^6 - 1
r1_ann <- (1 + r1_mth)^12 - 1

# Convert years to other time periods
r2_ann <- 0.08
r2_mth <- (1 + r2_ann)^(1/12) - 1
r2_quart <- (1 + r2_ann)^(1/4) - 1
