# Calculate reinvestment amount
reinvestment <- capex[5] - depn_amort[5] + incr_wc[5]
reinvestment

# Calculate retention ratio
retention_ratio <- reinvestment / after_tax_income[5]
retention_ratio
