library('readr')
library('dplyr')
library('corrplot')
library('ggplot2')
library('boot')
library('survival')
library('tibble')
library('rms')

clv.raw = read.csv("data/clvData1.csv", header=T)
head(clv.raw)

clvUnscaled = clv.raw[,-10]
clvUnscaled %>% cor() %>% corrplot()

lapply(clvUnscaled, var) # Unscaled data.

clv = clvUnscaled %>% scale() %>% as.data.frame() # Scaled data.
lapply(clv, var)

# PCA projects N linear combinations of the N variables.
pca = prcomp(clv)
str(pca, give.attr = FALSE)

pca$sdev %>% round(2) # Stddev of the components.
pca$sdev %>% round(2) %>% plot()

pca$sdev^2 %>% round(2) # Variances (eigenvalues).
pca$sdev^2 %>% round(2) %>% plot()

pca$sdev^2 / length(pca$sdev) %>% round(2)
(pca$sdev^2 / length(pca$sdev)) %>% plot() # Proportion of explained variance.

# Loadings. Correlations between variables and componentss.
# This helps understand how variables and components are related.
# It is based on this analysis we can label principal components based
# on interpretation.
pca$rotation[, 1:6] %>% round(2)

sum(clv[1,] * pca$rotation[,1]) # 1st component for 1st observation.

# How many components? 
# - Criteria 1: as many as 70% of the cumulative prop is explained.
# - Criteria 2: (Kaiser-Guttman) only those with eigenvalues > 1.
# - Criteria 3: Screeplot (points above the elbow).
summary(pca)

pca$sdev^2 %>% round(2)

screeplot(pca, type = 'lines')
box()
abline(h = 1, lty = 2)

# Comparing variables and components.
biplot(pca, choices = 1:2, cex = 0.7)

# We could run a regression analysis where the regressors are principal
# components. As they better explain variance, model would be better.
# For instance, a small drop in R^2 say from 80% to 75% while dramatically 
# reducing the number of variables from 21 to 6.

# Other things we could do:
# - Cluster analysis, for customer segmentation
# - Factor analysis, for customer satisfaction survey
