# normal payback period
payback_period <- calc_payback(cashflows)

# discounted payback period
discounted_cashflows <- calc_pv(cashflows, r = 0.06, n = 0:(length(cashflows)-1) )
payback_period_disc <- calc_payback(discounted_cashflows)

# compare results
payback_period
payback_period_disc
