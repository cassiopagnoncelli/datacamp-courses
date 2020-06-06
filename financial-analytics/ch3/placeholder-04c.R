# calculate summary metrics
cashflow_comparison <-
  all_cashflows %>%
  group_by(___) %>%
  summarize( npv = calc_npv(___, 0.1),
             irr = calc_irr(___) )
             
# inspect output
cashflow_comparison
             
# visualize summary metrics
ggplot(cashflow_comparison,
       aes(x = ___, y = ___, col = factor(option))) +
  geom_point(size = 5) +
  geom_hline(yintercept = 0.1) +
  scale_y_continuous(label = scales::percent) +
  scale_x_continuous(label = scales::dollar) +
  labs(title = "NPV versus IRR for Project Alternatives",
       subtitle = "NPV calculation assumes 10% discount rate",
       caption = "Line shows actual discount rate to asses IRR break-even",
       x = "NPV ($)", y = "IRR (%)", col = "Option")
