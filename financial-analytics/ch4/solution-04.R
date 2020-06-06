# examine current cashflow strucutre
cashflow

# load tidyr
library(tidyr)

# create long_cashflow with gather
long_cashflow <- gather(cashflow, key = Month, value = Value, -Metric)

# create tidy_cashflow with spread
tidy_cashflow <- spread(long_cashflow, key = Metric, value = Value)

# examine results
tidy_cashflow
