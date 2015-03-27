# Load and explore
setwd("/media/robin/SAMSUNG/repos/bikeR/")
ac <- read.csv("Accidents0512.csv")
vt <- read.csv("Vehicles0512.csv")
ca <- read.csv("Casualty0512.csv") # casualties
setwd("~/repos/bikeR/")

# First task: add factors
# source("Rcode/addFactors.R") 

# Preliminary analysis
length(unique(vt$Acc_Index))

# Extract bike crashes

head(vt$Vehicle_Type)
cyCodes <- vt$Acc_Index[vt$Vehicle_Type == 1]
# are they a cyclist?
ac$cyclist <- "No cyclist"
ac$cyclist[cyCodes] <- "Cyclist"
ac$cyclist <- factor(ac$cyclist)
summary(ac$cyclist)

cyVt <- vt[ vt$Acc_Index %in% cyCodes, ]
cyAc <- ac[ ac$Accident_Index %in% cyCodes, ]
nrow(cyVt)

head(cyVt)
plot(cyAc$Location_Easting_OSGR, cyAc$Location_Northing_OSGR)
names(cyAc)
cyAc.mini <- cyAc[c(2,3,6,7,10)]
object.size(cyAc.mini) / 1000000
head(cyAc.mini)
save(cyAc.mini, file="/media//SAMSUNG/repos/osm-cycle/cy-uptake/updata/cyAc.mini.STATS19.RData")

# Subset to Leeds area, then save and play
library(rgdal)
# counties <- readOGR(dsn="/scratch/gdata/" , layer="england_ct_2011_gen_clipped")
# counties <- readOGR(dsn="/media/" , layer="england_ct_2011_gen_clipped")
# plot(counties)
# head(counties@data)
# WY <- counties[ counties$NAME == "West Yorkshire", ]
# WY <- wy # if already loaded under different name
plot(WY)
save(WY, file = "geodata/WYoutline.RData")
# convert Time text to chron format
library(chron)
ac$time <- as.character(ac$Time)
ac$time <- paste0(ac$time,":00")
ac$time <- chron(times = ac$time)
hist(ac$time)

# same for dates
head(ac$Date)
ac$date <- as.character(ac$Date)
ac$date <- as.Date(ac$date, format="%d/%m/%Y")
summary(ac$date)
plot(ac$date[1:1000])
library(ggplot2)
qplot(ac$date, geom="histogram", binwidth = 30) # ...




bbox(WY)
WY <- spTransform(WY, CRSobj = CRS("+init=epsg:27700"))
bbox(WY)

summary(ac$Location_Easting_OSGR)
ac <- ac[-which(is.na(ac$Location_Easting_OSGR)), ]
ac <- SpatialPointsDataFrame(coords=matrix(c(ac$Location_Easting_OSGR, ac$Location_Northing_OSGR), ncol=2), data=ac)
proj4string(ac) <- proj4string(WY)

### RUN addFactors here ### and then continue

# all zones in WY
plot(WY)
acWY <- ac[WY,]
head(acWY@data)
plot(acWY)
acWY$Date[sample(1:nrow(acWY), size=50)]

## Extract dates from data
acWY
object.size(acWY)/1000000
object.size(ac)/1000000
vtWY <- vt[ vt$Acc_Index %in% acWY$Accident_Index, ]
caWY <- ca[ ca$Acc_Index %in% acWY$Accident_Index, ]
save(caWY, vtWY, acWY, file="WYall.RData")
