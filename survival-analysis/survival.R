library("survival")
library("TH.data")
library("ggplot2")
library("survminer")
library("reshape2")

# Kaplan-Meier
km <- survfit(Surv(time, cens) ~ 1, data = GBSG2)

ggsurvplot(km)

# Weibull
x <- dweibull(seq(0, 3, by = 0.01), shape = 2)
plot(x, type='l')

wb <- survreg(Surv(time, cens) ~ 1, data = GBSG2, dist = "weibull")

# 90% of patients survive beyond this time: 384 days.
# p = 1 - 0.9 because the distribution function is 1 - survival function
predict(wb, type = "quantile", p = 1 - 0.9, se.fit = FALSE, newdata = data.frame(1)) # 90% survive beyond 384 days
predict(wb, type = "quantile", p = .5, newdata = data.frame(1)) # Median survival

# Survival curve
surv <- seq(.99, .01, by = -.01)
t <- predict(wb, type = "quantile", p = 1 - surv, se.fit = FALSE, newdata = data.frame(1))
plot(t, surv, type = 'l', xlab = "Time (days)", ylab = "Survival Probability", main = "Weibull Survival Curve")

wb <- survreg(Surv(time, cens) ~ 1, data = GBSG2, dist = "weibull")
surv <- seq(.99, .01, by = -.01)
t <- predict(wb, type = "quantile", p = 1 - surv, se.fit = FALSE, newdata = data.frame(1))
surv_wb <- data.frame(time = t, surv = surv, upper = NA, lower = NA, std.err = NA)
survminer::ggsurvplot_df(
  fit = surv_wb,
  surv.geom = geom_line,
  censor = FALSE,
  conf.int = FALSE
)
ggplot(surv_wb, aes(time, surv)) +
  geom_line(linewidth = 1) +
  labs(x = "Time", y = "Survival") +
  theme_minimal()

# Elabore use case
wb <- survreg(Surv(time, cens) ~ 1, data = GBSG2)
surv <- seq(.99, .01, by = -.01)
t <- predict(wb, type = "quantile", p = 1 - surv, newdata = data.frame(1))
surv_wb <- data.frame(time = t, surv = surv)

head(surv_wb)

# Fit for tumor size and use of hormone therapy
wbmod <- survreg(Surv(time, cens) ~ tsize + horTh, data = GBSG2, dist = "weibull")
coef(wbmod)

# Retrieve survival curve from model
wbmod <- survreg(Surv(time, cens) ~ horTh, data = GBSG2)
surv <- seq(.99, .01, by = -.01)
t_yes <- predict(wbmod, type = "quantile", p = 1 - surv, newdata = data.frame(horTh = "yes"))
str(t_yes)

# Visualising
wbmod <- survreg(Surv(time, cens) ~ horTh + tsize, data = GBSG2)
newdat <- expand.grid(
  tsize = quantile(GBSG2$tsize, probs = c(0.25, 0.5, 0.75)),
  horTh = levels(GBSG2$horTh)
)
surv <- seq(.99, .01, by = -.01)
t <- predict(wbmod, type = "quantile", p = 1 - surv, newdata = newdat)
dim(t)
t[, 1:7]

surv_wbmod_wide <- cbind(newdat, t)

surv_wbmod <- melt(surv_wbmod_wide, id.vars = c("tsize", "horTh"), variable.name = "surv_id", value.name = "time")
surv_wbmod$surv <- surv[as.numeric(surv_wbmod$surv_id)]
surv_wbmod[, c("upper", "lower", "std.err", "strata")] <- NULL
surv_wbmod

ggsurvplot_df(
  surv_wbmod,
  surv.geom  = geom_line,
  conf.int   = FALSE,
  linetype   = "horTh",
  color      = "tsize",
  legend.title = NULL
)

