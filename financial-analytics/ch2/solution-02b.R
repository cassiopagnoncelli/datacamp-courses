# Convert real to nominal
r1_real <- 0.08
inflation1 <- 0.03
(r1_nom <- (1 + r1_real)*(1+inflation1) - 1)

# Convert nominal to real
r2_nom <- 0.2
inflation2 <- 0.05
(r2_real <- (1+r2_nom)/(1+inflation2) - 1)
