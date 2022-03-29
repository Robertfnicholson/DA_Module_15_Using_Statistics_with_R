# Start the HTML interface to on-line help
help.start()

# Generate two pseudo-random normal vectors of x- and y-coordinates.
x <- rnorm(50)
y <- rnorm(x)

# Plot the points in the plane. A graphics window will appear automatically
plot(x, y)

# See which R objects are now in the R workspace.
ls() 

# Remove objects no longer needed. (Clean up)
rm(x, y)

# Make x = (1, 2, . . . , 20).
x <- 1:20

# A 'weight' vector of standard deviations.
w <- 1 + sqrt(x)/2
