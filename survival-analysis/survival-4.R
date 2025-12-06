library("survival")
library("TH.data")
library("survminer")

# Kaplan-Meier estimate
km <- survfit(Surv(time, cens) ~ 1, data = GBSG2)

# Plot of the Kaplan-Meier estimate
ggsurvplot(km)

# Add the risk table to plot
ggsurvplot(km, risk.table = TRUE)

# Add a line showing the median survival time
ggsurvplot(km, risk.table = TRUE, surv.median.line = "hv")

