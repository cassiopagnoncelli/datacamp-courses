# examine current cashflow structure
tidy_cashflow

# create long_cashflow with gather
long_cashflow <- gather(tidy_cashflow, key = Metric, value = Value, -Month)

# create untidy_cashflow with spread
untidy_cashflow <- spread(long_cashflow, key = Month, value = Value)

# examine results
untidy_cashflow
