# Aim: explore impact of tdf on cycle accidents in WY, compared with in other areas

pkgs <- c("rgdal", "downloader", "lubridate", "ggplot2", "dplyr", "raster", "rgeos")
lapply(pkgs, library, character.only = T)

# # Download latest tables (not raw data) not road traffic casualties
# download("http://data.dft.gov.uk.s3.amazonaws.com/road-accidents-safety-data/Stats19_Data_2005-2014.zip", destfile = "stats19-2014.zip")
# unzip("stats19-2014.zip", exdir = "stats19data")
#
# # Download latest stats19 data
# download(url = "http://data.dft.gov.uk/road-accidents-safety-data/Stats19-Data2005-2013.zip", destfile = "Stats19-Data2005-2013.zip")
# unzip("Stats19-Data2005-2013.zip", exdir = "stats19data")
#
# ac <- read.csv("stats19data/Accidents0514.csv")
# vt <- read.csv("stats19data/Vehicles0514.csv")
# ca <- read.csv("stats19data/Casualties0514.csv") # casualties
#
# # Preliminary analysis
# vt$Accident_Index <- vt$ï..Accident_Index
# length(unique(vt$Accident_Index)) # 1.6 million vehicles
#
# # Extract bike crashes
# head(vt$Vehicle_Type)
# cyCodes <- vt$Acc_Index[vt$Vehicle_Type == 1]
# # are they a cyclist?
# ac$cyclist <- "No cyclist"
# ac$cyclist[cyCodes] <- "Cyclist"
# ac$cyclist <- factor(ac$cyclist)
# summary(ac$cyclist)
# source("stat19/addFactors.R") # add factors to data
# save(ac, vt, ca, file = "stats19data/2014-alldata.RData")

ls()
load("stats19data/2014-alldata.RData")

cyCodes <- vt$Accident_Index[vt$Vehicle_Type == 1]

ac <- rename(ac, Accident_Index = ï..Accident_Index)
cyVt <- vt[ vt$Accident_Index %in% cyCodes, ]
cyAc <- ac[ ac$Accident_Index %in% cyCodes, ]
nrow(cyVt)

head(cyVt)
head(cyAc)
plot(cyAc$Location_Easting_OSGR, cyAc$Location_Northing_OSGR)
names(cyAc)
vtosel <- c(2,3,6,7,10,12,18) # vars to select
names(cyAc)[vtosel]
cyAc.mini <- cyAc[vtosel]
object.size(cyAc.mini) / 1000000
head(cyAc.mini)
ac <- cyAc.mini # to select only cycle acs

# Subset to Leeds area, then save and play

# download("http://census.edina.ac.uk/ukborders/easy_download/prebuilt/shape/England_ct_2011_gen_clipped.zip", dest = "/media/robin/data/data-to-add/boundary/eng-ct-11.zip")

load("geodata/laWY.RData")
plot(laWY)
WY <- gBuffer(laWY, width = 0)

library(lubridate)
ac$time <- as.character(ac$Time)
head(ac$time)
timeold <- ac$time
ac$time <- paste0(ac$time,":00")
# install.packages("chron")
# library("chron")
ac$time <- lubridate::hour(ac$time)
hist(ac$time)
head(ac$time)
ggplot() + geom_histogram(aes(x = ac$time))

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
sel <- as.logical(gIntersects(WY, ac, byid = T))
summary(sel)
plot(ac)
points(ac[sel,], col = "red")
ac$wy <- "UK"
ac$wy[sel] <- "West Yorks."

summary(ac@data$date)
qplot(ac@data$date)

ac$Period <- "2005 - 2013"
ac$Period[ grepl(pattern = "2014", ac$Date)] <- "2014"
ac$Month <- lubridate::month(ac$date)
ac$week <- lubridate::week(ac$date)
plot(ac$week)
ac$Day <- paste(ac$Month, ac$mday)


ggplot(data = ac@data) + geom_histogram(aes(week), ) + facet_grid(wy ~ Period, scales = "free")
ggplot(data = ac@data) + geom_histogram(aes(week), ) + facet_wrap(wy ~ Period, scales = "free")
ggplot(data = ac@data) + geom_histogram(aes(week), ) + facet_wrap(wy ~ Period, scales = "free") + geom_vline(aes(xintercept = 28))
ggsave("figures/tdf-time-series.png")

sel <- grepl(pattern = "07/2014", ac$Date)
head(ac@data[sel,])

plot(WY)
acWY <- ac[WY,]
head(acWY@data)
plot(acWY, add = T)
acWY$Date[sample(1:nrow(acWY), size=50)]

# ## Extract dates from data
# acWY
# object.size(acWY)/1000000
# object.size(ac)/1000000
# vtWY <- vt[ vt$Acc_Index %in% acWY$Accident_Index, ]
# caWY <- ca[ ca$Acc_Index %in% acWY$Accident_Index, ]
# save(caWY, vtWY, acWY, file="geodata/WYall-2005-2013.RData")
