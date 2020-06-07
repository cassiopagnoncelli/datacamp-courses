# Create a bar chart
barplot(rev,
    col = c("red", "blue"),
    main = "Historical vs. Projected Revenues")

# Add legend
legend("topleft",
       legend = c("Historical", "Projected"),
       fill = c("red", "blue"))
