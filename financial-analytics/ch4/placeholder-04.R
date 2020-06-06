# examine current cashflow strucutre
cashflow

# load tidyr
library(___)

# create long_cashflow with gather
long_cashflow <- ___(___, key = Month, value = Value, -Metric)

# create tidy_cashflow with spread
tidy_cashflow <- ___(___, key = Metric, value = Value)

# examine results
tidy_cashflow
