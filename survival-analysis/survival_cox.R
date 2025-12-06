# Compute Cox model
cxmod <- coxph(Surv(time, cens) ~ horTh + tsize, data = GBSG2)
coef(cxmod)

# Build a grid of imaginary patients (covariates combinations)
newdat <- expand.grid(
  horTh = levels(GBSG2$horTh),
  tsize = quantile(GBSG2$tsize, probs = c(0.25, 0.5, 0.75))
)
rownames(newdat) <- letters[1:6]
newdat

# Compute survival curves
cxsf <- survfit(cxmod, data = GBSG2, newdata = newdat, conf.type = "none")
cxsf

# Summary
surv_cxmod0 <- surv_summary(cxsf)
head(surv_cxmod0)

# Remember:
# - right-censor means the patient survived beyond that point in time (not yet failed)
# - left-censor means the patient had the event before that point in time (already failed)
# - interval-censor means the patient had the event between two time points
surv_cxmod <- surv_summary(cxsf) |>
  mutate(
    horTh = rep(newdat$horTh, each = length(unique(surv_cxmod0$time))),
    tsize = rep(newdat$tsize, each = length(unique(surv_cxmod0$time))),
    stratum = rep(rownames(newdat), each = length(unique(surv_cxmod0$time)))
  )
head(surv_cxmod)

# Plot
ggsurvplot_df(
  surv_cxmod,
  linetype = "horTh",
  color = "tsize",
  legend.title = NULL,
  censor = FALSE
)
