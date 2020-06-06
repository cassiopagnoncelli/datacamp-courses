# calculate scenario NPVs
scenario_analysis <-
scenarios %>%
    ___(-scenario) %>%
    mutate(cashflow = ___(data, calc_model)) %>%
    mutate(npv = map_dbl(cashflow, calc_npv_from_cashflow, r = ___))

# inspect results
select(scenario_analysis, scenario, npv)
