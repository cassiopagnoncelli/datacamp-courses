library('astsa')

# Wold decomposition.
#
# Wold proved that any stationary time series may be represented
# as a linear combination of white noise:
# 
#   X[t] = W[t] + a[1] W[t-1] + a[2] W[t-2] + ...
# 
# for constants a[i].
# 
# Any ARMA model has this form, which means they are suited to
# modeling time series.

# Generating white noise series.
wn_model = arima.sim(model = list(order = c(0, 0, 0)), n = 100)
plot(wn_model)

# Generating an MA(1) series.
ma_model = arima.sim(model = list(order = c(0, 0, 1), ma = .9), n = 100)
plot(ma_model)

# Generating an AR(2) series.
ar_model = arima.sim(model = list(order = c(2, 0, 0), ar = c(1.5, -.75)), n = 100)
plot(ar_model)

# Autocorrelation functions.
#
# 
#            AR(p)              MA(q)                ARMA(p,q)
# 
#    ACF     tails off          cuts off lag q       tails off
# 
#   PACF     cuts off lag p     tails off            tails off
# 
# tails off: plots all lags
# cuts off: plots from 1 to p lags.
# 
# ACF and PACF are different in the way that PACF accounts for direct
# correlation of x[t] and x[t+k], cor(x[t]-P[x[t]], x[t+k]-P[x[t]]), 
# where P is the projection of x onto space spanned by x[t+1], ..., 
# x[t+k-1]. Looks like complicated but it just means the linear
# dependence of x[t] on x[t+1] through x[t+k-1] is removed.
# On the other hand ACF is the other way around, cor(x[t], x[t+k]),
# as expected.
# 
# Important:
# - AR(p) model has an ACF that tails off and an PACF that cuts off at
#   lag p.
# - MA(q) model has an ACF that cuts off at lag p and an PACF that tails
#   off.
# - ARMA(p, q) model tails off at both charts ACF and PACF.
# 
x = arima.sim(model = list(order = c(1, 0, 0), ar = .9), n = 100)
acf2(x)

# Estimating the parameters.
# 
# Especially for the parameters ma1 and xmean we formulate hypothesis
# 
#   H_0: ma1 = 0
#   H_a: ma1 != 0
#
# and
# 
#   G_0: xmean = 0
#   G_a: xmean != 0
# 
# then given p.value for ma1 is 0 we reject H_0 in favour of H_a
# whereas xmean's p.value = 0.0703 cannot reject G_0 at 5% level.
# In other words low p.value rejects null hypotheses.
# 
# 
fit = sarima(x, p=0, d=0, q=1)
fit

# ARMA.
x = arima.sim(model = list(order = c(1, 0, 1), ar = .9, ma = -.4), n = 200)

plot(x, main = 'ARMA(1,1)')
acf2(x)

x_fit = sarima(x, p=1, d=0, q=1)
x_fit$ttable

# AIC and BIC criterias.
# 
# They measure the error and penalize for adding parameters.
# Their formula is
# 
#     mean((obs - pred)^2) + k (p + q)
#   = MSE + k (p + q)
# 
# where k=2 for AIC and k=log(n) for BIC.
# 
# Goal is to find the model with the smallest AIC or BIC.
# 
x_fit$AIC
x_fit$BIC

# Residual analysis.
#
# QQ-plot: assesses normality, so points should be distributed
#   along the normal line.
# 
# Standardized residuals: Should show no obvious pattern, i.w.o.,
#   should be white noise.
#
# Sample ACF of residuals: No lag should be significant.
# 
# Q-statistics (Ljung-Box statistic): Most of the points should
#   be above the dashed line, i.w.o., p-values of lags should be
#   high meaning we can't reject the hypotheses that each lag of
#   the residuals is zero.
# 

# How to fit a model.
# 
# Add parameters one by one, and search the (p,q) space for
# models whose AIC or BIC are minimal.
# 
# Not only look for the lowest AIC or BIC models but also at
# t-table values for variables with high p-values, meaning those
# variables are not significant.
# 

# Forecasting with an ARIMA(1, 1, 1) model.
oil = window(astsa::oil, end = 2006)
oilf = window(astsa::oil, end = 2007)

sarima.for(oil, n.ahead = 52, 1, 1, 1)

lines(oilf)

# Seasonal models.
# 
# 
#            SAR(P)             SMA(Q)               SARMA(P, Q)
# 
#    ACF     tails off          cuts off lag QS      tails off
# 
#   PACF     cuts off lag PS    tails off            tails off
# 
# It also carries a seasonality factor, like S=12 for annual 
# seasonality on monthly data.

data("AirPassengers")

plot(AirPassengers)
plot(log(AirPassengers))
plot(diff(log(AirPassengers)))
plot(diff(diff(log(AirPassengers)), 12))

x = diff(diff(log(AirPassengers)), 12)

acf2(x, max.lag = 60)

sarima(
  log(AirPassengers), 
  p = 1, d = 1, q = 1,
  P = 0, D = 1, Q = 1,
  S = 12
)

sarima(
  log(AirPassengers), 
  p = 0, d = 1, q = 1,
  P = 0, D = 1, Q = 1,
  S = 12
) # Removing an AR parameter as indicated by t-table.

data("unemp")

sarima(unemp, 2, 1, 0, 0, 1, 1, 12)
sarima.for(unemp, n.ahead = 36, 2, 1, 0, 0, 1, 1, 12)

data("chicken")

sarima(chicken, 2, 1, 0, 1, 0, 0, 12)
sarima.for(chicken, n.ahead = 60, 2, 1, 0, 1, 0, 0, 12)
