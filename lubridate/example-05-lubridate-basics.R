# Lubridate works with dates and times, plays nicely with datetime objects,
# and most importantly is designed for humans not computers, let alone it is
# the standard for tidyverse packages.
# Also it has consistent behaviour with other formats like Date, POSIXct, zoo, xts.

library('lubridate')

# Parsing a wide range of formats. Use ydm or whatever combination of y m d.
ydm('1988-11-02')
ymd('1988 Feb 11')
ymd('1988/2/11')
ymd('1988.2.11')
ymd_hm('1988/2/11 10:25pm') # assumes UTC if no tz is specified

# Formatting characters
# d,m,y: numeric day, month, year
# Y: year without century
# H,M,S: hour (24), minute, second
# a, A: abbreviated and full weekday
# b, B: abbreviated and full month name
# I: hours (12)
# p: AM/PM
# z: timezone, offset from UTC
# O: old time
# 
parse_date_time(c('Feb 11th, 1988', '11th Feb 1988'), order = c('mdy', 'dmy'))
parse_date_time("Monday June 1st 2010 at 4pm", orders = "ABdyIp")
parse_date_time(c("October 7, 2001", "October 13, 2002", "April 13, 2003", 
                  "17 April 2005", "23 April 2017"), orders = c('mdy', 'dmy'))
parse_date_time(c("11 December 1282", "May 1372", "1253"), orders = c('dOmY', 'OmY', 'Y'))

# Extract components.
ydm('1988-11-02') %>% year()
ydm('1988-11-02') %>% month()
ydm('1988-11-02') %>% day()
ydm('1988-11-02') %>% yday()
ydm('1988-11-02') %>% month(label = TRUE)

# Furthermore in examples:
# - handling timezones
# - fast parsing of standard formats
# - outputting datetimes