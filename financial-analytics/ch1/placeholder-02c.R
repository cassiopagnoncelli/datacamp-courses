# Define function: calc_business_model
___ <- function(___, ___, ___, ___){
    cashflow <- assumptions
    cashflow$revenue <- cashflow$sales * price
    cashflow$direct_expense <- cashflow$sales * (print_cost + ship_cost) 
    cashflow$gross_profit <- cashflow$revenue - cashflow$direct_expense
    ___
}

# Call calc_business_model function for different sales prices
___(book_assumptions, 20, 0.5, 2)$gross_profit
___(book_assumptions, 25, 0.5, 2)$gross_profit
