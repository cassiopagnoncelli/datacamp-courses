library('tensorflow')
library('tfautograph')
library('keras')
library('tfdatasets')

tf$executing_eagerly()

x <- matrix(2, ncol = 1, nrow = 1)
m <- tf$matmul(x, x)

a <- tf$constant(matrix(c(1,2,3,4), ncol = 2))
b <- tf$add(a, 1)
b
as.array(a)
as.array(b)
