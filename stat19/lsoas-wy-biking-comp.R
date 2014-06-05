lsoas <- readOGR("/media/SAMSUNG/geodata/UK2011boundaries/lsoa/", "infuse_lsoa_lyr_2011")
head(lsoas@data)
lsoas.points <- SpatialPointsDataFrame(coords=coordinates(lsoas), data=lsoas@data, proj4string = CRS(proj4string(wy)) )
plot(lsoas.points)
plot(wy)
sel <- lsoas.points[ wy ,]
plot(sel)
head(row.names(sel))

lsoas <- lsoas[ row.names(sel), ]
plot(lsoas)

lsoas.data <- read.csv("/media/SAMSUNG/geodata/ttw2011/lsoa-eng-ttw2011.csv")
names(lsoas.data)
names(lsoas.data)[5:17] <- c("All", "Mfh", "Tram", "Train", "Bus", "Taxi", "Moto", "Car.d", "Car.p", "Cycle", "Walk", "Other", "Unemp")
head(lsoas@data)
names(lsoas.data)[3] <- "geo_code"
lsoas@data <- join(lsoas@data, lsoas.data)
head(lsoas@data)

lsoas$geo_labelw <- NULL
lsoas$geo_label <- NULL
lsoas$geography <- NULL
head(rowSums(lsoas@data[5:ncol(lsoas@data)])) # check total is total - yes
lsoas$AllTravel <- lsoas$All - (lsoas$Unemp + lsoas$Mfh)
lsoas$pCycle <- lsoas$Cycle / lsoas$AllTravel * 100
sum(lsoas$Cycle) / sum(lsoas$AllTravel)
summary(lsoas@data)
object.size(lsoas) / 1000000
writeOGR(lsoas, "geodata/", "lsoas-2011", "ESRI Shapefile")

## mapping cities
library(maps)
map("county")
data(world.cities)
uk = world.cities[world.cities$country.etc == 'UK' & world.cities$pop > 50000,]
head(uk)
coordinates(uk) = c('long','lat')
plot(uk)
wgs84 = '+proj=longlat +datum=WGS84'
uk@proj4string   # slot will be empty
uk@proj4string = CRS(wgs84)
writeOGR(ukc, "geodata/", "ukc", "ESRI Shapefile")


ukc <- world.cities[ world.cities$country.etc == "UK",]
head(ukc)
ukc <- SpatialPointsDataFrame(coords=matrix(cbind(ukc$lon, ukc$lat), ncol = 2), data=ukc[c(1,3)])
plot(ukc)
bbox(ukc)

  