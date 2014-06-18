# identification of where risk is greatest

# start at national level: number of 'cycle crashes' overall
# load("WYall.RData)
head(bikes)
nrow(cyAc[ cyAc$Accident_Severity == 1, ])
nrow(acWY[ acWY$cyclist == "Cyclist", ])

# getting Local Authority info (use cy-change folder of github repo 'osm-cycle')
# laWY <- lamf[ grepl("Leeds|Bradf|Kirk|Wakef|Cald", lamf$NAME), ]

load("geodata/laWY.RData")
sum(laWY$Cycle.x)
sum(laWY$Cycle.y)

# number of serious injuries and fatalities
head(acB@data)

# load accident severity data (load wb object)
library(gdata)
wbA <- read.xls("Road-Accident-Safety-Data-Guide-1979-2004.xls", sheet=4)
head(wbA)
acB$Accident_Sf <- factor(acB$Accident_Severity, labels = wbA$label)

# subsetting for serious and deathly crashes
wserious <- acB$Accident_Sf == "Serious" 
summary(wserious)
wdeath <- acB$Accident_Sf == "Fatal" 
wminor <- acB$Accident_Sf == "Slight"

proj4string(laWY) <- proj4string(acB)

# extract n. serious injuries
latmp <- aggregate(acB[wserious,"Accident_Sf"], by=laWY, FUN=length)
head(latmp@data)
nrow(latmp)
laWY$n.serious <- latmp$Accident_Sf
plot(laWY$Cycle.x, laWY$n.serious)

# n. fatalities
latmp <- aggregate(acB[wdeath,"Accident_Sf"], by=laWY, FUN=length)
laWY$n.death <- latmp$Accident_Sf
plot(laWY$Cycle.x, laWY$n.death)
laWY@data[c("NAME", "n.serious", "n.death")]

# slight
latmp <- aggregate(acB[wminor,"Accident_Sf"], by=laWY, FUN=length)
laWY$n.slight <- latmp$Accident_Sf
plot(laWY$Cycle.x, laWY$n.slight)
laWY@data[c("NAME", "n.serious", "n.death")]

# estimated distance cycled
laWY$dmkm.yr <- (laWY$Cycle.x * 5400) / # million pkm per cycle commuter 
                1000000

# proportion of deaths/bkm
laWY$p.serious.yr <- ( (laWY$n.serious / 8) / # rate per year
                       (laWY$dmkm.yr / 1000) )

laWY$p.death.yr <- ( (laWY$n.death / 8) /
                       (laWY$dmkm.yr / 1000) )

laWY$p.slight.yr <- ( (laWY$n.slight / 8) /
                       (laWY$dmkm.yr / 1000) )
ncol(laWY)
names(laWY)
laWY@data[,60:64]
library(knitr)
kable(laWY@data[,c(1,17,21,60:64)], digits=1, row.names=F)


