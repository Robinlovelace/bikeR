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
caVtJ$cyclist[ !caVtJ$Vehicle_Tf == "Pedal cycle"] <- "Not a cyclist or pedestrian"
caVtJ$cyclist[ caVtJ$Type == "Pedestrian"] <- "Pedestrian"

caBikeAd <- caVtJ[ caVtJ$cyclist == "Cyclist", ]
head(caBikeAd)
summary(caBikeAd)
caVtJ$Age_Band_of_Casualty <- factor(caVtJ$Age_Band_of_Casualty , labels = c("na", wb$Age.Band$label[c(1:10)]))
caVtJ <- rename(caVtJ, c("Acc_Index" = "Accident_Index"))
caVtJ <- join(caVtJ, ac@data, by="Accident_Index")

caBikeAd <- caVtJ[ grepl("Ped|Car", caVtJ$Vehicle_Tf),] 
qplot(caBikeAd$Age_Band, fill = caBikeAd$Vehicle_Tf ) + bikeR_theme_1
qplot(data = caVtJ, x = Age_Band_of_Casualty, fill = caVtJ$Accident_Sf) + facet_grid( cyclist  ~ . , scales="free" ) +
  scale_fill_manual(values=c( "red", "orange", "blue"), name = "Severity" ) +
  xlab("Age band of casualty") + bikeR_theme_1
ggsave("figures/who-age-severity.png")

ts1 <- table(caVtJ$Accident_Sf, caVtJ$cyclist ) 
ts2 <- prop.table(table(caVtJ$Accident_Sf, caVtJ$cyclist ),2 )
kable(cbind(ts1, round(ts2 * 100, 1)))

ftable(table(caVtJ$Accident_Sf, caVtJ$Age_Band_of_Casualty, caVtJ$cyclist ))
prop.table(table(caVtJ$Accident_Sf, caVtJ$Age_Band_of_Casualty, caVtJ$cyclist ), margin=2)
prop.table(table(caVtJ$Accident_Sf, caVtJ$Age_Band_of_Casualty  ), margin=2)
prop.table(table(caBikeAd$Accident_Sf, caBikeAd$Age_Band_of_Casualty  ), margin=2)
ggsave("figures/who-age1.png")
