# Load and explore
ac <- read.csv("Accidents0512.csv")
vt <- read.csv("Vehicles0512.csv")
ca <- read.csv("Casualty0512.csv")

# Preliminary analysis
length(unique(vt$Acc_Index))

# Extract bike crashes

head(vt$Vehicle_Type)
cyCodes <- vt$Acc_Index[vt$Vehicle_Type == 1]

cyAc <- ac[ ac$Accident_Index %in% cyCodes, ]
cyVt <- vt[ vt$Acc_Index %in% cyCodes, ]
head(cyVt)
plot(cyAc$Location_Easting_OSGR, cyAc$Location_Northing_OSGR)

# Subset to Leeds area, then save and play
library(rgdal)
counties <- readOGR(dsn="/scratch/gdata/" , layer="england_ct_2011_gen_clipped")
plot(counties)
head(counties@data)
YW <- counties[ counties$NAME == "West Yorkshire", ]
plot(YW)

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
qplot(ac$date, geom="histogram", binwidth = 30) # ...

summary(ac$Location_Easting_OSGR)
ac <- ac[-which(is.na(ac$Location_Easting_OSGR)), ]
ac <- SpatialPoints(coords=matrix(c(ac$Location_Easting_OSGR, ac$Location_Northing_OSGR), ncol=2))
proj4string(ac) <- proj4string(YW)
acWY <- ac[YW,]
plot(acWY)
acWY$Date[sample(1:nrow(acWY), size=50)]
object.size(acWY)/1000000
object.size(ac)/1000000
vtWY <- vt[ vt$Acc_Index %in% acWY$Accident_Index, ]
caWY <- ca[ ca$Acc_Index %in% acWY$Accident_Index, ]
save(caWY, vtWY, acWY, file="WYall.RData")