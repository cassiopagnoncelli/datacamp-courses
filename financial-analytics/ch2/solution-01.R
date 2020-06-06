# Assign input variables
fv <- 100
r <- 0.08

# Calculate PV if receive FV in 1 year
pv_1 <- fv / (1 + r)
pv_1

# Calculate PV if receive FV in 5 years
pv_5 <- fv / (1 + r)^5
pv_5

# Calculate difference
pv_1 - pv_5
