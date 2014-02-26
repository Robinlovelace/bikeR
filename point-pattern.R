# point-pattern analysis

## This vignette is about using point-pattern analysis to identify hotspots and compare different sets of points

## Start off getting using to spatstat
library(spatstat)
library(rgdal)
library(maptools)
# see notes from here also http://www.csiro.au/resources/pf16h

set.seed(120109)
r <- seq(0, sqrt(2)/6, by = 0.005)
acB1 <- elide(acB, scale = TRUE)
# acB1 <- acB1[1:50,] # for tiny subset
acB1 <- SpatialPoints(acB) # Calculate the G function for the points
envacB <- envelope(as(acB1, "ppp"), fun = Gest)
#   , r = r, nrank = 2, nsim = 5) 
plot(envacB, xlab = "Euclidean distance to nearest neighbour (m)", main="")
summary(envacB)

acBr <- elide(rsample, scale = T)
envacBr <- envelope(as(acBr, "ppp"), fun = Gest)
plot(envacBr)

# Now compare with the road network overall:
roads <- readOGR("exclude/", "WY-roads")
names(roads)
# subset roads
# roadss <- roads[sample(1:nrow(roads), size=10000), ]
rsample <- spsample(roads, 500000, type="random")

# generate 100 sets of points randomly allocated to the road network
for(i in 1:100){
rsam <- rsample[sample(nrow(coordinates(rsample)), size=nrow(acB)),]
fname <- paste0(i,".csv")
fname <- paste0("exclude/rand-road-points/",fname)
write.csv(coordinates(rsam), file = fname)
}

# save bikecrash data
nrow(acB) / nrow(acWY)
write.csv(coordinates(acB), file = "exclude/rand-road-points/bike-accident-points.csv")

summary(rsample)
nrow(rsample)
plot(rsam)
plot(acB, add=T, col="red")





