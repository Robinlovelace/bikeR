# analysis of who is at risk

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
caVtJ$cyclist <- as.factor(caVtJ$cyclist)
summary(caVtJ$cyclist)

head(caBikeAd)
summary(caBikeAd)
caVtJ$Age_Band_of_Casualty <- factor(caVtJ$Age_Band_of_Casualty , labels = c("na", wb$Age.Band$label[c(1:10)]))
caVtJ <- rename(caVtJ, c("Acc_Index" = "Accident_Index"))
caVtJac <- join(caVtJ, acWY@data, by="Accident_Index")
names(caVtJac)

caBikeAd <- caVtJ[ grepl("Peda|Car", caVtJ$Vehicle_Tf),] 
qplot(caBikeAd$Age_Band, fill = caBikeAd$Vehicle_Tf ) + bikeR_theme_1
qplot(data = caVtJac, x = Age_Band_of_Casualty, fill = Accident_Sf) + facet_grid( cyclist  ~ . , scales="free" ) +
  scale_fill_manual(values=c( "red", "orange", "blue"), name = "Severity" ) +
  xlab("Age band of casualty") + bikeR_theme_1
# ggsave("figures/who-age-severity.png")

ts1 <- table(caVtJac$Accident_Sf, caVtJ$cyclist ) 
ts2 <- prop.table(table(caVtJac$Accident_Sf, caVtJ$cyclist ),2 )
library(knitr)
kable(cbind(ts1, round(ts2 * 100, 1)))

ftable(table(caVtJ$Accident_Sf, caVtJ$Age_Band_of_Casualty, caVtJ$cyclist ))
prop.table(ftable(table(caVtJ$Age_Band_Cf, caVtJ$cyclist )), margin=2)
prop.table(table(caVtJ$Accident_Sf, caVtJ$Age_Band_of_Casualty, caVtJ$cyclist ), margin=2)
prop.table(table(caVtJ$Accident_Sf, caVtJ$Age_Band_of_Casualty  ), margin=2)
prop.table(table(caBikeAd$Accident_Sf, caBikeAd$Age_Band_of_Casualty  ), margin=2)

### age by time of day

head(caVtJ)

summary(caVtJac$Age_Band_of_Casualty)
summary(caVtJac$cyclist)
library(chron)
p1 <- ggplot(aes(time, ..density..,), data = caVtJac[ grepl("10|11|16|21", caVtJac$Age_Band_of_Casualty) &
                                                  caVtJac$cyclist == "Cyclist",]) + geom_histogram() + geom_density() + 
  facet_grid(~ Age_Band_of_Casualty) + scale_x_chron(format="%H") + ylab("Cyclist")
# ggsave("figures/cyclist-age-time.png", width = 5, height = 5, units = "in", dpi = 100)

p2 <- ggplot(aes(time, ..density..,), data = caVtJac[ grepl("10|11|16|21", caVtJac$Age_Band_of_Casualty) ,]) + geom_histogram() + geom_density() + 
  facet_grid(~ Age_Band_of_Casualty) + scale_x_chron(format="%H") + ylab("Non-cyclist")
# ggsave("figures/all-age-time.png", width = 5, height = 5, units = "in", dpi = 100)
library(gridExtra)
gridExtra::grid.arrange(p1, p2)



# and sex...

caVtJac$Sex_of_Casualty <- factor(caVtJac$Sex_of_Casualty, labels = c("Male", "Female"))

ggplot(aes(time, ..density..,), data = caVtJac[ grepl("10|11|16|21", caVtJac$Age_Band_of_Casualty) &
                                                  caVtJac$cyclist == "Cyclist",]) + geom_histogram() + geom_density() + 
  facet_grid(Sex_of_Casualty ~ Age_Band_of_Casualty) + scale_x_chron(format="%H")
ggsave("figures/cyclist-age-time.png", width = 5, height = 5, units = "in", dpi = 100)

ggplot(aes(time, ..density..,), data = caVtJac[ grepl("10|11|16|21", caVtJac$Age_Band_of_Casualty) ,]) + geom_histogram() + geom_density() + 
  facet_grid(Sex_of_Casualty~ Age_Band_of_Casualty) + scale_x_chron(format="%H")
ggsave("figures/all-age-time.png", width = 5, height = 5, units = "in", dpi = 100)

# accident severity by gender

b <- caVtJac[ caVtJac$Type == "Cyclist", ]
caV <- caVtJac
ts3 <- table(b$Severity, b$Sex_of_Casualty)
ts4 <- round(prop.table(table(b$Severity, b$Sex_of_Casualty), margin=2) * 100, 1)
kable(cbind(ts3, ts4))

table(caV$Type, caV$Sex_Casualty)
p1 <- prop.table(table(caV$Type, caV$Sex_Casualty) , 1)[,]
kable(round(p1 * 100, 1))
summary(caV$Type)

# who hit who?

