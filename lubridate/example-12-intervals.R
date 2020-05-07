dt1 = ymd('1988-02-11')
dt2 = today()

# Interval is a time window between two dates.
interval(dt1, dt2)
cassio = dt1 %--% dt2

# Interval start .. end
int_start(cassio)
int_end(cassio)
int_length(cassio)

# Convert to period or duration.
as.period(cassio)
as.duration(cassio)

# Test date within interval
turn_of_millenia = ymd('2000-01-01')
turn_of_millenia %within% cassio

legiao = ymd('1980-01-01') %--% ymd('1996-12-31')
int_overlaps(legiao, cassio)
