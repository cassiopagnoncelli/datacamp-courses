# Parsing benchmarks
#
#
# Unit: microseconds
# expr       min        lq       mean    median         uq       max
# ymd_hms 23098.465 25068.122 29052.7934 25597.365 25919.6905 96031.242
# fasttime   668.323   679.456   830.2913   698.616   768.4105  2632.829
# fast_strptime   673.119   686.671   730.1853   706.167   790.6960   828.989
# 

# R flexible parser.
ymd_hms('2020-05-05T16:04:25Z')

# Fast C parser of numeric formats
fast_strptime('2020-05-05T16:04:25Z', format = '%Y-%m-%dT%H:%M:%SZ') %>% str()

# fastPOSIXct() in fasttime not loaded.
