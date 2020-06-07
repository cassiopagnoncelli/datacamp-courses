# Combine hist_rev and rev_proj
rev_split <- rbind(hist_rev, rev_proj)

# Rename the column headers
colnames(rev_split) <- seq(2009, 2021, 1)

# Create a bar plot of the data
barplot(rev_split,
        col = c("red", "blue"),
        main = "Historical vs. Projected Revenues")
legend("topleft",
       legend = c("Historical", "Projected"),
       fill = c("red", "blue"))
