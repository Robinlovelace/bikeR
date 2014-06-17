# identification of where risk is greatest

# UK level analysis

load("/media//SAMSUNG/repos//osm-cycle/cy-uptake/updata/lam.RData")
sum(lam$Cycle.x)
sum(lam$Cycle.x) / sum(lam$Allm.x)

summary(cyAc$Location_Easting_OSGR)
toRm <- which(is.na(cyAc$Location_Easting_OSGR))
cyAc <- cyAc[ -toRm, ]
cyAcSp <- SpatialPointsDataFrame(coords=matrix(c(cyAc$Location_Easting_OSGR, cyAc$Location_Northing_OSGR),
                                                     ncol=2), data=cyAc)

nrow(cyAcSp)

library(rgdal)
england <- readOGR("/scratch/GIS/Datagis/England/GOR/", "englandageGOR")
proj4string(england)
proj4string(cyAcSp) <- proj4string(england)
bbox(cyAcSp)
cyAcSpEng <- cyAcSp[ england, ]

nrow(cyAcSpEng) / nrow(cyAcSp)
cyAc <- cyAcSpEng

nrow(cyAc[ cyAc$Accident_Severity == 1, ])
nrow(cyAc[ cyAc$Accident_Severity == 2, ])
