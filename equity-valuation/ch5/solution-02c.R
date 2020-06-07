# Extract 2021 FCFE
fcfe_2021 <- fcfe[5]

# Use perpetuity with growth formula to calculate terminal value
tv_2021 <- fcfe_2021 * (1 + pgr) / (ke - pgr)
tv_2021

# Calculate PV of Terminal Value
pv_terminal <- tv_2021 / (1 + ke)^5
pv_terminal
