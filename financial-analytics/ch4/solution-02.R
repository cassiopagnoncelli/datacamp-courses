# build individual scenarios
optimist <- mutate(assumptions, unit_sales_per_day = unit_sales_per_day * 1.2, pct_cannibalization = 0.1)
pessimist <- mutate(assumptions, unit_sales_per_day = unit_sales_per_day * 0.8, profit_margin_per_nitro = 1)

# combine into one dataset
scenarios <-
  bind_rows(
    mutate(pessimist, scenario = "pessimist"),
    mutate(assumptions, scenario = "realist"),
    mutate(optimist, scenario = "optimist")
  )
