library("psych")

# ETL
gcbs <- readRDS("efa/GCBS_data.rds")

# Model
EFA_model <- fa(gcbs[, 1:15], nfactors=15)

# Diagram
fa.diagram(EFA_model)

# Summary
EFA_model$loadings

summary(EFA_model$scores)

# Plots
plot(density(EFA_model$scores, na.rm = TRUE), main = "Factor Scores")

error.bars(gcbs)

# Further exploratory functions
# pairs.panels(gcbs)
fa.parallel(gcbs, fa="fa")

lowerCor(gcbs)
KMO(gcbs)

# Correlation tests
corr.test(gcbs)
corr.test(gcbs, use = "pairwise.complete.obs")$p
corr.test(gcbs, use = "pairwise.complete.obs")$ci

# Estimate coefficient alpha
alpha(gcbs)

# Calculate split-half reliability
splitHalf(gcbs)
