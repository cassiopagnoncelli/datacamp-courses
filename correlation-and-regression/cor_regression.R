# REGRESSION TO THE MEAN.
# "Regression to the mean is so powerful that once-in-a-generation
# talent basically never sires once-in-a-generation talent. It explains
# why Michael Jordan’s sons were middling college basketball players and
# Jakob Dylan wrote two good songs. It is why there are no American
# parent-child pairs among Hall of Fame players in any major professional
# sports league."
# (Seth Stephens-Davidowitz)
# Interpretation is that next generation tend to be good, but not as good
# as top talent previous generation.

library('ggplot2')
library('dplyr')

# Cut and scale.
x1 = cumsum(rbinom(100, size=5, prob=0.2))
x2 = cumsum(rnorm(100, mean=1, sd=1))
x = data.frame(x1, x2)

ggplot(data = x, aes(y = x2, x = x1)) + 
  geom_point()  +
  scale_x_continuous("Length of possum tail (cm)") +
  scale_y_continuous("Length of possum body (cm)")

ggplot(data = x, aes(y = x2, x = cut(x1, breaks = 5))) + 
  geom_point()

ggplot(data = x, aes(y = x2, x = cut(x1, breaks = 5))) + 
  geom_boxplot()

ggplot(data = x, aes(y = x2, x = x1)) +
  geom_point() +
  geom_abline(intercept = -10, slope = 1.4) # Params chosen at random.

ggplot(data = x, aes(y = x2, x = x1)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE) # LSQ fit.

# Facet wrap.
noise = data.frame(
  x = rnorm(300),
  y = rnorm(300, mean=4, sd=2),
  z = sample(0:9, 300, replace=T)
)

noise %>% 
  group_by(z) %>% 
  summarize(N = n(), spurious_cor = cor(x, y)) %>%
  filter(abs(spurious_cor) > 0.2)

ggplot(data = noise, aes(x = x, y = y)) +
  geom_point() +
  facet_wrap(~ z)

# Augment with Broom.
library('broom')

fit = lm(y ~ x, noise)
summary(fit)

mod = augment(fit)
mod %>% glimpse()
mod %>% arrange(desc(.resid)) %>% head() # Largest errors first.

sqrt(sum(residuals(fit)^2) / df.residual(fit)) # RMSE.

# Null model benchmark.
# 
# R^2, coefficient of determination (or goodness of fit).
# This is the proportion of variability in the response variable (y) that
# is explained model by our model (a).
# 
# For LSQ fit with *one* explanatory variable, R^2 equals cor(x, y)^2.
# 
mod_null = lm(y ~ 1, noise)

SST = mod_null %>% 
  augment(noise) %>% 
  summarize(SST = sum(.resid^2))

SSE = mod %>% summarize(
  SSE = sum(.resid^2),
  SSE_also = (n() - 1) * var(.resid)
)

1 - SSE[1] / SST # Look for "Multiple R-squared" in summary(fit).

# Leverage (computing leverage from hat matrix).
# This is particularly helpful in identifying unusual points.
# 
# Calculation is given by 
# 
#   h[i] = 1/n + (x[i] - mean(x))^2 / sum((x[i] - mean(x))^2)
# 
# in other words the leverage of a specific observation is entirely a function
# of the distance of the explanatory variable and the mean of the explanatory
# variable.
# So points close to the horizontal center have lower leverage whereas points
# far from the horizontal center have higher leverage. The y coordinate doesn't
# matter at all here.
# 
# .hat is the leverage of the observation and comes along augment() from
# broom package.
# 
# Observations with the highest leverage below.
mod %>% 
  arrange(desc(.hat)) %>% 
  head()

# Large residual and large leverage determine influence.
# 
# Cook's distance (.cooksd) combines these distances (residual and leverage),
# so it gives an idea of the amount of influence an observation plays in
# shaping the slope of the regression line.
# 
# Not all points of high leverage are influential. That happens because these
# points lie right near the regression line.
# 
# Observations with the highest influence below.
mod %>%
  arrange(desc(.cooksd)) %>%
  head()
