# calculate scenario NPVs
scenario_analysis <-
scenarios %>%
    nest(-scenario) %>%
    mutate(cashflow = map(data, calc_model)) %>%
    mutate(npv = map_dbl(cashflow, calc_npv_from_cashflow, r = 0.2))

# inspect results
select(scenario_analysis, scenario, npv)
