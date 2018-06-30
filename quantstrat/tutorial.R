Sys.setenv(TZ = "UTC")

library('quantstrat')
library('quantmod')

# Get LQD symbol from Yahoo, set account currency to USD and
# tell quantstrat about the new instrument LQD.
currency("USD")

getSymbols('LQD', 
           src = 'yahoo', 
           from = "2003-01-01", 
           to = "2015-12-31", 
           adjust = TRUE)

stock('LQD', 'USD')

# Trading settings: initial equity and trade size.
initdate = "1999-01-01"
tradesize = 1e5
initeq = 1e5

# Set up account, portfolio, and strategy names.
# Also, clear homonimous existing strategies.
strategy.st = portfolio.st = account.st = "firststrat"

rm.strat(strategy.st)

# Initialize portfolio, account, orders, and strategy objects.
initPortf(portfolio.st,
          symbols = "LQD",
          initDate = initdate,
          currency = 'USD')

initAcct(account.st, 
         portfolios = portfolio.st,
         initDate = initdate,
         currency = 'USD',
         initEq = initeq)

initOrders(portfolio.st, initDate = initdate)

strategy(strategy.st, store = TRUE)

# Chart and indicators.
# Indicators work pretty much like apply().
plot(LQD, col='black')

add.indicator(strategy = strategy.st,
              name = "SMA",
              arguments = list(x = quote(Cl(mktdata)), n = 50),
              label = "SMA50")

add.indicator(strategy = strategy.st,
              name = "SMA",
              arguments = list(x = quote(Cl(mktdata)), n = 200),
              label = "SMA200")

mkt = applyIndicators(strategy = strategy.st, mktdata = OHLC(LQD))

# Subsetting.
HLC(LQD["2012-01-01/2012-01-07"])

# Creating new indicator.
DVO <- function(HLC, navg = 2, percentlookback = 126) {
  ratio <- Cl(HLC)/((Hi(HLC) + Lo(HLC))/2)
  avgratio <- SMA(ratio, n = navg)
  out <- runPercentRank(
    avgratio, 
    n = percentlookback, 
    exact.multiplier = 1
  ) * 100
  colnames(out) <- "DVO"
  return(out)
}

add.indicator(strategy = strategy.st, name = "DVO", 
              arguments = list(
                HLC = quote(HLC(mktdata)), 
                navg = 2, 
                percentlookback = 126
              ),
              label = "DVO_2_126")

mkt <- applyIndicators(strategy = strategy.st, mktdata = OHLC(LQD))
mkt["2013-09-01/2013-09-05"]

# Signals. There are a few signal types:
# - sigComparison,
# - sigCrossover,
# - sigThreshold,
# - sigFormula.
# 
# Firstly, we have MA crossover entry and exit examples.
# Later, we have a DVO strategy of the indicator above.
# Lastly we combine MA cross and DVO.
# 
add.signal(strategy.st, 
           name = "sigComparison",
           arguments = list(
             columns = c("SMA50", "SMA200"),
             relationship = "gt"
           ),
           label = "longfilter")

add.signal(strategy.st, 
           name = "sigCrossover",
           arguments = list(
             columns = c("SMA50", "SMA200"),
             relationship = "lte"
           ),
           label = "filterexit")

add.signal(strategy.st, 
           name = "sigThreshold", 
           arguments = list(
             column = "DVO_2_126",
             threshold = 20, 
             relationship = "lt", 
             cross = FALSE
           ), 
           label = "longthreshold")

add.signal(strategy.st, name = "sigThreshold",
           arguments = list(
             column = "DVO_2_126",
             threshold = 80,
             relationship = "gt",
             cross = TRUE
           ),
           label = "thresholdexit")

add.signal(strategy.st, 
           name = "sigFormula",
           arguments = list(
             formula = "longthreshold & longfilter",
             cross = TRUE
           ),
           label = "longentry")

mkt = applyIndicators(strategy.st, mktdata = OHLC(LQD))

# Apply those signals.
signals = applySignals(strategy = strategy.st, mktdata = mkt)

# Rules are used to send orders, so converting money to asset
# and vice versa.
# 
# Notes.
# 
#   'replace' argument specifies whether or not to ignore all other
#     signals on the same date. Well crafted trading systems have it
#     set to FALSE.
# 
#   'prefer' argument is *when* to enter into a position, by default
#     you're buying at close of next day/bar so there's a full one
#     day delay between observing a signal and acting upon it. When
#     set to "Open" the waiting time is just the time distance between
#     last bar's close and current bar's open.
# 
#   'orderqty' can be customized by osFUN, tradeSize, and maxSize.
# 
add.rule(
  strategy.st, 
  name = "ruleSignal", 
  arguments = list(
    sigcol = "filterexit",
    sigval = TRUE,
    orderqty = "all", 
    ordertype = "market",
    orderside = "long", 
    replace = FALSE,
    prefer = "Open"
  ),
  type = "exit")

add.rule(
  strategy.st,
  name = "ruleSignal", 
  arguments = list(
    sigcol = "filterexit", 
    sigval = TRUE, 
    orderqty = "all", 
    ordertype = "market",
    orderside = "long", 
    replace = FALSE, 
    prefer = "Open"
  ), 
  type = "exit") # Type can be enter or exit.

add.rule(
  strategy.st,
  name = "ruleSignal",
  arguments = list(
    sigcol = "longentry", 
    sigval = T, 
    orderqty = 1,
    ordertype = "market",
    orderside = "long",
    replace = FALSE, 
    prefer = "Open"
  ),
  type = "enter")

# Run strategy. 
# 
applyStrategy(strategy = strategy.st, portfolios = portfolio.st)

updatePortf(portfolio.st)
daterange = time(getPortfolio(portfolio.st)$summary)[-1]

updateAcct(account.st, daterange)
updateEndEq(account.st)

# Analyze strategy.
# 
tStats = tradeStats(Portfolios = portfolio.st)
report = data.frame(t(tStats[,-c(1,2)]))
report

# Chart.
chart.Posn(Portfolio = portfolio.st, Symbol = "LQD")

sma50 = SMA(x = Cl(LQD), n = 50)
sma200 = SMA(x = Cl(LQD), n = 200)
dvo = DVO(HLC = HLC(LQD), navg = 2, percentlookback = 126)

add_TA(sma50, on = 1, col = "blue")
add_TA(sma200, on = 1, col = "red")
add_TA(dvo)

# Analytics.
portPL = .blotter$portfolio.firststrat$summary$Net.Trading.PL
head(portPL)

SharpeRatio.annualized(portPL, geometric = TRUE) # search for >1.

instrets = PortfReturns(portfolio.st)
head(instrets)
