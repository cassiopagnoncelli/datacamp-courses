# NONLINEAR REGRESSION MODELS.
Sys.setenv(TZ = 'UTC')

library('forecast')
library('ggplot2')
require('fpp2')
library('seasonal')
library('hts')

# Preparation.
t = time(marathon)
tb1 = ts(pmax(0, t - 1940), start = 1897)
tb2 = ts(pmax(0, t - 1980), start = 1897)

t.new = t[length(t)] + seq(h)
tb1.new = tb1[length(tb1)] + seq(h)
tb2.new = tb2[length(tb2)] + seq(h)
newdata = cbind(t = t.new, tb1 = tb1.new, tb2 = tb2.new) %>% as.data.frame()

h = 10

# Method 1. Linear.
fit.lin = tslm(marathon ~ trend)
fcasts.lin = forecast(fit.lin, h = h)

# Method 2. Exponential.
fit.exp = tslm(marathon ~ trend, lambda = 0)
fcasts.exp = forecast(fit.exp, h = h)

# Method 3. Piecewise.
fit.pw = tslm(marathon ~ t + tb1 + tb2)
fcasts.pw = forecast(fit.pw, newdata = newdata)

# Method 4. Cubic splines.
fit.spline = tslm(marathon ~ t + I(t^2) + I(t^3) + I(tb1^3) + I(tb2^3))
fcasts.spl = forecast(fit.spline, newdata = newdata)

# Plot.
autoplot(marathon) +
  autolayer(fitted(fit.lin), series = "Linear") +
  autolayer(fitted(fit.exp), series = "Exponential") +
  autolayer(fitted(fit.pw), series = "Piecewise") +
  autolayer(fitted(fit.spline), series = "Cubic Spline") +
  autolayer(fcasts.pw, series="Piecewise") +
  autolayer(fcasts.lin, series="Linear", PI = FALSE) +
  autolayer(fcasts.exp, series="Exponential", PI = FALSE) +
  autolayer(fcasts.spl, series="Cubic Spline", PI = FALSE) +
  xlab("Year") + ylab("Winning times in minutes") +
  ggtitle("Boston Marathon") +
  guides(colour = guide_legend(title = " "))

# Residuals.
marathon %>%
  splinef(lambda=0) %>%
  checkresiduals()
