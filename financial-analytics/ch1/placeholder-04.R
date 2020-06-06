# Calculate income statement
income_statement <- assumptions
income_statement$revenue <- income_statement$unit_sales * price_per_unit
income_statement$expenses <- income_statement$___ * (cogs_per_unit + labor_per_unit)
income_statement$earnings <- income_statement$revenue - income_statement$___ - income_statement$depreciation

# Summarize cumulative earnings
sum(income_statement$___)
sum(income_statement$earnings) / sum(income_statement$___)
