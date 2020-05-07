today()
now()

# Subtraction, addition, multiplication, or division (change unit).
a = ymd_hm('1988-02-11 22:25')

now() - a

today() - a
difftime(today(), a, units = 'weeks')

# The date of landing and moment of step
date_landing <- mdy("July 20, 1969")
moment_step <- mdy_hms("July 20, 1969, 02:56:15", tz = "UTC")
difftime(today(), date_landing, units = 'days')
difftime(now(), moment_step, units = 'secs')
