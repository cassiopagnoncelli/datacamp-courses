mar_11 = ymd_hms("2017-11-25 14:22:00", tz = 'America/Sao_Paulo')
mar_11

tz(mar_11)

# Changes tz without changing clock time.
mar_11 = force_tz(mar_11, 'Europe/London')
mar_11

# View the same instant in different tz
with_tz(mar_11, 'America/Sao_Paulo')



# EXAMPLE
# Game2: CAN vs NZL in Edmonton
game2 <- mdy_hm("June 11 2015 19:00")

# Game3: CHN vs NZL in Winnipeg
game3 <- mdy_hm("June 15 2015 18:30")

# Set the timezone to "America/Edmonton"
game2_local <- force_tz(game2, tzone = 'America/Edmonton')
game2_local

# Set the timezone to "America/Winnipeg"
game3_local <- force_tz(game3, tzone = 'America/Winnipeg')
game3_local

# How long does the team have to rest?
as.period(game2_local %--% game3_local)

# What time is game2_local in NZ?
with_tz(game2_local, tzone = 'Pacific/Auckland')

# What time is game2_local in Corvallis, Oregon?
with_tz(game2_local, tzone = 'America/Los_Angeles')

# What time is game3_local in NZ?
with_tz(game3_local, tzone = 'Pacific/Auckland')


# EXPORT DATA
# Outputs formatted data based on human-friendly templates.
stamp("March 1, 1999")(ymd('2010-10-19') - days(1:5))



# Create a stamp based on "Saturday, Jan 1, 2000"
date_stamp <- stamp("Saturday, Jan 1, 2000")
date_stamp

date_stamp(today())
stamp('12/31/1999')(today())
stamp(finished)(today())
