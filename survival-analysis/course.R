library("TeachingDemos")

library(TH.data)
library(Ecdat)

library("survival")  # Library for all kinds of analyses
library("survminer") # For pretty visualizations

# Breast cancer: Surv-Object (time, event)
data("GBSG2")

summary(GBSG2)

sobj <- Surv(GBSG2$time, GBSG2$cens)

sobj[1:10]
summary(sobj)
str(sobj)

# Unemployment data
data(UnempDur, package = "Ecdat")

cens_employ_ft <- table(UnempDur$censor1)
cens_employ_ft
barplot(cens_employ_ft)

sobj <- Surv(UnempDur$spell, UnempDur$censor1)
sobj[1:10]

# Cox fit.
st <- c(0.9, 1.8, 2.9, 4.0, 5.1, 7.2,  2.1, 3.9, 5.8, 8.0, 10.1, 12.3)
state <- rep(1, 12)
grp <- factor(rep(c("A", "B"), c(6, 6)), levels = c("B", "A")) # set B as baseline
res.cox <- coxph(Surv(st, state) ~ grp)
summary(res.cox)
