# analysis of who is at risk
# ac <- acWY
# vt <- vtWY

head(ac@data) # basic accident data
head(vt)
head(caWY)
summary(caWY)

# joining bicycle casualties

# vehicle -> casualty
vtBike <- vt[ vt$Vehicle_Tf == "Pedal cycle", ]
head(vtBike)
caVtJ <- join(caWY, vt)
caVtJ$cyclist <- "Cyclist"
caVtJ$cyclist[ !caVtJ$Vehicle_Tf == "Pedal cycle"] <- "Not a cyclist"
caVtJ$cyclist[ !caVtJ$Vehicle_Tf == "Pedestrian"] <- "Not a cyclist"

# caBikeAd <- join(caWY, vtBike)
head(caBikeAd)
summary(caBikeAd)
caVtJ$Age_Band_of_Casualty <- factor(caVtJ$Age_Band_of_Casualty , labels = c("na", wb$Age.Band$label[c(1:10)]))

caBikeAd <- caVtJ[ grepl("Ped|Car", caVtJ$Vehicle_Tf),] 
qplot(caBikeAd$Age_Band, fill = caBikeAd$Vehicle_Tf ) + bikeR_theme_1
qplot(data = caVtJ, x = Age_Band_of_Casualty) + facet_grid( cyclist  ~ . , scales="free" ) + bikeR_theme_1
ggsave("figures/who-age1.png")
