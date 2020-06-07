# Regression model 
reg <- lm(p_bv ~ roe, data = cons_disc)

# Regression summary
summary_reg <- summary(reg)
summary_reg

# Store intercept
a <- summary_reg$coeff[1]
a

# Store beta
b <- summary_reg$coeff[2]
b
