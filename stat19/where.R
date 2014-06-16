# identification of where risk is greatest

# getting Local Authority info (use cy-change folder of github repo 'osm-cycle')
# laWY <- lamf[ grepl("Leeds|Bradf|Kirk|Wakef|Cald", lamf$NAME), ]

load("geodata/laWY.RData")
sum(laWY$Cycle.x)
sum(laWY$Cycle.y)

# number of serious injuries and fatalities
head(acWY@data)

# load accident severity data (load wb object)


# library(gdata)
# wb <- read.xls("Road-Accident-Safety-Data-Guide-1979-2004.xls", sheet="Export")
