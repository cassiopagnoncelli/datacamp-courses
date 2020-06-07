# Preferred dividend in Years 1 to 5
high_div <- stated_value * div_rate_high

# Create vector of Year 1-5 dividends
pref_cf <- rep(high_div, 5)

# Convert to data frame
pref_df <- data.frame(pref_cf)

# Add discount periods
pref_df$periods <- seq(1, 5, 1)

# Calculate discount factors
pref_df$pv_factor <- 1 / (1 + kp)^pref_df$periods

# Calculate PV of dividends
pref_df$pv_cf <- pref_df$pref_cf * pref_df$pv_factor

# Calculate value during high stage
pref_value_high <- sum(pref_df$pv_cf)

# Calculate value of the preferred stock
pref_value_high + pref_value_low
