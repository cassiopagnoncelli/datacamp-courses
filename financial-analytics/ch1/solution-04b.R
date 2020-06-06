# calculate free cashflow
cashflow <- income_statement
cashflow$operating_cf <- cashflow$earnings + cashflow$depreciation
cashflow$capex <- cashflow$machines_purchased * 160000000
cashflow$free_cf <- cashflow$operating_cf - cashflow$capex

# summarize free cashflow
sum(cashflow$free_cf)
