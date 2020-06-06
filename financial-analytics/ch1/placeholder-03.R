# Inputs
cost <- ___
life <- ___
salvage <- ___

# Compute depreciation
production$Depr_Straight <- (___ - ___)/life
production$Depr_UnitsProd <- (cost - salvage)*(production$Units) / sum(production$___)

# Plot two depreciation schedules
ggplot(production, aes(x = Month)) + 
    geom_line(aes(y = Depr_Straight)) + 
    geom_line(aes(y = Depr_UnitsProd))
