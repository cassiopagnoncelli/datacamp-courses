# A timespan is a human concept of time as in
# 
#   datetime + timespan
# 
# just like
# 
#   today + 1 hour.
# 
# They can be in two flavours: period and duration.
# 
# Duration is a stopwatch concept of a timespan, a fixed number of seconds.
# For example, today() + 365 * 86400.
# But that won't necessarily hit the same day/hour/minute next year.
# 
# Period, however, is of variable length and does the math beind the courtains.
# For example, today() + 1 year does equal day/hour/minute next year.
# 
# In short, *periods* are used as human units, durations are used as seconds elapsed.

# CREATING TIMESPANS.

# Period.
days()
days(2)
years(5)

# Duration.
ddays(90)

# Arithmetics.
# Functions: [d]seconds|...|[d]years() except for dmonths which makes no sense.
days() + ddays()

days() + days()
days(15) + months(1)
2 * days(2)

today() - years(5)   # 5 years is longer than 
today() - dyears(5)  # 365 * 5 days.

now() - years(5)
now() - dyears(5)

# Schedule.
today_8am <- today() + hours(8)
every_two_weeks <- 1:26 * weeks(2)
today_8am + every_two_weeks

# Operators.
# A sequence of 1 to 12 periods of 1 month
jan_31 <- ymd('2020-01-31')
month_seq <- 1:12 * months(1)
month_seq + jan_31
jan_31 %m+% month_seq
jan_31 %m-% month_seq
