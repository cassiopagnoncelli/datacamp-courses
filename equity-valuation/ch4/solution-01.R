# Review the first six rows of midcap400
head(midcap400)

# Subset Pharmaceuticals firms
pharma <- subset(midcap400, gics_subindustry == "Pharmaceuticals")
pharma
