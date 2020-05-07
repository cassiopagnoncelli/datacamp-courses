library('ggplot2')
library('readr')
library('dplyr')

# Import "cran-logs_2015-04-17.csv" with read_csv()
logs <- readr::read_csv('/Users/cassio/R/datacamp-courses/lubridate/cran-logs_2015-04-17.csv')

# Print logs
logs

# Store the release time as a POSIXct object
release_time <- as.POSIXct("2015-04-16 07:13:33", tz = "UTC")

# When is the first download of 3.2.0?
logs %>% filter(datetime >= release_time, r_version == "3.2.0")

# Examine histograms of downloads by version
ggplot(logs, aes(x = datetime)) +
  geom_histogram(bins = 35) +
  geom_vline(aes(xintercept = as.numeric(release_time)))+
  facet_wrap(~ r_version, ncol = 1)
