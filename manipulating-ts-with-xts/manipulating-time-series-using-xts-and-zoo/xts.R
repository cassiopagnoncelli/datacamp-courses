# xts objects are matrices in nature, with dates as labels.
# Accepted date formats are Date, POSIXct, POSIXt, timeDate, and others.
# Objects are always aligned ascending in time and respond to zoo methods as well.
library('xts')

# Simple example.
dates <- as.Date("2016-01-01") + 0:4
ts_a <- xts(x = 1:5, order.by = dates)
ts_b <- xts(x = 1:5, order.by = as.POSIXct(dates))
ts_a[index(ts_b)]
ts_b[index(ts_a)]

# Inside of a xts.
str(ts_a)
coredata(ts_a)
coredata(ts_b)
index(ts_a)
index(ts_b)
class(index(ts_a))
class(index(ts_b))

# Importing, exporting, and converting time series.
# Use read.zoo and write.zoo
data('sunspots')
class(sunspots)
head(sunspots)

sunspots_xts = as.xts(sunspots)
class(sunspots_xts)
head(sunspots_xts)

# Import example.
# dat = read.csv(tmp_file)
# dat_xts = xts(dat, order.by = as.Date(rownames(dat), "%m/%d/%Y"))
# dat_zoo = read.zoo(tmp_file, index.column = 0, sep = ",", format = "%m/%d/%Y")
# dat_xts2 = as.xts(dat_zoo)

# Export example.
# tmp = tempfile()
# write.zoo(sunspots_xts, sep = ",", file = tmp)
# read.zoo(tmp, sep = ",", FUN = as.yearmon)

# Key behaviour.
# 1. All subsets preserve matrix, so returns 1-column matrix and not a vector.
# 2. Order is always preserved, so returns are always ordered despite query order.
# 3. Binary search and memcpy are faster than base R.
# 4. index and xts attributes are preserved.

# Subsetting, takes ISO8601 format with and without hyphens to milisecond precision.
# It can also use one, for exact match, or two date objects to mean a range of dates.
sunspots_xts["1900/1901-04"]
sunspots_xts["1900/190104", which.i = T]
sunspots_xts["T08:00/T09:00"] # 8am to 9am.
sunspots_xts["1982/"]

library('PerformanceAnalytics')
data(edhec)

last(edhec, "3 months")
last(edhec, "4 days")

# Key features.
# 1. Sometimes it is needed to drop the xts class, so use argument drop=T, or
#    use coredata() or as.numeric()
# 2. There is a special handling required for _union_ of dates.

# Math operations.
x = xts(rep(1, 3), order.by = as.Date("2016-08-09") + 0:2)
y = xts(rep(2, 3), order.by = c(as.Date("2016-08-09"), 
                                as.Date("2016-08-10"), 
                                as.Date("2016-08-12")))

x + y  # Intersection.

x_union = merge(x, index(y), fill = 0)
y_union = merge(y, index(x), fill = 0)
x_union + y_union   # Union.

x + merge(y, index(x), fill = na.locf)   # Fill with the last observation.

# Merge. Combines series by column, as in DB style on index (ie. time) with
# inner, outer, left, and right joins.
merge(x, y)
merge(x, y, join = "inner")
merge(x, y, join = "right", fill = na.locf)

merge(x, c(2,3,4))
merge(x, 3)
merge(x, as.Date(c("2016-08-14")))

rbind(x, y)

# More usable functions.
# na.locf: last observation carried forward
# na.fill: replace NAs
# na.trim, na.omit: remove NAs
# na.approx: interpolate NAs linearly with time
# lag, shift: used to align time series for comparisons

# Endpoints. Get the last observation for each period of time, k is the period offset,
# so below gives
endpoints(sunspots_xts, on = "years", k = 2)

ep <- endpoints(temps, on = "weeks")

# OHLC and period conversibility.
# period.apply: this function combines split and lapply as below.

# temps_weekly <- split(temps, f = "weeks")
# lapply(X = temps_weekly, FUN = mean)

# period.apply(temps[, "Temp.Mean"], INDEX = ep, FUN = mean) # Weekly mean

to.period(edhec[, "Funds of Funds"], period="years", name='newcol', OHLC=T)

edhec[endpoints(edhec, 'years'), 1]

# Rolling windows.
# For discrete case use split() + lapply() and for continuous case use rollapply().
# split(): break up by period.
# lapply(): cumulative functions like cumsum(), cummin(), cummax(), cumprod()

edhec.yrs = split(edhec[,1], f = "years")
edhec.yrs = lapply(edhec.yrs, cumsum)
edhec.yrs
edhec.ytd = do.call(rbind, edhec.yrs)
edhec.ytd
cbind(edhec.ytd, edhec[,1])["2007-10/2008-03"]

rollapply(edhec["200701/08", 1], 3, mean)  # MA(3).

# Timezones.
# Note: always have timezone set in environment to avoid problems.
help(OlsonNames)

Sys.setenv(TZ = "America/Sao_Paulo")
Sys.setenv(TZ = "UTC")

tclass(edhec)
indexClass(edhec)

tzone(edhec)
indexTZ(edhec)

indexFormat(edhec) <- "%b %d, %Y"
head(edhec)

# Periodicity.
periodicity(edhec)
periodicity(to.yearly(edhec))

# Counting periods.
nseconds(edhec)
nminutes(edhec)
nhours(edhec)
ndays(edhec)
nweeks(edhec)
nmonths(edhec)
nquarters(edhec)
nyears(edhec)

# POSIXlt internal structure.
.index(edhec)
.indexmday(edhec)
.indexwday(edhec)
.indexyday(edhec)
.indexmon(edhec)
.indexyear(edhec) + 1900

# Round timestamps to another period.
align.time(edhec, n = 500000) # n is in seconds.

# Remove observations of duplicate timestamps
make.index.unique(edhec, eps=1e-6, drop=T, fromLast=F)
