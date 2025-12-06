library("survival")
library("TH.data")
library("ggplot2")
library("survminer")
library("reshape2")

survreg <- survreg(Surv(time, cens) ~ horTh, data = GBSG2, dist = "weibull")
survreg <- survreg(Surv(time, cens) ~ horTh, data = GBSG2, dist = "exponential")
survreg <- survreg(Surv(time, cens) ~ horTh, data = GBSG2, dist = "lognormal")

surv <- seq(.99, .01, by = -.01)
t <- predict(survreg, type = "quantile", p = 1 - surv)
surv_wb <- data.frame(time = t, surv = surv, upper = NA, lower = NA, std.err = NA)

survminer::ggsurvplot_df(
  fit = surv_wb,
  surv.geom = geom_line,
  censor = FALSE,
  conf.int = FALSE
)


# Weibull model
wbmod <- survreg(Surv(time, cens) ~ horTh, data = GBSG2)
lnmod <- survreg(Surv(time, cens) ~ horTh, data = GBSG2, dist = "lognormal")

newdat <- data.frame(horTh = levels(GBSG2$horTh))

surv <- seq(.99, .01, by = -.01)

wbt <- predict(wbmod, type = "quantile", p = 1 - surv, newdata = newdat)
lnt <- predict(lnmod, type = "quantile", p = 1 - surv, newdata = newdat)

surv_wb <- data.frame(time = as.vector(wbt),
                      surv = rep(surv, times = nrow(newdat)),
                      horTh = rep(newdat$horTh, each = length(surv)))

surv_ln <- data.frame(time = as.vector(lnt),
                      surv = rep(surv, times = nrow(newdat)),
                      horTh = rep(newdat$horTh, each = length(surv)))
surv_wb$model <- "Weibull"
surv_ln$model <- "Log-normal"

surv_all <- rbind(surv_wb, surv_ln)

ggplot(surv_all, aes(x = time, y = surv, color = horTh, linetype = model)) +
  geom_line() +
  scale_y_continuous(name = "Survival Probability", limits = c(0, 1)) +
  scale_x_continuous(name = "Time") +
  theme_minimal() +
  ggtitle("Survival Curves by horTh for Weibull and Log-normal Models")
