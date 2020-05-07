# Updating a date.
x = ymd('2013-02-23')
year(x) = 2017
day(x) = 24
x

# Extract parts
day(x)
month(x)
year(x)

yday(x)
wday(x)

leap_year(x)
am(x)
pm(x)
dst(x)
quarter(x)
semester(x)
days_in_month(x)

# Labeled.
wday(x)
wday(x, label = T)
wday(x, label = T, abbr = F)

month(x)
month(x, label = T)
month(x, label = T, abbr = F)

# Floor, round, ceiling.
y = ymd_hms('2018-02-11 11:02:10')
floor_date(y, unit = 'month')
round_date(y, unit = 'hour')
ceiling_date(y, unit = 'month')
ceiling_date(y, unit = '3 years')

r_3_4_1 <- ymd_hms("2016-05-03 07:13:28 UTC")
round_date(r_3_4_1, unit = 'day')
round_date(r_3_4_1, unit = '5 mins')
ceiling_date(r_3_4_1, unit = 'week')
r_3_4_1 - floor_date(r_3_4_1, unit = 'day')
