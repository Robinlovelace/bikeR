# where - ward level
library(rgdal)
wards <- readOGR("/media/SAMSUNG/geodata/UK2011boundaries/england-census-wards/", "england_cwa_2011_gen_clipped")
# plot(wards)
points(acB, col = "red")
# plot(wards)

b <- SpatialPoints(coordinates(wards)) 
proj4string(b) <- proj4string(wards)
sel <- row.names(b[wards,])
wards <- wards[sel,]

## add cyclist data to wards
wards.data <- read.csv("/media/SAMSUNG/geodata/ttw2011/2011-wards-mode.csv")
head(wards.data)
names(wards.data) <- gsub("Method.of.Travel.to.Work..", "", names(wards.data))
names(wards.data) <- gsub("..measures..Value", "", names(wards.data))
head(wards@data)
wards.data <- rename(wards.data, c("geography.code" = "CODE"))
wards@data <- join(wards@data, wards.data)

# subsetting for serious and deathly crashes
wserious <- acB$Accident_Sf == "Serious" 
summary(wserious)
wdeath <- acB$Accident_Sf == "Fatal" 
wminor <- acB$Accident_Sf == "Slight" 
summary(wminor)

# serious crashes
latmp <- aggregate(acB[wserious,"Accident_Sf"], by=wards, FUN=length)
head(latmp@data)
nrow(latmp)
wards$n.serious <- latmp$Accident_Sf
plot(wards$Bicycle, wards$n.serious)

# n. fatalities
latmp <- aggregate(acB[wdeath,"Accident_Sf"], by=wards, FUN=length)
wards$n.death <- latmp$Accident_Sf
plot(wards$Bicycle, wards$n.death)
wards@data[c("NAME", "n.serious", "n.death")]

# slight crashes
latmp <- aggregate(acB[wminor,"Accident_Sf"], by=wards, FUN=length)
head(latmp@data)
wards$n.slight <- latmp$Accident_Sf
plot(wards$Bicycle, wards$n.slight)

# estimated distance cycled
wards$dmkm.yr <- (wards$Bicycle * 5400) / # million pkm per cycle commuter 
  1000000

# proportion of deaths/bkm
wards$p.serious.yr <- ( (wards$n.serious / 8) / # rate per year
                         (wards$dmkm.yr / 1000) )

wards$p.death.yr <- ( (wards$n.death / 8) /
                       (wards$dmkm.yr / 1000) )

wards$p.slight.yr <- ( (wards$n.slight / 8) /
                        (wards$dmkm.yr / 1000) )

# correlation analysis
cor(wards$p.serious.yr, wards$p.slight.yr, use="complete.obs")


wards$pCycle <- wards$Bicycle / wards$All.categories..Method.of.travel.to.work
plot(wards$pCycle, wards$p.serious.yr)

object.size(wards) / 1000000
writeOGR(wards, dsn="geodata/", "wardsWY", "ESRI Shapefile")

# % more dangerous than national average
wards$perc.more <- (wards$p.serious.yr - 621) / 6.21
summary(wards$perc.more)
wards <- spTransform(wards, CRSobj=CRS("+init=epsg:4326") )
# plotting
wardsF <- fortify(wards, region="CODE")
head(wardsF)
wardsF <- rename(wardsF, c("id" = "CODE"))
wardsF <- join(wardsF, wards@data)
head(wardsF)

laWY84 <- spTransform(laWY, CRS("+init=epsg:4326"))
laWY84 <- fortify(laWY84)
bbox(laWY)

library(maps)
data(world.cities)
head(world.cities)
wc <- world.cities[ world.cities$country.etc == "UK", ]
wc <- wc[ wc$pop > 50000,]
wc$Size <- wc$pop / 100000
wc <- SpatialPointsDataFrame(matrix(c(wc$long, wc$lat), ncol=2), data=wc)
proj4string(wc) <- proj4string(wards)
wc <- wc[wards,]
wc <- rename(wc, c("pop" = "Population"))

ggplot() + geom_polygon(data = wardsF, aes(long, lat, group = group, fill = p.serious.yr)) +
  geom_path(data = laWY84, aes(long, lat, group = group), color="blue") +
  geom_point(data = wc@data, aes(wc$long, wc$lat), size=23, shape = 1) +
  geom_point(data = wc@data, aes(wc$long, wc$lat, size = Population/10000), shape = 4, width=3) +
  geom_text(data = wc@data, aes(wc$long, wc$lat - 0.03, label = name)) +
  scale_fill_gradient2(low="green", mid="grey", high="red", midpoint=621, 
                       name = "Serious\ncasualties\nper bkm/yr") + coord_map() + 
  scale_size_continuous(range = c(3,15), name="Population\n(10,000s)") +
  theme_classic()
ggsave("figures/seriousWY.png")
