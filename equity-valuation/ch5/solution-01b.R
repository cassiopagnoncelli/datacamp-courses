# Create a data frame of single series
rev_all <- colSums(rev)
rev_all_df <- data.frame(rev_all)

# Create Trend Variable
rev_all_df$trend <- seq(1, nrow(rev_all_df), 1)

# Create Shift Variable
rev_all_df$shift <- ifelse(rev_all_df$trend <= 7, 0, 1)

# Run regression
reg <- lm(rev_all ~ trend + shift, data = rev_all_df)
summary(reg)
