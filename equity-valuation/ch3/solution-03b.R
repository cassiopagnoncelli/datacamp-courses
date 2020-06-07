# Review the first six rows of damodaran
head(damodaran)

# Calculate annual difference between stocks and bonds
diff <- damodaran$sp_500 - damodaran$tbond_10yr

# Calculate ERP
erp <- mean(diff)
erp
