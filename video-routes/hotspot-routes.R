# Aim: to identify commuting accident hotspots and routes to get there

# source("video-routes/load-stats19.R") # load the data

load("geodata/WYall-2005-2013.RData")

nrow(acWY)

writeOGR(acWY, dsn = "geodata/", layer = "acYW", driver = "ESRI Shapefile")

# estimate 2d density
library(spatstat)
library(maptools)
acp <- as.ppp(acWY)
adens <- density.ppp(x = acp, sigma = 50, eps = 50)
plot(adens)
arast <- raster(adens)
arast <- mask(arast, wyoutline)
plot(arast)

writeRaster(x = arast, filename = "geodata/arast.tif", overwrite = T)
dsg <- as(arast, "SpatialGridDataFrame")
dsg <- as.image.SpatialGridDataFrame(dsg)
dcl <- contourLines(dsg, nlevels = 10)
sldf <- ContourLines2SLDF(dcl)
plot(sldf[8,]) # the most intense accident hotspot
h1 <- gPolygonize(sldf[8,])
spChFIDs(h1) <- 1
h2 <- gPolygonize(sldf[7,])
spChFIDs(h1) <- 2
h3 <- gPolygonize(sldf[6,])
spChFIDs(h3) <- seq(101, 100 + length(h3))
hspots <- spRbind(h3, h2)
h4 <- gPolygonize(sldf[5,])

h5 <- gPolygonize(sldf[3,]) # the right contour to save
length(h5)
proj4string(h5) <- proj4string(acWY)
nacs <- aggregate(acWY, h5, length)
nacs <- spTransform(nacs, CRS("+init=epsg:27700"))
nacs$area <- gArea(nacs, byid = T)

nacs@data <- dplyr::select(nacs@data, n_crashes = Time, area, accident_rate)
nacs$accident_rate <- round(nacs$n_crashes / nacs$area * 10000, 1)
nacs <- spTransform(nacs, CRS("+init=epsg:4326"))
round(coordinates(nacs), 4)
nacs$name <- NA
library(ggmap)
for(i in 1:nrow(nacs)){
  nacs$name[i] <- revgeocode(coordinates(nacs)[i,])
  print(nacs$name[i])
}

nacs$name <- gsub(pattern = "Leeds, West Yorkshire ", replacement = "", nacs$name)
nacs$name <- gsub(pattern = ", UK", replacement = "", nacs$name)
nacs@data

nacs$area <- round(nacs$area)
nacs$accident_rate <- round(nacs@data$accident_rate / 9, 2)
dfn <- nacs@data
dfn <- dfn[order(dfn$accident_rate, decreasing = T),]

knitr::kable(dfn, row.names = F)

dfn2 <- dfn[grep("1871|1354|87225|1478|7021", dfn$area),]
dfn2 <- dplyr::select(dfn2, name)
dfn2$reason <- c(
  "Has the highest accident rate",
  "High accident rate",
  "Moderate accident rate, isolated at a junction",
  "Largest area, surrounded by other hotspots",
  "In an under-represented part of town, isolated"
)
knitr::kable(dfn2, row.names = F)


writeOGR(obj = nacs, dsn = "geodata/", layer = "hotspots16", driver = "ESRI Shapefile")
writeOGR(obj = nacs, dsn = "geodata/hotspots16.geojson", driver = "OGRGeoJSON")
geojsonio::geojson_write(nacs, file = "geodata/hotspots-16.geojson")

acWY_char <- acWY
acWY_char@data <- acWY_char@data[!names(acWY) == "time"]
writeOGR(obj = acWY_char, dsn = "geodata/", layer = "cyacs13", driver = "ESRI Shapefile")

acWY_char <- spTransform(acWY_char, CRS("+init=epsg:4326"))
bbp <- gPolygonize(bbox(nacs))

gClip <- function(shp, bb){
  if(class(bb) == "matrix") b_poly <- as(extent(as.vector(t(bb))), "SpatialPolygons")
  else b_poly <- as(extent(bb), "SpatialPolygons")
  gIntersection(shp, b_poly, byid = T)
}

acWY_char <- gClip(acWY_char, nacs)

nacs5 <- nacs[nacs$name %in% dfn2$name, ]

library(leaflet)
leaflet() %>% addTiles("http://{s}.tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png") %>% addPolygons(data = nacs5, fillOpacity = 0.7) %>% addCircleMarkers(data = acWY_char, radius = 6, stroke = F, opacity = 0.1, fillColor = "red") %>% addPopups(data = coordinates(nacs5), popup = nacs5@data$name)

