# calculate internal rate of return (IRR) for each stream of cashflows
r1 <- calc_irr(cashflow1)
r2 <- calc_irr(cashflow2)
r3 <- calc_irr(cashflow3)

# calculate net present value (NPV) for each stream of cashflows, assuming r = irr
npv1 <- calc_npv(cashflow1, r1)
npv2 <- calc_npv(cashflow2, r2)
npv3 <- calc_npv(cashflow3, r3)

# examine results
npv1
npv2
npv3
