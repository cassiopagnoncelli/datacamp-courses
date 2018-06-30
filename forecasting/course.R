Sys.setenv(TZ = 'UTC')

# TIME SERIES REVIEW.
# 
# Patterns:
# - Trend: involves long-term increase or decrease in the data
# - Seasonal: periodic pattern due to calendar, of constant length
# - Cylic: rises and falls not fixed with period (data of >2 years).
# 
# Fitted values.
# A fitted value is the forecast of an observation using all previous
# observations, that is, they are one-step forecasts.
#
# Residual.
# Difference between an observation and its fitted value.
# Also, it should look like white noise:
# - uncorrelated
# - mean zero
# - constant variance
# - normally distributed (preferably)
# 
# Forecast error.
# Difference between observed value and its forecast on test set.
# This is different from residuals in two ways:
# - residuals are errors on training set whereas forecast error is
#   on the test set.
# - residuals are based on one-step "forecast" whereas forecast
#   itself can be multi-step.
# 

library('forecast')
library('readxl')
library('ggplot2')
require('fpp2')

# Plotting warm up.
mydata <- read_excel("forecasting/exercise1.xlsx")
head(mydata)

myts <- ts(mydata[,2:4], start = c(1981, 1), frequency = 4)
head(myts)

plot(myts)
autoplot(myts)
autoplot(myts, facets = TRUE) # faceting means separate in multiple plots.

ggseasonplot(a10)
ggseasonplot(a10, polar = T)

beer = window(ausbeer, start=1992)
autoplot(beer)
ggsubseriesplot(beer)

# Autocorrelation.
autoplot(oil)

gglagplot(oil)

ggAcf(oil)

autoplot(sunspot.year)
ggAcf(sunspot.year)

# Naive forecast for Google stocks
autoplot(goog)
autoplot(diff(goog))

ggAcf(diff(goog))

Box.test(diff(goog), lag = 10, type = "Ljung") # tests for ts independence.

fcgoog = naive(goog, 20)

autoplot(fcgoog)
summary(fcgoog)

# Seasonal naive forecast for AUS beer.
fcbeer = snaive(ausbeer, h=16)

autoplot(fcbeer)
summary(fcbeer)

ausbeer %>% snaive() %>% checkresiduals()

# Naive forecast for oil.
fc = naive(oil)

autoplot(oil, series = "Data") + xlab("Year") +
  autolayer(fitted(fc), series = "Fitted") +
  ggtitle("Oil production in Saudi Arabia")

autoplot(residuals(fc))

checkresiduals(residuals(fc))

Box.test(residuals(fc))

# Model accuracy and error measures.
training = window(oil, end = 2003)
test = window(oil, end = 2004)

fc = naive(training, h = 10)

autoplot(fc) +
  autolayer(test, series = "Test data")

accuracy(fc)

# Cross validation.
# Divides ts into train and test and tries to find parameters
# between underfit and overfit, it is usually applied to 1-step
# forecast and minimize RMSE.
# 
# tsCV function is flexible and can be applied to multiple-step
# forecast, however you have to compute your own error measure.
# 
# When tsCV uses h = 1 with no parameters to be estimated, it will
# give same values as residuals.
# 
# Choose the model with the smallest MSE for the particular forecast
# horizon h desired.
# 
e = tsCV(oil, forecastfunction = naive, h = 1)
sqrt(mean(e^2, na.rm = TRUE))

sq = function(u) u^2
for (h in 1:10)
  oil %>% 
    tsCV(forecastfunction = naive, h = h) %>% 
    sq() %>%
    mean(na.rm = TRUE) %>%
    print()

# Google.
# e <- matrix(NA_real_, nrow = length(goog), ncol = 8)
# for (h in 1:8)
#   e[, h] <- tsCV(goog, forecastfunction = naive, h = h)

e = tsCV(goog, forecastfunction = naive, h = 8)

mse <- colMeans(e^2, na.rm = TRUE)

data.frame(h = 1:8, MSE = mse) %>%
  ggplot(aes(x = h, y = MSE)) + geom_point()

# FORECASTING MODELS.
# 
# Simple Exponential Smoothing.
# This model works fine if model has no trend and no seasonality.
# 
#   l[t] = a y[t] + (1 - a) l[t-1], for smoothing
# 
#   y'[t + h] = l[t], for forecasting,
#
# here, y is the observed value, y' is fitted value, and l is 
# the smoothed line.
# 
# Holt's linear trend.
# 
#   l[t] = a y[t] + (1 - a) (l[t-1] + b[t-1]), for smoothing
#   
#   y'[t+h] = l[t] + h*b[t], for forecasting
# 
#   b[t] = beta * (l[t] - l[t-1]) + (1 - beta) b[t-1], for trend.
# 
# a, beta are model params, and l[0] and b[0] are state params.
# In practical terms forecasts continue with same slope indefinitely
# over the future.
# 

oildata = window(oil, start = 1996)
fc = ses(oildata, h = 5)
autoplot(oildata) + autolayer(fc)
summary(fc)

fc <- ses(marathon, h = 10)
autoplot(fc) + autolayer(fitted(fc))
summary(fc)

# SES vs Naive comparison.
train <- subset(marathon, end = length(marathon) - 20)

fcses <- ses(train, h = 20)
fcnaive <- naive(train, h = 20)

accuracy(fcses, x = marathon)
accuracy(fcnaive, x = marathon)

# Holt.
airpass %>% holt(h = 5) %>% autoplot

fcholt <- holt(austa, h=10)
autoplot(fcholt)
summary(fcholt)
checkresiduals(fcholt)

# Damped trend method.
# Changes Holt's method by damping the trend, ie., make the slope
# fades to zero over time; thus short-run forecasts are trended
# and long-run forecasts are constant.
# It has an extra parameter, 0 < phi <= 1, where phi = 1 renders
# identical Holt's linear trend.
# 
fc1 = holt(AirPassengers, h = 15, PI = FALSE)
fc2 = holt(AirPassengers, h = 15, PI = FALSE, damped = TRUE)

autoplot(AirPassengers) +
  xlab("Year") + ylab("millions") +
  autolayer(fc1, series = "Linear trend (Holt's default)") +
  autolayer(fc2, series = "Damped trend")

# Holt-Winter's.
# Holt's exponential smoothing with trend and seasonality.
# 
# There are two versions: additive and multiplicative.
# 
# Additive:
# 
#   l[t] = a (y[t] - s[t-m]) + (1 - a) (l[t-1] + b[t-1]), for smoothing
# 
# Multiplicative (change - for / and + for *):
# 
#   l[t] = a (y[t] / s[t-m]) + (1 - a) (l[t-1] + b[t-1]), for smoothing
# 
aust = window(austourists, start = 2005)

fc1 = hw(aust, seasonal = "additive")
fc2 = hw(aust, seasonal = "multiplicative")

autoplot(aust) + 
  autolayer(fc1, color = "green") + 
  autolayer(fc2, color = "red", ci = FALSE)

# Taxonomy of exponential smoothing methods.
# 
#                       Seasonal component
# Trend component    None(N)    Additive(A)    Multiplicative(M)
#                  +----------------------------------------------
# None(N)          | (N,N)      (N,A)          (N,M)
# Additive(A)      | (A,N)      (A,A)          (A,M)
# Add. damped(Ad)  | (Ad,N)     (Ad,N)         (Ad,N)
# 
# and here's the list
# 
# (N,N) is simple exponential smoothing, fun = ses()
# (A,N) is Holt's linear method, fun = holt()
# (Ad,N) is Additive damped trend method, fun = hw()
# (A,A) is Additive Holt-Winter's method, fun = hw()
# (A,M) is Multiplicative Holt-Winter's method, fun = hw()
# (Ad,M) is Damped multiplicative Holt-Winter's method, fun = hw()
# 
# so, ses() is for no trend or seasonality, holt() is for trend,
# and hw() is for trend and seasonality.
# 

autoplot(a10)
fc <- hw(a10, seasonal = "multiplicative", h = 12 * 3)
checkresiduals(fc)
autoplot(fc)

train = subset(hyndsight, end = length(hyndsight) - 4*7)
fchw <- hw(train, seasonal = "additive", h = 4*7)
fcsn <- snaive(train, h = 4*7)
accuracy(fchw, hyndsight)
accuracy(fcsn, hyndsight)
autoplot(fcsn)
autoplot(fchw)

# State space models.
# Models characterized by input, output and state variables related by
# first-order differential equations or difference equations.
# It's a way of representing those systems, for instance ARMA(2,0) can be
# represented in state-space model,
# 
# Since
# 
#   x[t] = [ y[t] y[t-1] ]',
#   w[t] = [ e[t] 0 ]
# 
# then
# 
#   y[t] = [1 0] x[t]
# 
#   x[t] = [ [ phi_1 phi_2 ]' [ 1 0 ]' ] x[t-1] + w[t]
# 
# and we can use Kalman filter to compute likelihood and forecasts.
# 
# Filter: the fitted series, or the local mean.
# Smooth: (exponential) smoothing of the filter.
# Forecast: forecast from the filter.
# 
# Each exponential smoothing method can be written as an
# "innovations state space model".
# 
# Trend = { N, A, Ad }
# Seasonal = { N, A, M }
# Error = { A, M }
# 
# That gives 18 (=3*3*2) possible state space models.
# 
# ETS (Error-Trend-Seasonal).
# Finds the best model by minimizing AICc.
# 
# Other models: DLM, STS.
# 
fit = ets(ausair)
fit %>% forecast %>% autoplot
summary(fit)
checkresiduals(fit)

fit = ets(h02)
fit %>% forecast %>% autoplot
summary(fit)
checkresiduals(fit)

fit = ets(lynx) # ETS won't work well for this example.
autoplot(lynx)
fit %>% forecast %>% autoplot
summary(fit)
checkresiduals(fit)

# Variance stabilization.
# Transformations are useful to make the series homoskedastic.
# 
# Functions: square root, cube root, log, inverse.
# 
# So for instance usmelec applying these functions we see variance
# stabilization, ie. even out the variance, somewhere around the
# log and inverse of the series.
# 
# Box-Cox transformations make up the work,
# 
#   w[t] = log(y[t]) if lambda = 0, (y[t]^lambda - 1)/lambda, cc.
# 
# so,
# 
#   lambda = 1 implies no transformation,
#   lambda = 1/2 implies square root plus linear transformation
#   lambda = 1/3 implies cube root plus linear transformation
#   lambda = 0 implies natural log transformation
#   lambda = -1 implies inverse transformation.
# 
autoplot(usmelec) + xlab("Year") + ylab("") + ggtitle("US mon pow gen")

BoxCox.lambda(usmelec)

usmelec %>%
  ets(lambda = -0.57) %>%
  forecast(h = 60) %>%
  autoplot

# Seasonal differencing.
h02 %>% autoplot()

difflogh02 <- diff(log(h02), lag = 12)
autoplot(difflogh02)

ddifflogh02 <- diff(difflogh02)
ddifflogh02 %>% autoplot()
ggAcf(ddifflogh02)

# ARIMA.
fit = auto.arima(austa)
checkresiduals(fit)
summary(fit)
fit %>% forecast(h = 10) %>% autoplot

austa %>% 
  Arima(order = c(0, 1, 1), include.constant = FALSE) %>% 
  forecast %>% 
  autoplot

austa %>% Arima(order = c(0, 1, 1), include.constant = FALSE) %>% forecast() %>% autoplot()
austa %>% Arima(order = c(2, 1, 3), include.constant = TRUE) %>% forecast() %>% autoplot()
austa %>% Arima(order = c(0, 0, 1), include.constant = TRUE) %>% forecast() %>% autoplot()
austa %>% Arima(order = c(0, 2, 1), include.constant = FALSE) %>% forecast() %>% autoplot()

# ARIMA vs ETS comparison.
fets <- function(x, h) forecast(ets(x), h = h)
farima <- function(x, h) forecast(auto.arima(x), h=h)

e1 <- tsCV(austa, fets, h=1)
e2 <- tsCV(austa, farima, h=1)

mean(e1^2, na.rm=T)
mean(e2^2, na.rm=T)

austa %>% fets(h = 10) %>% autoplot()
austa %>% farima(h = 10) %>% autoplot()


train <- window(qcement, start = 1988, end = c(2007, 4))

fit1 <- auto.arima(train)
fit2 <- ets(train)

checkresiduals(fit1)
checkresiduals(fit2)

fc1 <- forecast(fit1, h = 25)
fc2 <- forecast(fit2, h = 25)

accuracy(fc1, qcement)
accuracy(fc2, qcement)

# Dynamic regression, or ARIMA-X.
# 
# Essentially it is a regression model where the explanatory variables
# are other time series,
# 
#   y[t] = b[0] + b[1] x[1,t] + b[2] x[2,t] + ... + b[r] x[r,t] + e[t],
# 
# the only difference being in dynamic regression e[t] is an ARIMA process
# whereas in standard regression it is just white noise.
# 
# In practice it fits a linear regression on the xreg (or x[i,t]) then
# fits an ARIMA model on the errors.
# 
# For instance, we want to forecast consumption using income as explanatory
# variable (and vice versa). Clearly there is a relationship between those
# two variables.
# 
autoplot(uschange[,1:2], facets = TRUE) +
  xlab("Year") + ylab("") + ggtitle("US consumption and income (changes)")

ggplot(aes(x = Income, y = Consumption), 
       data = as.data.frame(uschange[,1:2])) +
  geom_point() +
  ggtitle("Quarterly changes in US consumption and personal income")

fit = auto.arima(uschange[,"Consumption"], xreg = uschange[,"Income"])
summary(fit)
checkresiduals(fit) # yes, they do look like white noise, p-value > 0.05.

fcast = forecast(fit, xreg = rep(.8, 8)) # needs to provide xreg
autoplot(fcast) + xlab("Year") + ylab("% change")

# Example on adverts.
autoplot(advert, facets = TRUE)
fit = auto.arima(advert[, "sales"], xreg = advert[, "advert"], stationary = T)
fc = forecast(fit, xreg = rep(10, 6))
autoplot(fc) + xlab("Month") + ylab("Sales")

# Example on electricity.
# autoplot(elecdemand[, c("Demand", "Temperature")], facets = FALSE)
# 
# xreg = cbind(MaxTemp = elecdemand[, "Temperature"],
#              MaxTempSq = elecdemand[, "Temperature"]^2,
#              Workday = elecdemand[,"WorkDay"])
# 
# fit = auto.arima(elecdemand[,"Demand"], xreg = xreg)
# 
# forecast(fit, xreg = cbind(20, 400, 1))
# 

# DYNAMIC HARMONIC REGRESSION.
# It can approximate any periodic function.
# 
# Periodic seasonality can be handled using pairs of Fourier terms:
# 
#   s_k[t] = sin((2 pi k t) / m),  c_k[t] = cos((2 pi k t) / m)
# 
#      y[t] = c[0] + sum(a[k] s_k[t] + b[k] c_k[t], k = 1..K) + e[t]
# 
# where y[t] is local trend, e[t] is error, and s_k and c_k are
# trigonometric terms.
# 
# Note. K cannot be more than half of the seasonal period, K <= m/2.
# 
# Because seasonality is modeled by the Fourier terms, normally we
# use non-seasonal model ARIMA for modeling errors e[t].
# 

# Example on eating out. Australian coffee consumption.
# Choose different K to see more complicated models (best is K = 5).
K = 5

fit = auto.arima(auscafe, 
                 xreg = fourier(auscafe, K = K), 
                 seasonal = FALSE, 
                 lambda = 0)
summary(fit)

fit %>% forecast(xreg = fourier(auscafe, K = K, h = 24)) %>% 
  forecast %>% autoplot

# Example on gasoline.
# Here we have terms s_k and c_k, k = 1..13, respecting the limit of K <= 26.
harmonics = fourier(gasoline, K = 13)
head(harmonics)

fit = auto.arima(gasoline, xreg = harmonics, seasonal = FALSE)
summary(fit)

forecast(fit, xreg = fourier(gasoline, K = 13, h = 156)) %>% autoplot()

# Multiple seasonalities.
# Two seasonalities: 48 (one day of 1/2 hours) and 336 (one week)
# 
# auto.arima() would take a long time to fit a long time series such
# as this one, so instead you will fit a standard regression model
# with Fourier terms using the tslm() function. This is very similar
# to lm() but is designed to handle time series. With multiple
# seasonality, you need to specify the order K for each of the
# seasonal periods.
# 
# tslm() is a wrapper for lm() accounting for trend and season.
# 

# Example on Taylor electricity consumption.
# This model fails autocorrelation test, ie. lags are correlated so
# residuals aren't white noise.
autoplot(taylor)

fit = tslm(taylor ~ fourier(taylor, K = c(10, 10)))
summary(fit)
checkresiduals(fit)

fit %>%
  forecast(newdata = data.frame(fourier(taylor, K = c(10,10), h = 960))) %>%
  autoplot

# Example on calls data, 5-min call volume for a bank.
# 
# The residuals in this case still fail the white noise tests, but
# their autocorrelations are tiny, even though they are significant.
# This is because the series is so long. It is often unrealistic to
# have residuals that pass the tests for such long series. The effect
# of the remaining correlations on the forecasts will be negligible.
autoplot(calls)

xreg = fourier(calls, K = c(10, 0))
fit = auto.arima(calls, xreg = xreg, seasonal = FALSE, stationary = TRUE)
summary(fit)
checkresiduals(fit)

fit %>%
  forecast(xreg = fourier(calls, K = c(10, 0), h = 10 * 169)) %>%
  autoplot

# TBATS model.
# 
# Accounts for many families of functions,
# - trigonometric terms for seasonality.
# - Box-Cox transformations for heterogeinity
# - ARMA errors for short-term dynamics
# - Trend (possibly damped)
# - Seasonal (including multiple and non-integer periods)
# 
# This is one of the most generic models, but it also makes it very
# dangerous ecause the best fit model not always are even reasonable.
# However, prediction intervals are often too wide and is very slow on
# long time series.
# 

# Example on gasoline.
# Parameters:
#  1: Box-Cox parameter (1 means no transformation is required).
#  {0,0}: ARMA error((0,0) means simples white noise error)
#  —: damping parameter (dash means no damping)
#  {<52.18, 12>}: Fourier terms (one season of 52.18 periods with K=14)
# 
gasoline %>% tbats %>% forecast %>% autoplot() +
  xlab("Year") + ylab("1,000's of barrels per day")

calls %>% window(start = 20) %>% tbats() %>% forecast() %>% 
  autoplot() + xlab("Weeks") + ylab("Calls")

# Example on gas price.
autoplot(gas)

gas %>% tbats() %>% forecast(h = 5 * 12) %>% autoplot

# Example on a random walk.
y = ts(rnorm(120,0,10) + 20*sin(2*pi*(1:120)/12), frequency=12)
fit = tslm(y ~ trend + season) # inspect without season to see.
summary(fit)

fit %>% forecast %>% autoplot

Acf(y)
Pacf(y)
CV(fit) # works with objects produced by lm and tslm.

# STL model.
# Stands for Season, Trend, Loess.
# It decomposes time series into seasonal, trend, and irregular
# components using loess().
# 

# Example on air passengers.
plot(stlf(AirPassengers, lambda=BoxCox.lambda(AirPassengers)))

# Example on random walk.
y = ts(rnorm(120,0,10) + 20*sin(2*pi*(1:120)/12), frequency = 12)

fit = stl(y)
summary(fit)

fit %>% forecast %>% autoplot
