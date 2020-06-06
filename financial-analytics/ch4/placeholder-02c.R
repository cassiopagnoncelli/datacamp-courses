# scenario analysis bar chart
ggplot(data = scenario_analysis, 
       aes(x = scenario, y = npv, fill = scenario)) + 
    geom_bar(stat = ___) +
    scale_y_continuous(labels = ___) +
	labs(title = "NPV Scenario Analysis of Nitro Coffee Expansion") +
	guides(___ = FALSE)
