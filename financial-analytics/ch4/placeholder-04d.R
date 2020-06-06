# Plot waterfall diagram
ggplot(waterfall_data, aes(fill = (end > start))) +
  geom_rect(aes(xmin = row_num - 0.25, xmax = row_num + 0.25, 
                ymin = ___, ymax = ___)) +
  geom_hline(___ = 0) +
  scale_x_continuous(breaks = waterfall_data$row_num, labels = waterfall_data$Metric) +
  # Styling provided for you - check out a ggplot course for more information!
  scale_y_continuous(labels = scales::dollar) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        axis.title.x = element_blank()) +
  guides(fill = FALSE) +
  labs(
      title = "Gross Profit for Proposed Nitro Coffee Expansion",
      subtitle = "Based on pro forma 10-year forecast")
