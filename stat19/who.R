# analysis of who is at risk

head(ac@data) # basic accident data
head(vt)
head(caWY)
summary(caWY)

# joining bicycle casualties

# vehicle -> casualty
vtBike <- vtWY[ vtWY$Vehicle_Tf == "Pedal cycle", ]
head(vtBike)
# library(plyr)
# caVtJ <- join(caWY, vt)
library(dplyr)
caVtJ <- inner_join(caWY, vt)
caVtJ$cyclist <- "Cyclist"
caVtJ$cyclist[ !caVtJ$Vehicle_Tf == "Pedal cycle"] <- "Not a cyclist or pedestrian"
caVtJ$cyclist[ caVtJ$Type == "Pedestrian"] <- "Pedestrian"
caVtJ$cyclist <- as.factor(caVtJ$cyclist)
summary(caVtJ$cyclist)

head(caBikeAd)
summary(caBikeAd)
summary(caVtJ$Age_Band_of_Casualty)
caVtJ$Age_Band_of_Casualty <- factor(caVtJ$Age_Band_of_Casualty , labels = c("na", wb$Age.Band$label[c(1:10)]))
library(plyr)
caVtJ <- rename(caVtJ, c("Acc_Index" = "Accident_Index"))
caVtJac <- join(caVtJ, acWY@data, by="Accident_Index")
names(caVtJac)

caBikeAd <- caVtJ[ grepl("Peda|Car", caVtJ$Vehicle_Tf),] 
library(ggplot2)
qplot(caBikeAd$Age_Band, fill = caBikeAd$Vehicle_Tf ) + bikeR_theme_1
qplot(data = caVtJac, x = Age_Band_of_Casualty, fill = Accident_Sf) + facet_grid( cyclist  ~ . , scales="free" ) +
  scale_fill_manual(values=c( "red", "orange", "blue"), name = "Severity" ) +
  xlab("Age band of casualty") + bikeR_theme_1
# ggsave("figures/who-age-severity.png")


######## COMPARE WITH NTS #######################

awy <- (table(tCycle$i6, tCycle$p2g)[,3]) / (table(tWY$i6, tWY$p2g)[,3])
names(awy) <- strtrim(names(awy), 7)
names(awy)[1] <- strtrim(names(awy)[1], 5)
awyF <- c("0 - 10", "11 - 20", "21 - 45", "56 +") # final age categories
x <- c(sum(awy[1:2]), sum(awy[3:4]), sum(awy[5:8]), sum(awy[9:11], na.rm = T))
awF <- data.frame(ages = awyF, pcycle = x) 
awF$pcycle
# awF$pcycle.prop <- awF$pcycle / mean(awF$pcycle) # not needed standardised
awF # the 
# make ages comparable (after running below code for STATS19)
awF$pcrashes <- x2 # proportion of all crashes involving cyclists
awF$odds <- awF$pcrashes / awF$pcycle
awF
kable(awF, digits = 3)
write.csv(awF, "stat19/awF.csv")
df <- data.frame("Age" = as.character(awF$ages), round(awF[2:4], 3))

# awF national - put in who-national.R
awyN <- 

######## COMPARE WITH NTS #######################

ts1 <- table(caVtJac$Accident_Sf, caVtJ$cyclist ) 
ts2 <- prop.table(table(caVtJac$Accident_Sf, caVtJ$cyclist ),2 )
tsage <- table(caVtJ$Age_Band_Cf[ caVtJ$cyclist == "Cyclist"])/
  table(caVtJ$Age_Band_Cf)
c(tsage[2:3], tsage[4:5], tsage[6:9], tsage[10:11])
x2 <- c(sum(tsage[2:3]), sum(tsage[4:5]), sum(tsage[6:9]), sum(tsage[10:11]))

library(knitr)
kable(cbind(ts1, round(ts2 * 100, 1)))

ftable(table(caVtJ$Casualty_Severity, caVtJ$Age_Band_of_Casualty, caVtJ$cyclist ))
prop.table(ftable(table(caVtJ$Age_Band_Cf, caVtJ$cyclist )), margin=2)
prop.table(table(caVtJ$Accident_Index, caVtJ$Age_Band_of_Casualty, caVtJ$cyclist ), margin=2)
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

