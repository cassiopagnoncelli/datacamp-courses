library("psych")

# ETL: five personality test
bfi

# Calculate the correlation matrix first
bfi_cor <- corr.test(bfi, use = "pairwise.complete.obs")

# Then use that correlation matrix to calculate eigenvalues
eigenvals <- eigen(bfi_cor$r)
eigenvals$values

# Scree plot plots eigenvalues (importance of factors)
# A common approach is to select only eigenvalues > 1, in this case 7 factors
scree(bfi_cor$r, factors = FALSE)
sort(eigenvals$values, decreasing = TRUE)

# Re-run with 7 factors
EFA_model <- fa(bfi, nfactors = 7)
EFA_model

fa.diagram(EFA_model)

EFA_model$loadings
EFA_model$scores
