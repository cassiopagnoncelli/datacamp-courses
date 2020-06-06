# normal payback period
payback_period <- calc_payback(___)

# discounted payback period
discounted_cashflows <- ___(cashflows, r = 0.06, n = 0:(length(cashflows)-1) )
payback_period_disc <- ___(discounted_cashflows)

# compare results
payback_period
payback_period_disc
