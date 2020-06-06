# scenario analysis bar chart
ggplot(data = scenario_analysis, 
       aes(x = scenario, y = npv, fill = scenario)) + 
    geom_bar(stat = "identity") +
    scale_y_continuous(labels = scales::dollar) +
	labs(title = "NPV Scenario Analysis of Nitro Coffee Expansion") +
	guides(fill = FALSE)
