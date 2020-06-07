# Create a trend variable
rev_all$trend <- seq(1, 13, 1)

# Create shift variable
rev_all$shift <- c(rep(0, 8), rep(1, 5))

# Run regression
reg <- lm(rev_proj ~ trend + shift, data = rev_all)

# Print regression summary
summary(reg)
