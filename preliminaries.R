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

summary(ac$Location_Easting_OSGR)
ac <- ac[-which(is.na(ac$Location_Easting_OSGR)), ]
ac <- SpatialPoints(coords=matrix(c(ac$Location_Easting_OSGR, ac$Location_Northing_OSGR), ncol=2))
proj4string(ac) <- proj4string(YW)
acWY <- ac[YW,]
plot(acWY)
acWY$Date[sample(1:nrow(acWY), size=50)]

## Extract dates from data
acWY
object.size(acWY)/1000000
object.size(ac)/1000000
vtWY <- vt[ vt$Acc_Index %in% acWY$Accident_Index, ]
caWY <- ca[ ca$Acc_Index %in% acWY$Accident_Index, ]
save(caWY, vtWY, acWY, file="WYall.RData")