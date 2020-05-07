library(lubridate)
library(readr)
library(dplyr)
library(ggplot2)

akl_hourly_raw <- read_csv('akl_weather_hourly_2016.csv')
akl_hourly_raw

# make_datetime is also available.
akl_hourly  <- akl_hourly_raw  %>% 
  mutate(date = make_date(year = year, month = month, day = mday)) 
