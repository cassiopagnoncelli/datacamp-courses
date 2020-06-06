# Create the cashflow_statement dataframe
cashflow_statement <-
  mutate(assumptions,
         # business model
    sales_per_year = unit_sales_per_day * days_open_per_year,
    sales_revenue = sales_per_year * profit_margin_per_nitro,
    labor_cost = days_open_per_year * 0.5 * labor_cost_per_hour,
    cannibalization_cost = sales_per_year * pct_cannibalization * profit_margin_per_regular,
         # financial metrics
    total_revenue = sales_revenue,
    direct_expense = labor_cost + cannibalization_cost + maintenance_cost,
    gross_profit = total_revenue - direct_expense,
    operating_income = gross_profit - depreciation_cost,
    net_income = operating_income * (1 - tax_rate), 
    cashflow = net_income + depreciation_cost - capex    
  )
