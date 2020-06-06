# Business model
cashflow$revenue <- cashflow$revenue + 2 * cashflow$sales
cashflow$gross_profit <- cashflow$revenue - cashflow$direct_expense

# Income statement
cashflow$depr_sl <- (1000 - 0) / 5
cashflow$operating_profit <- cashflow$gross_profit - cashflow$depr_sl
cashflow$tax <- cashflow$operating_profit * 0.3
cashflow$net_income <- cashflow$operating_profit - cashflow$tax

# Inspect dataset
cashflow
