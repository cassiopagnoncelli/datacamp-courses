# Run regression
reg <- lm(myl ~ spy, data = rets)

# Save beta
beta <- summary(reg)$coeff[2]
beta
