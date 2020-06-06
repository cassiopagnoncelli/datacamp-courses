# Inputs
cost <- 100000
life <- 60
salvage <- 10000

# Compute depreciation
production$Depr_Straight <- (cost - salvage)/life
production$Depr_UnitsProd <- (cost - salvage)*(production$Units) / sum(production$Units)

# Plot two depreciation schedules
ggplot(production, aes(x = Month)) + 
    geom_line(aes(y = Depr_Straight)) + 
    geom_line(aes(y = Depr_UnitsProd))
