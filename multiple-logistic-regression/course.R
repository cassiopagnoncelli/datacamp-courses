library('ggplot2')
library('broom') # augment()
library('dplyr')

# Model using factor.
mod = lm(hwy ~ displ + factor(year), mpg)
summary(mod)

augmented_mod = augment(mod)
glimpse(augmented_mod)

ggplot(data = mpg, aes(x = displ, y = hwy, color = factor(year))) +
  geom_point() +
  geom_smooth(method = "lm", se = 0)

# Model using factor and interaction.
# 
# Interaction, :,  is actually a multiplication of variables, model
# will be
# 
#   hwy = b0 + b1 * displ + b2 * factor(year)
#         + b3 * displ * factor(year) + e
# 
mod = lm(hwy ~ displ + factor(year) + displ:factor(year), mpg)
summary(mod)

augmented_mod = augment(mod)
glimpse(augmented_mod)

ggplot(data = mpg, aes(x = displ, y = hwy, color = factor(year))) +
  geom_point() +
  geom_smooth(method = "lm", se = 0)

# The R^2.
# 
# SSE: sum of squared errors (=residuals).
# 
# R-squared: 1 - SSE/SST, the coefficient of determination.
# 
# Adj R-squared: 1 - SSE/SST * (n-1)/(n-p-1)
#   The additional term is a penalty for having many variables.
#   This is only useful when dealing with multiple explanatory variables.
# 
# Adding new variables causes to increase R^2, even white noise is able
# to increase R^2. So we have to adjust it. This is done by adding a
# penalty of (n-1) / (n-p-1) to R^2.
# 

# Note on augmenting models.
# Providing a newdata dataframe can be used to fit values (1-step 
# predictions) and find the standard error.
# 

# 3D scatter plot.
# p <- plot_ly(data = mario_kart, z = ~totalPr, x = ~duration, 
#              y = ~startPr, opacity = 0.6) %>%
#   add_markers() 
# 
# p %>%
#   add_surface(x = ~x, y = ~y, z = ~plane, showscale = FALSE)
# 

# Logistic regression.
# Model is given by
# 
#   log(y / (1-y)) = b0 + b1 x + e
# 
# Fitting a GLM can be like
# 
#   glm(Acceptance ~ GPA, data = MedGPA, family = binomial)
# 
# where binomial family uses logistic function.
# 
MedGPA = read.csv("multiple-logistic-regression/medgpa.csv", header = TRUE)

mod = glm(formula = Acceptance ~ GPA, family = binomial, data = MedGPA)

MedGPA %>% ggplot(aes(x = GPA, y = Acceptance)) + 
  geom_jitter(width = 0, height = 0.05, alpha = .5) +
  geom_smooth(method = "glm", se = FALSE, 
              method.args = structure(list(family = "binomial"), 
                                      .Names = "family"))

MedGPA_plus <- mod %>% augment(type.predict = "response")

MedGPA_binned = MedGPA %>% 
  group_by(bin = cut(GPA, 6)) %>%
  summarize(mean_GPA = mean(GPA), acceptance_rate = mean(Acceptance))
MedGPA_binned

MedGPA_binned %>% 
  ggplot(aes(x = mean_GPA, y = acceptance_rate)) + 
  geom_point() + geom_line() +
  geom_line(data = MedGPA_plus, aes(x = GPA, y = .fitted), color = "red")

# Odds of being accepted.
MedGPA_binned <- MedGPA_binned %>%
  mutate(odds = acceptance_rate / (1 - acceptance_rate))

data_space <- ggplot(data = MedGPA_binned, aes(x = mean_GPA, y = odds)) + 
  geom_point() + geom_line()

MedGPA_plus <- MedGPA_plus %>% mutate(odds_hat = .fitted / (1 - .fitted))

data_space +
  geom_line(data = MedGPA_plus, aes(x = GPA, y = odds_hat), color = "red")

# Log-odds scale.
MedGPA_binned <- MedGPA_binned %>%
  mutate(log_odds = log(acceptance_rate / (1 - acceptance_rate)))

data_space <- ggplot(data = MedGPA_binned, aes(x = mean_GPA, y = log_odds)) + 
  geom_point() + geom_line()

MedGPA_plus <- MedGPA_plus %>% mutate(log_odds_hat = log(.fitted / (1 - .fitted)))

data_space +
  geom_line(data = MedGPA_plus, aes(x = GPA, y = log_odds_hat), color = "red")

# Making probabilistic predictions.
# 
# We use type.predict = "response" to inject logistic function into the
# response variable, so result will be in the range (0,1).
new_data <- data.frame(GPA = 3.51)
augment(mod, newdata = new_data, type.predict = "response")

# Acceptance confusion matrix.
tidy_mod <- mod %>% augment(type.predict = "response") %>%
  mutate(Acceptance_hat = round(.fitted))

tidy_mod %>%
  select(Acceptance, Acceptance_hat) %>% 
  table()

# COLLINEARITY.
# 
# If one variable is a multiple of another variable, they are said to be
# colinear.
# 
# Multicollinearity.
# - Explanatory variables are highly correlated
# - Unstable coefficient estimates
# - Doesn't affect R^2
# - Be skeptical of surprising results.
