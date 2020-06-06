ggplot(sensitivity,
       aes(x = factor, y = npv, col = metric)
       ) +
  geom_line() +
  scale_x_continuous(labels = scales::percent) +
  scale_y_continuous(labels = scales::dollar) +
  labs(
    title = "Sensivity Analysis",
    x = "Factor on Original Assumption",
    y = "Projected NPV",
    col = "Metric"
  )
