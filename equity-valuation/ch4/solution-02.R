# Calculate P/LTM EPS
pharma$ltm_p_e <- ifelse(pharma$ltm_eps <= 0, NA, pharma$price / pharma$ltm_eps)

# Calculate P/NTM EPS
pharma$ntm_p_e <- ifelse(pharma$ntm_eps <= 0, NA, pharma$price / pharma$ntm_eps)

# Calculate P/BVPS
pharma$p_bv <- ifelse(pharma$bvps <= 0, NA, pharma$price / pharma$bvps)
pharma
