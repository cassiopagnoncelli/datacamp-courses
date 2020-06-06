# create dataset of NPV for each cashflow and rate
npv_by_rates <- data.frame(rates) %>%
	group_by(rates) %>%
    mutate(
        npv1 = calc_npv(cf1, rates),
        npv2 = calc_npv(cf2, rates))
   
# plot cashflows over different discount rates     
ggplot(npv_by_rates, aes(x = rates, y = npv1))+
  geom_line() +
  geom_line(aes(y = npv2)) +
  labs( title = "NPV by Discount Rate", subtitle = "A Tale of Two Troubling Cashflows", 
       y = "NPV ($)",x = "Discount Rate (%)") +
  annotate("text", x = 0.2, y = -500, label = "Two break-even points") +
  annotate("text", x = 0.2, y = -2500, label = "No break-even point")
