library('ggplot2')

x = sapply(c('2020-01-03', '2020-02-11', '2020-03-15'), as.Date)

plot(x)

ggplot() + geom_point(aes(x = x, y = 1:3))
