# Excellent book on forecasting.
# https://otexts.org/fpp2/
# 
# Pending learn:
# - 10   Forecasting hierarchical or grouped time series
# - 11.2 Vector AutoRegressions
# - 11.4 Bootstrapping and bagging.
# - 
# 
# Other models:
# Croston: strategy for products with intermitent (noncontinuous) demand.
# Splines (splinef)
# Theta (thetaf)

Sys.setenv(TZ = 'UTC')

library('forecast')
library('ggplot2')
require('fpp2')
library('seasonal')
library('hts')

# WARM UP.

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


# TIME SERIES DECOMPOSITION.

# X11.
fit = elecequip %>% seas(x11 = "")

autoplot(fit) +
  ggtitle("X11 decomposition of electrical equipment index")

autoplot(elecequip, series="Data") +
  autolayer(trendcycle(fit), series="Trend") +
  autolayer(seasadj(fit), series="Seasonally Adjusted") +
  xlab("Year") + ylab("New orders index") +
  ggtitle("Electrical equipment manufacturing (Euro area)") +
  scale_colour_manual(values=c("gray","blue","red"),
                      breaks=c("Data","Seasonally Adjusted","Trend"))

fit %>% seasonal() %>% ggsubseriesplot() + ylab("Seasonal")

fit %>% seasonal() %>% head()
fit %>% trendcycle() %>% head()
fit %>% remainder() %>% head()
fit %>% seasadj() %>% head()

# SEATS, Seasonal Extraction in ARIMA Time Series.
elecequip %>% seas() %>%
  autoplot() +
  ggtitle("SEATS decomposition of electrical equipment index")

# STL.
elecequip %>%
  stl(t.window = 13, s.window = "periodic", robust = TRUE) %>%
  autoplot()

fit = stl(elecequip, t.window = 13, s.window = "periodic", robust = TRUE)

fit %>% seasadj() %>% naive() %>%
  autoplot() + ylab("New orders index") +
  ggtitle("Naive forecasts of seasonally adjusted data")

fit %>% forecast(method="naive") %>%
  autoplot() + ylab("New orders index")

# DYNAMIC REGRESSION MODELS.

# Dynamic harmonic regression.
cafe04 = window(auscafe, start = 2004)

plots = list()
for (i in seq(6)) {
  fit = auto.arima(cafe04, xreg = fourier(cafe04, K = i),
                   seasonal = FALSE, lambda = 0)
  
  plots[[i]] = fit %>% 
    forecast(xreg = fourier(cafe04, K = i, h = 24)) %>%
    autoplot() + ylab("") + ylim(1.5, 4.7)
      xlab(paste("K=", i, "   AICC=", round(fit[["aicc"]], 2)))
}

gridExtra::grid.arrange(
  plots[[1]], plots[[2]], plots[[3]],
  plots[[4]], plots[[5]], plots[[6]], nrow=3)

print("Zoom out to see all charts.")

# HIERARCHICAL TIME SERIES.
tourism.hts = hts(visnights, characters = c(3, 5))

tourism.hts %>% aggts(levels = 0:1) %>%
  autoplot(facet=TRUE) +
    xlab("Year") + ylab("millions") + ggtitle("Visitor nights")

# NEURAL NETWORK AUTOREGRESSION.
# It is essentially an ARIMA(p, 0, 0) without the restrictions to
# ensure stationarity.
# 
fit = nnetar(lynx)
fit %>% forecast(h = 20) %>% autoplot
fit
summary(fit)
checkresiduals(fit)

fit = nnetar(sunspotarea, lambda = 0) # Box-Cox transf ensure > 0.
fit %>% forecast(h = 30) %>% autoplot
fit
summary(fit)

# Sample paths.
sim = ts(matrix(0, nrow=30L, ncol=9L), start = end(sunspotarea)[1L]+1L)

for(i in seq(9))
  sim[,i] = simulate(fit, nsim=30L)

autoplot(sunspotarea) + autolayer(sim)

fcast = forecast(fit, PI = TRUE, h = 30) # prediction intervals.
autoplot(fcast)

# FORECAST COMBINATIONS.
train = window(auscafe, end = c(2012,9))
h = length(auscafe) - length(train)

ETS = forecast(ets(train), h = h)
ARIMA = forecast(auto.arima(train, lambda = 0, biasadj = TRUE), h = h)
STL = stlf(train, lambda = 0, h = h, biasadj = TRUE)
NNAR = forecast(nnetar(train), h = h)
TBATS = forecast(tbats(train, biasadj = TRUE), h = h)

combination = (
  ETS[["mean"]] + 
  ARIMA[["mean"]] +
  STL[["mean"]] + 
  NNAR[["mean"]] + 
  TBATS[["mean"]]
) / 5

autoplot(auscafe %>% window(start = c(2012, 1))) +
  autolayer(ETS, series = "ETS", PI = FALSE) +
  autolayer(ARIMA, series = "ARIMA", PI = FALSE) +
  autolayer(STL, series = "STL", PI = FALSE) +
  autolayer(NNAR, series = "NNAR", PI = FALSE) +
  autolayer(TBATS, series = "TBATS", PI = FALSE) +
  autolayer(combination, series = "Combination") +
  xlab("Year") + ylab("$ billion") +
  ggtitle("Australian monthly expenditure on eating out")

c(
  ETS = accuracy(ETS, auscafe)["Test set","RMSE"],
  ARIMA = accuracy(ARIMA, auscafe)["Test set","RMSE"],
  `STL-ETS` = accuracy(STL, auscafe)["Test set","RMSE"],
  NNAR = accuracy(NNAR, auscafe)["Test set","RMSE"],
  TBATS = accuracy(TBATS, auscafe)["Test set","RMSE"],
  combination = accuracy(combination, auscafe)["Test set","RMSE"]
)

# Forecasting on training and testsets.
training = subset(auscafe, end = length(auscafe) - 61)
test = subset(auscafe, start = length(auscafe) - 60)
cafe.train = Arima(training, 
                   order = c(2, 1, 1), 
                   seasonal = c(0, 1, 2), 
                   lambda = 0)

cafe.train %>% forecast(h = 60) %>% autoplot() + autolayer(test)

autoplot(training, series="Training data") +
  autolayer(fitted(cafe.train, h = 12), series="12-step fitted values")

Arima(test, model=cafe.train) %>% accuracy()

# Forecasting long time series.
# 
# "A better approach is usually to allow the model itself to
# change over time. ETS models are designed to handle this
# situation by allowing the trend and seasonal terms to evolve
# over time. ARIMA models with differencing have a similar
# property. But dynamic regression models do not allow any
# evolution of model components."
# 
# ARIMA and ETS tend to work decently on long time series as
# they evolve with ts, whereas dynamic regression models don't.
# 
