# Combine equity values per share
eq_val_per_share <- data.frame(
  DCF = eq_val_fcfe_per_share,
  DDM = eq_val_ddm_per_share,
  "P/E" = eq_val_p_e_per_share,
  check.names = FALSE
)

# See the result
eq_val_per_share
