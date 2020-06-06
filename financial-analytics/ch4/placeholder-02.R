# build individual scenarios
optimist <- mutate(assumptions, unit_sales_per_day = unit_sales_per_day * 1.2, pct_cannibalization = 0.1)
pessimist <- mutate(assumptions, unit_sales_per_day = unit_sales_per_day * ___, profit_margin_per_nitro = ___)

# combine into one dataset
scenarios <-
  ___(
    mutate(pessimist, scenario = "pessimist"),
    mutate(assumptions, scenario = ___),
    mutate(optimist, scenario = "optimist")
  )
