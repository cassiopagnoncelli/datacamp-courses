library('forecast')
library('ggplot2')
require('fpp2')

# Excellent book on forecasting.
# https://otexts.org/fpp2/

# Deaths.
deaths.lm = tslm(mdeaths ~ trend + fourier(mdeaths,3))
mdeaths.fcast = deaths.lm %>% forecast(data.frame(fourier(mdeaths,3,36)))

mdeaths.fcast %>% autoplot

# Eggs.
fit = ets(eggs, model = "AAN", lambda = 0)

fc1 = forecast(fit, biasadj = TRUE, h = 20, level = 95)
fc2 = forecast(fit, biasadj = FALSE, h = 20)

cols = c("Mean" = "#0000ee","Median" = "#ee0000")

autoplot(fc1) + ylab("Price") + xlab("Year") +
  autolayer(fc2, PI = FALSE, series = "Median") +
  autolayer(fc1, PI = FALSE, series = "Mean") +
  guides(fill = FALSE) +
  scale_colour_manual(name = "Forecasts", values = cols)
