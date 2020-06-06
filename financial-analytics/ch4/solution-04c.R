# compute min and maxes for each line item
waterfall_items <-
  mutate(gross_profit_summary,
         end = cumsum(value), 
         start = lag(cumsum(value),1,default = 0))

# compute totals row for waterfall metrics
waterfall_summary <- 
  data.frame(metric = "Gross Profit", 
             end = sum(gross_profit_summary$value), 
             start = 0)

# combine line items with summary row
waterfall_data <-
  bind_rows(waterfall_items, waterfall_summary) %>%
  mutate(row_num = row_number())
