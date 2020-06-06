ggplot(sensitivity,
       aes(x = ___, y = ___, col = metric)
       ) +
  geom_line() +
  scale_x_continuous(labels = ___) +
  scale_y_continuous(labels = ___) +
  labs(
    title = "Sensivity Analysis",
    x = "Factor on Original Assumption",
    y = "Projected NPV",
    col = "Metric"
  )
