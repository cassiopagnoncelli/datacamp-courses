# Calculate present values in dataframe
present_values <- data.frame(n = 1:10) %>% mutate(pv = calc_pv(100, 0.08, n))
         
# Plot relationship between time periods versus present value
ggplot(present_values, 
       aes(x = n, y = pv)) +
  geom_line() +
  geom_label(aes(label = paste0("$",round(pv,0)))) +
  ylim(0,100) +
  labs(
    title = "Discounted Value of $100 by Year Received",
    x = "Number of Years in the Future",
    y = "Present Value ($)"
  )
