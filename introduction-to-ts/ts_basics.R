# Air passengers.
data("AirPassengers")

plot(AirPassengers)

start(AirPassengers)
end(AirPassengers)

# Useful functions.
time(AirPassengers)
deltat(AirPassengers)
frequency(AirPassengers)
cycle(AirPassengers)
is.ts(AirPassengers)

# Random time series.
x_ts = ts(cumsum(rnorm(48)), start = 2004, frequency = 4)
x_ts
plot(x_ts)
str(x_ts)

# White noise model.
# It has constant mean, constant variance, no trend, no periodic pattern, and overall
# no clear patterns or correlation over time.
WN_1 = arima.sim(model = list(order = c(0, 0, 0)), n = 500)
head(WN_1)
ts.plot(WN_1)

WN_2 = arima.sim(model = list(order = c(0, 0, 0)), n = 500, mean = 4, sd = 2)
head(WN_2)
ts.plot(WN_2)
arima(WN_2, order=c(0, 0, 0))

# Random walk model.
# Def. It is an unstable or nonstationary process. It has no specified mean or
# variance, strong dependence over time, and the changes/increments are
# white noise, so pretty much
#   today = yesterday + noise.
# 
rw = cumsum(rnorm(100))
ts.plot(rw)

arima(diff(rw), order=c(0,0,0))

# Weak stationarity.
# Def. Mean of Y(t), variance of Y(t) and covariance of Y(t) and Y(s) are constant
# throughout the time series.
# Corollary. It doesn't show signs of periodicity, so no regular patterns across
# periods.
# Hint. Stationary processes can be modeled with fewer parameters.

# Scatter plot.
# Use pairs().
pairs(cbind(WN_1, WN_2))

# Autocorrelation plot.
# The process is said to be autocorrelated if it depends on at least one lagged ts.
acf(diff(rw), plot=T)
acf(diff(rw), plot=F)

# AR and MA models.
# AIC and BIC are goodness-of-fit measures, comparable to R^2 for regression.
x1 <- arima.sim(model = list(ar=0.5), n = 100)
x2 <- arima.sim(model = list(ar=0.9), n = 100)
x3 <- arima.sim(model = list(ar=-.8), n = 100)
plot(cbind(x1, x2, x3))
acf(cbind(x1, x2, x3))
acf(x1, plot=F)
acf(x2, plot=F)
acf(x3, plot=F)

data(Mishkin, package = "Ecdat")

inflation = as.ts(Mishkin[,1])
ts.plot(inflation)
acf(inflation)

AR_inflation = arima(inflation, order = c(1, 1, 0))
AR_inflation
AIC(AR_inflation)
BIC(AR_inflation)
AR_inflation_fitted = inflation - residuals(AR_inflation)
ts.plot(inflation)
points(AR_inflation_fitted, type='l', col='red', lty=2)
predict(AR_inflation, n.ahead = 6)

MA_inflation = arima(inflation, order=c(0, 1, 1))
MA_inflation
MA_inflation_fitted = inflation - residuals(MA_inflation)
ts.plot(inflation)
points(MA_inflation_fitted, type='l', col='red', lty=2)
predict(MA_inflation, n.ahead = 6)
