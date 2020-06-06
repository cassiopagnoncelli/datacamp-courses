# define pointwise assumptions
price <- 20
print_cost <- 0.5
ship_cost <- 2

# add revenue, expense, and profit variables
cashflow <- assumptions
cashflow$revenue <- cashflow$sales * price
cashflow$direct_expense <- cashflow$sales * (print_cost + ship_cost) 
cashflow$gross_profit <- cashflow$revenue - cashflow$direct_expense

# print cashflow
print(cashflow)
