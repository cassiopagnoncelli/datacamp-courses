# calculate free cashflow
cashflow <- income_statement
cashflow$operating_cf <- cashflow$___ + cashflow$___
cashflow$capex <- cashflow$machines_purchased * 160000000
cashflow$free_cf <- cashflow$___ - cashflow$___

# summarize free cashflow
sum(cashflow$___)
