# compute min and maxes for each line item
waterfall_items <-
  mutate(gross_profit_summary,
         end = ___(value), 
         start = ___(cumsum(value),1,default = 0))

# compute totals row for waterfall metrics
waterfall_summary <- 
  data.frame(metric = "Gross Profit", 
             end = sum(___), 
             start = 0)

# combine line items with summary row
waterfall_data <-
  ___(waterfall_items, waterfall_summary) %>%
  mutate(row_num = row_number())
