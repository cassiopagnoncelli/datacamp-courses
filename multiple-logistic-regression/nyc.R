library('ggplot2')
library('broom') # augment()
library('dplyr')
library('plotly')

nyc = read.csv("multiple-logistic-regression/nyc.csv", header = TRUE)

# Explanatory data analysis.
# 
# As noted price, decor, and food are strongly correlated.
pairs(nyc)

# Price by Food plot
ggplot(nyc, aes(y = Price, x = Food)) +
  geom_point()

lm(Price ~ Food, nyc)

nyc %>% group_by(East) %>% summarize(mean_price = mean(Price))

# Price by food and service
mod = lm(Price ~ Food + Service, nyc)
mod

plot_ly(data = nyc, z = ~Price, x = ~Food, y = ~Service, opacity = 0.6) %>%
  add_markers()

# Price by food and service broken down by location.
plot_ly(data = nyc, z = ~Price, x = ~Food, y = ~Service, opacity = 0.6) %>%
  add_markers(color = ~factor(East)) 
