# POSIXct objects stores data information to millisecond precision with timezone
# information. Once set, it behaves nicely to perform datetime arithmetics, plot
# and more.

# POSIXct objects stores seconds since epoch (1970), this one goes in data frames
# POSIXlt is a list with named components.

# as.POSIXct converts strings into POSIXct objects.
x = as.POSIXct('1988-02-11 22:25:00')

# If no timezone is specified, it is assumed to be local timezone.
# In this spirit, "2013-01-01T18:00:00" means 6pm local time
# whereas "2013-01-01T18:00:00Z" means 6pm UTC.

# To specify local time, use tz argument or full datetime format.
as.POSIXct('1988-02-11 22:25:00-02:00')
as.POSIXct('1988-02-11 22:25:00', tz = 'Brazil')

as.POSIXct('2010-10-01 12:12:00')
as.POSIXct('2010-10-01 12:12:00', tz = 'America/Los_Angeles')

as.numeric(as.POSIXct('2010-10-01 12:12:00'))
