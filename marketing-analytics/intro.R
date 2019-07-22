library('readr')
library('dplyr')
library('corrplot')
library('ggplot2')

salesData = read.csv("data/salesData.csv", header=T)

# Exercise 1: correlation of variables
str(salesData, give.attr = FALSE)

salesData %>% select_if(is.numeric) %>%
  select(-id) %>%
  cor() %>% 
  corrplot()

ggplot(salesData) +
  geom_boxplot(aes(x = mostFreqStore, y = salesThisMon))

ggplot(salesData) +
  geom_boxplot(aes(x = preferredBrand, y = salesThisMon))

# Exercise 2: linear model for sales data.
salesSimpleModel <- lm(salesThisMon ~ salesLast3Mon, data = salesData)

summary(salesSimpleModel)

# Exercise 3: avoiding multicollinearity
library('rms')

salesModel1 <- lm(salesThisMon ~ . - id,data = salesData)
vif(salesModel1)

salesModel2 <- lm(salesThisMon ~ . -id - preferredBrand - nBrands, data = salesData)
vif(salesModel2)

# Exercise 4: churn data description, stepAIC auto selects the best explanatory
# variable set to form optimal model.
churnData = read.csv("data/churn_data.csv", header=T)

str(churnData)
summary(churnData)

logitModelFull = glm(returnCustomer ~ . - orderDate - ID, family = binomial, data = churnData)
summary(logitModelFull)

library('MASS')

logitModelNew = stepAIC(logitModelFull, trace = 0)
summary(logitModelNew)

# Exercise 4: default data description
defaultData = read.csv("data/defaultData.csv", header=T, sep=';')

logitModelFull <- glm(PaymentDefault ~ limitBal + sex + education + marriage +
  age + pay1 + pay2 + pay3 + pay4 + pay5 + pay6 + billAmt1 + 
  billAmt2 + billAmt3 + billAmt4 + billAmt5 + billAmt6 + payAmt1 + 
  payAmt2 + payAmt3 + payAmt4 + payAmt5 + payAmt6, 
  family = binomial, data = defaultData)

summary(logitModelFull)
coefsexp <- coef(logitModelFull) %>% exp() %>% round(2)

logitModelNew <- stepAIC(logitModelFull, trace = 0) 
summary(logitModelNew) 

# Exercise 5: model accuracy performance
defaultData$predFull <- predict(logitModelFull, type = "response", na.action = na.exclude)

confMatrixModelFull <- confusion.matrix(defaultData$PaymentDefault, defaultData$predFull, threshold = 0.5)
confMatrixModelFull

accuracyFull <- sum(diag(confMatrixModelFull)) / sum(confMatrixModelFull)
accuracyFull

defaultData$predNew <- predict(logitModelNew, type = "response", na.action = na.exclude)

confMatrixModelNew <- confusion.matrix(defaultData$PaymentDefault, defaultData$predNew, threshold = 0.5)
confMatrixModelNew

accuracyNew <- sum(diag(confMatrixModelNew)) / sum(confMatrixModelNew)
accuracyNew

accuracyFull

# Exercie 6: finding the optimal threshold
library("SDMTools")

payoffMatrix <- data.frame(threshold = seq(from = 0.1, to = 0.5, by = 0.1), payoff = NA) 
payoffMatrix

for(i in 1:length(payoffMatrix$threshold)) {
  confMatrix <- confusion.matrix(defaultData$PaymentDefault,
                                 defaultData$predNew, 
                                 threshold = payoffMatrix$threshold[i])
  payoffMatrix$payoff[i] <- confMatrix[2,2]*1000 + confMatrix[2,1]*(-250)
}

payoffMatrix

# Exercise 7: preventing overfitting with out-of-sample validation.
set.seed(534381)

churnData$isTrain = rbinom(nrow(churnData), 1, 0.66)
train = subset(churnData, churnData$isTrain == 1)
test = subset(churnData, churnData$isTrain == 0)

logitTrainNew = glm(returnCustomer ~ title + newsletter + websiteDesign + 
                      paymentMethod + couponDiscount + purchaseValue +
                      throughAffiliate + shippingFees + dvd + blueray + vinyl +
                      videogameDownload + prodOthers + prodRemitted,
                    family = binomial, data = train)

test$predNew = predict(logitTrainNew, type = "response", newdata = test)

confMatrixNew = confusion.matrix(test$returnCustomer, test$predNew, threshold = 0.3)
confMatrixNew

accuracyNew = sum(diag(confMatrixNew)) / sum(confMatrixNew)
accuracyNew

# Exercise 8: preventing overfitting with cross-validation.
library("boot")

Acc03 = function(r, pi = 0) {
  cm = confusion.matrix(r, pi, threshold = 0.3)
  acc = sum(diag(cm)) / sum(cm)
  return(acc)
}

cv.glm(churnData, logitModelNew, cost = Acc03, K = 6)$delta[1]

# Exercise 9: Out of sample validation in defaultData
defaultData$isTrain <- rbinom(nrow(defaultData), 1, 0.66)
train <- subset(defaultData, defaultData$isTrain == 1)
test <- subset(defaultData, defaultData$isTrain  == 0)

logitTrainNew <- glm(PaymentDefault ~ limitBal + sex + education + marriage +
                       age + pay1 + pay2 + pay3 + pay4 + pay5 + pay6 + billAmt1 + 
                       billAmt2 + billAmt3 + billAmt4 + billAmt5 + billAmt6 + payAmt1 + 
                       payAmt2 + payAmt3 + payAmt4 + payAmt5 + payAmt6,
                     family = binomial, data = defaultData) # Modeling
test$predNew <- predict(logitTrainNew, type = "response", newdata = test) # Predictions

confMatrixModelNew <- confusion.matrix(test$PaymentDefault, test$predNew, threshold = 0.3) 
sum(diag(confMatrixModelNew)) / sum(confMatrixModelNew) # Compare this value to the in-sample accuracy

costAcc <- function(r, pi = 0) {
  cm <- confusion.matrix(r, pi, threshold = 0.3)
  acc <- sum(diag(cm)) / sum(cm)
  return(acc)
}
cv.glm(defaultData, logitModelNew, cost = costAcc, K = 6)$delta[1]
