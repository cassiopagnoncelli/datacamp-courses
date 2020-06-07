# Preferred dividend in Years 1 to 5
high_div <- ___

# Create vector of Year 1-5 dividends
pref_cf <- rep(high_div, 5)

# Convert to data frame
pref_df <- data.frame(pref_cf)

# Add discount periods
pref_df$periods <- ___

# Calculate discount factors
pref_df$pv_factor <- ___

# Calculate PV of dividends
pref_df$pv_cf <- ___

# Calculate value during high stage
pref_value_high <- ___

# Calculate value of the preferred stock
___
