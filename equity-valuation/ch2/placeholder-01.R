# Combine hist_rev and rev_proj
rev_split <- ___(hist_rev, rev_proj)

# Rename the column headers
___(rev_split) <- seq(2009, 2021, 1)

# Create a bar plot of the data
barplot(rev_split,
        col = c("___", "___"),
        main = "___")
legend("topleft", 
       legend = c("Historical", "Projected"),
       fill = c("red", "blue"))
