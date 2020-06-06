# define sensitivity factor function
factor_data <- function(data, metric, factor){
  data[[metric]] <- data[[metric]] * ___
  data
}

# create sensitivity analysis
sensitivity <-
  ___(
    factor = seq(0.5,1.5,0.1), 
    metric = c("profit_margin_per_nitro", "labor_cost_per_hour", "pct_cannibalization", "unit_sales_per_day")) %>%
  mutate(scenario = ___(metric, factor, ~factor_data(assumptions, .x, .y))) %>%
  mutate(cashflow = map(scenario, calc_model)) %>% 
  mutate(npv = map_dbl(cashflow, calc_npv_from_cashflow, r = 0.2))
