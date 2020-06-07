# Value of Preferred if dividends start five years from now
pref_value_yr5 <- (stated_value * div_rate) / kp
pref_value_yr5

# Value discounted to present
pref_value <- pref_value_yr5 / (1 + kp)^5
pref_value
