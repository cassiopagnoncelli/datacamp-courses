# Calculate present values over range of time periods and discount rates
present_values <- 
  ___(n = 1:10, r = seq(0.05,0.12,0.01)) %>%
  mutate(pv = calc_pv(100, r, n))
     
# Plot present value versus time delay with a separate colored line for each rate
ggplot(present_values, aes(x = n, y = pv, col = ___)) +
  geom_line() +
  ylim(0,100) +
  labs(
    title = "Discounted Value of $100 by Year Received",
    x = "Number of Years in the Future",
    y = "Present Value ($)",
    col = "Discount Rate"
  )
