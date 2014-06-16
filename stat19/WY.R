# West Yorkshire preliminary analysis

load("WYall.RData")

# Compare bike crashes with others + generalise results
# These are incidents INVOLVING cyclists (not necessarily where cyclists are injured)
bikes <- vtWY$Acc_Index[ vtWY$Vehicle_Type == 1]
acB <- acWY[ acWY$Accident_Index %in% bikes, ]
vtB <- vtWY[ vtWY$Acc_Index %in% bikes, ]
caB <- caWY[ caWY$Acc_Index %in% bikes, ]

plot(acWY)
plot(acB, col="red", add=T, alpha = 0.1)

acWY$cyclist <- "No cyclist"
acWY$cyclist[acWY$Accident_Index %in% bikes] <- "Cyclist"

## Convert data into correct form

### Road class of accident
head(acWY$X1st_Road_Class)
class(acWY$X1st_Road_Class)
unique(acWY$X1st_Road_Class)
which(acWY$X1st_Road_Class == 5)
acWY$Road_class <- factor( acWY$X1st_Road_Class, levels = 1:6,
                        labels = c("Motorway", "A", "A", "B", "U", "U"))
head(acWY$Road_class)
qplot(Road_class, data=acWY@data) 
p <- ggplot(aes(Road_class), data = acWY@data) + geom_bar()
p + facet_grid(cyclist ~., scales="free") + xlab("Road class")
# ggsave("figures/roadClass.png")

p <- ggplot(aes(Road_class), data = acWY@data) + geom_bar(aes(fill = Accident_Severity))
p + facet_grid(cyclist ~., scales="free") + xlab("Road class")

### Now display this data as a table
a <- with(acWY@data, table(Road_class, cyclist))
ptab <- function(x) x/c(sum(a[,1]),sum(a[,2]))
apply(a, 1, ptab)

head(a)
class(a)
sweep(a, 1, mean)
prop.table()
library(dplyr)
??dplyr



### Timing of accident
summary(acWY$Time)
class(acWY$Time)
acWY$time <- as.character(acWY$Time)
summary(acWY$time)
head(acWY$time)
acWY$time <- paste0(acWY$time,":00")

# acWY$time <- as.POSIXct(acWY$time, format = "%H:%M") # works but...
library(chron)
summary(chron(times = acWY$time))
acWY$time <- chron(times = acWY$time) 
ggplot(aes(time, ..density..,), data = acWY@data) + geom_histogram() + geom_density() + 
  facet_grid(~ cyclist) + scale_x_chron(format="%H")
# ggsave("figures/cyclist-timings.png", width = 5, height = 5, units = "in", dpi = 100)

# spatial plotting
library(ggmap)
ggplot() +  geom_point(aes(y = Latitude, x = Longitude, color=Road_class), 
                       data = acWY@data)


ggmap(get_map("Leeds", zoom=16)) +
  geom_point(aes(x = acB$Latitude, y = acB$Longitude))

theme_set(theme_bw(16))
qmap("Leeds", zoom=16, color = "bw") +
geom_point(aes(x = Longitude, y = Latitude, color=Accident_Severity), 
             data = acWY@data)
# ggsave("figures/city-centre.png", width = 400)
o <- 1:nrow(acWY)
o[ acWY$cyclist == "Cyclist"] <- 1000000:1000000 + length(which(acWY$cyclist == "Cyclist"))
ggplot() + 
  geom_point(aes(y = Latitude, x = Longitude, color = cyclist,
                 shape = Road_class, order = o), data = acWY@data, alpha = 0.7, size = 1.9) +
  scale_shape_manual(values=c(1,4,3,2), name="Road class") +
  scale_color_discrete( name = "Colour\n(incident\ninvolves a\nbicycle)") +
  coord_map()
ggsave("figures/overview2.png")


# heatmap of cycle accidents for cyclists/non
ggplot() + 
  geom_point(aes(y = Latitude, x = Longitude, shape = Road_class), data = acWY@data, alpha = 0.3, size = 1.5) +
  stat_density2d(aes(y = Latitude, x = Longitude, fill = ..level..), 
                 geom="polygon", data = acWY@data, alpha = 0.6
#                  , adjust = 0.2
                 ) +
  facet_grid(~ cyclist) +
  scale_fill_continuous(low = "green", high = "red", name= "KDE level") +
  scale_shape_manual(values=c(1,4,3,2), name="Road class") +
  coord_map()
ggsave("figures/kdePlot.png")
  

## msoa-level ploting
x <- c("rgdal", "ggplot2", "rgeos", "dplyr")
lapply(x, require, character.only=T)
# msoas <- readOGR("geodata/", "WY-msoa")

# head(msoas@data)
# msoa.data <- read.csv("geodata/msoasBike.csv") # 2011 ttw
# head(msoa.data[1:3])
# names(msoa.data)
# summary(msoas@data$CODE %in% msoa.data$CODE)
# msoas@data <- merge(msoas@data, msoa.data, by="CODE", all.x=T)
# head(msoas@data)
# writeOGR(msoas, "geodata/", "msoasBike", "ESRI Shapefile")
readOGR("geodata/", "msoasBike", "ESRI Shapefile")

# # lsoas of leeds
# wy <- readOGR("data/", "wy")
# wy <- as(wy, "SpatialPolygons")
# lsoas <- readOGR("/media/SAMSUNG/geodata/2011/", "England_oa_2011_gen_clipped")
# lsoas <- as(lsoas, "SpatialPolygons")
# lsoasWy <- lsoas[wy,]
# plot(lsoasWy)
# plot(wy, add=T)