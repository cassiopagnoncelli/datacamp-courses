# Create a data frame of single series
rev_all <- ___
rev_all_df <- data.frame(rev_all)

# Create Trend Variable
rev_all_df$trend <- seq(___, nrow(rev_all_df), ___)

# Create Shift Variable
rev_all_df$shift <- ifelse(rev_all_df$trend <= 7, ___, ___)

# Run regression
reg <- lm(___, data = rev_all_df)
summary(reg)
