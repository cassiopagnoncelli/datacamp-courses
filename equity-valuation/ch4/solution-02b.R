# Show contents of pharma data object
pharma

# Calculate average multiples
multiples <- colMeans(pharma[2:4], na.rm = TRUE)
multiples
