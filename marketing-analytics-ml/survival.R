library('readr')
library('dplyr')
library('corrplot')
library('ggplot2')
library('boot')
library('survival')
library('tibble')
library('rms')

survData = read.csv("data/survivalDataExercise.csv", header=T)
survData

survObj <- Surv(survData$daysSinceFirstPurch, survData$boughtAgain)
survObj
str(survObj)

# SURVIVAL FUNCTION.
# - Survival function gives the probability that a customer will not
#   churn up to time t.
# - Cumulative function is the cumulative risk (or probability) customer will
#   have churned up to time t.
fitKMSimple <- survfit(survObj ~ 1)
print(fitKMSimple)

plot(
  fitKMSimple,
  conf.int = FALSE,
  xlab = "Time since first purchase",
  ylab = "Survival function",
  main = "Survival function")

# How is voucher related with survival?
# Customers using a voucher seem to take longer to place their second order.
# They are maybe waiting for another voucher?
fitKMCov <- survfit(survObj ~ voucher, data = survData)

plot(
  fitKMCov,
  lty = 2:3,
  xlab = "Time since first purchase",
  ylab = "Survival function",
  main = "Survival function")
legend(90, .9, c("No", "Yes"), lty = 2:3)

# HAZARD RATE.
# Describes the risk that an event will occur in a small interval around
# time t given the event has not yet happened.
# Also called Force of Mortaility, or Instantenous Event Rate.

# 
# COX-PH MODEL WITH CONSTANT VARIATES
# 

# Determine distributions of predictor variables
dataNextOrder = as_tibble(survData)
dd <- datadist(dataNextOrder)
options(datadist = "dd")

# Compute Cox PH Model and print results
fitCPH <- cph(
  Surv(daysSinceFirstPurch, boughtAgain) ~ 
    shoppingCartValue + voucher + returned + gender,
  data = dataNextOrder,
  x = TRUE, y = TRUE, surv = TRUE)
print(fitCPH)

# Effects are exponential, an increase of 1 in a predictor will increase hazard
# in exp(coef).
exp(fitCPH$coefficients)
plot(summary(fitCPH), log = TRUE)

# Predictions.
# Interpretation is, variables with p < 0.05 change over time,
# for instance, gender=male changes over time so can't really be used in
# hazard function.
testCPH = cox.zph(fitCPH)
print(testCPH)

plot(testCPH, var = 'gender=male') # violated if line is not horizontal.
plot(testCPH, var = 'voucher')

# Validating the model.
# R^2 is 
validate(fitCPH, method = 'crossvalidation', B = 10, pr = FALSE)

# Survival function for one specific customer.
pointData = data.frame(
  daysSinceFirstPurch = 65,
  shoppingCartValue = 190,
  gender = 'female',
  voucher = 1,
  returned = 0,
  boughtAgain = 1
)

str(survest(fitCPH, newdata = pointData, times = 130)) # Survival at month 130.
plot(survfit(fitCPH, newdata = pointData)) # Customer survival curve.
print(survfit(fitCPH, newdata = pointData)) # Expected median time to churn.

