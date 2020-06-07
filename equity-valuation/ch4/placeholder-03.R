# Calculate ROE
cons_disc$roe <- ___

# Calculate Price to Book ratio
cons_disc$p_bv <- ___(cons_disc$bvps <= 0, ___, ___)

# Remove NA
cons_disc_no_na <- cons_disc[___, ]
head(cons_disc_no_na)
