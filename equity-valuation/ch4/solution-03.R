# Calculate ROE
cons_disc$roe <- cons_disc$ltm_eps / cons_disc$bvps

# Calculate Price to Book ratio
cons_disc$p_bv <- ifelse(cons_disc$bvps <= 0, NA, cons_disc$price / cons_disc$bvps)

# Remove NA
cons_disc_no_na <- cons_disc[complete.cases(cons_disc), ]
head(cons_disc_no_na)
