# who national-level (for comparison)
# analysis of who is at risk

head(ac@data) # basic accident data
head(vt)
head(ca)
summary(ca)

# joining bicycle casualties

# vehicle -> casualty
vtBike <- vt[ vt$Vehicle_Tf == "Pedal cycle", ]
head(vtBike)
caVt <- join(ca, vt)
caVt$cyclist <- "Cyclist"
caVt$cyclist[ !caVt$Vehicle_Tf == "Pedal cycle"] <- "Not a cyclist or pedestrian"
caVt$cyclist[ caVt$Type == "Pedestrian"] <- "Pedestrian"
caVt$cyclist <- as.factor(caVt$cyclist)
summary(caVt$cyclist)

head(caBikeAd)
summary(caBikeAd)
caVt$Age_Band_of_Casualty <- factor(caVt$Age_Band_of_Casualty , labels = c("na", wb$Age.Band$label[c(1:10)]))
caVt <- rename(caVt, c("Acc_Index" = "Accident_Index"))
caVtac <- join(caVt, ac@data, by="Accident_Index")
names(caVtac)

caBikeAd <- caVt[ grepl("Peda|Car", caVt$Vehicle_Tf),] 
qplot(caBikeAd$Age_Band, fill = caBikeAd$Vehicle_Tf ) + bikeR_theme_1
qplot(data = caVtac, x = caVtac$Age_Band_Cf, fill = Accident_Sf) + facet_grid( cyclist  ~ . , scales="free" ) +
  scale_fill_manual(values=c( "red", "orange", "blue"), name = "Severity" ) +
  xlab("Age band of casualty") + bikeR_theme_1
# ggsave("figures/who-age-severity.png")

ts1 <- table(caVtac$Accident_Sf, caVt$cyclist ) 
ts2 <- prop.table(table(caVtac$Accident_Sf, caVt$cyclist ),2 )
library(knitr)
kable(cbind(ts1, round(ts2 * 100, 1)))

ftable(table(caVt$Severity, caVt$Age_Band_of_Casualty, caVt$cyclist ))

# % under 20 hurt
prop.table(ftable(table(caVt$Age_Band_Cf, caVt$cyclist )), margin=2)
prop.table(ftable(table(caVtJ$Age_Band_Cf, caVtJ$cyclist )), margin=2)

# how much worse are children in WY than nationally?
sum(prop.table(ftable(table(caVtJ$Age_Band_Cf, caVtJ$cyclist )), margin=2)[,1][2:6])
sum(prop.table(ftable(table(caVtac$Age_Band_Cf, caVtac$cyclist )), margin=2)[,1][2:6])

(d <- (prop.table(ftable(table(caVtJ$Age_Band_Cf, caVtJ$cyclist )), margin=2)[,1] -
  prop.table(ftable(table(caVt$Age_Band_Cf, caVt$cyclist )), margin=2)[,1]) * 100)

df <- data.frame(Age = levels(caVtac$Age_Band_Cf), Difference = d)
levels(df$Age)
df$Ages <- factor(df$Age, levels = levels(df$Age)[c(1,9,2,3,4,5,6,7,8,10,12,11)])
ggplot(df) + geom_bar(aes(x = Ages, y = Difference)) + bikeR_theme_1 +
  ylab("Proportion of cycle casualties by age in West Yorkshire - UK (% points)")
# ggsave("figures/anomaly-age.png")

sum(c(-0.0050559390, -0.0282616970, -0.0172657841, -0.0075497666, -0.0042948374))

### plot for other modes
sum(prop.table(ftable(table(caVtJ$Age_Band_Cf, caVtJ$cyclist )), margin=2)[,3][2:6])
sum(prop.table(ftable(table(caVtac$Age_Band_Cf, caVtac$cyclist )), margin=2)[,3][2:6])
(d <- (prop.table(ftable(table(caVtJ$Age_Band_Cf, caVtJ$cyclist )), margin=2)[,2] -
         prop.table(ftable(table(caVt$Age_Band_Cf, caVt$cyclist )), margin=2)[,2]) * 100)

df <- data.frame(Age = levels(caVtac$Age_Band_Cf), Difference = d)
levels(df$Age)
df$Ages <- factor(df$Age, levels = levels(df$Age)[c(1,9,2,3,4,5,6,7,8,10,12,11)])
ggplot(df) + geom_bar(aes(x = Ages, y = Difference)) + bikeR_theme_1 +
  ylab("Anomaly in age distribution of non-cyclist casualties in West Yorkshire (% points)")
# ggsave("figures/anomaly-age-other.png")

(d <- (prop.table(ftable(table(caVtJ$Age_Band_Cf, caVtJ$cyclist )), margin=2)[,3] -
         prop.table(ftable(table(caVt$Age_Band_Cf, caVt$cyclist )), margin=2)[,3]) * 100)

df <- data.frame(Age = levels(caVtac$Age_Band_Cf), Difference = d)
levels(df$Age)
df$Ages <- factor(df$Age, levels = levels(df$Age)[c(1,9,2,3,4,5,6,7,8,10,12,11)])
ggplot(df) + geom_bar(aes(x = Ages, y = Difference)) + bikeR_theme_1 +
  ylab("Anomaly in age distribution of non-cyclist casualties in West Yorkshire (% points)")
# ggsave("figures/anomaly-age-ped.png")

prop.table(table(caVt$Severity, caVt$Age_Band_of_Casualty, caVt$cyclist ), margin=2)
prop.table(table(caVt$Accident_Sf, caVt$Age_Band_of_Casualty  ), margin=2)
prop.table(table(caBikeAd$Accident_Sf, caBikeAd$Age_Band_of_Casualty  ), margin=2)

### age by time of day

head(caVt)

summary(caVtac$Age_Band_of_Casualty)
summary(caVtac$cyclist)
library(chron)
ggplot(aes(time, ..density..,), data = caVtac[ grepl("10|11|16|21", caVtac$Age_Band_of_Casualty) &
                                                  caVtac$cyclist == "Cyclist",]) + geom_histogram() + geom_density() + 
  facet_grid(~ Age_Band_of_Casualty) + scale_x_chron(format="%H")
# ggsave("figures/cyclist-age-time.png", width = 5, height = 5, units = "in", dpi = 100)

ggplot(aes(time, ..density..,), data = caVtac[ grepl("10|11|16|21", caVtac$Age_Band_of_Casualty) ,]) + geom_histogram() + geom_density() + 
  facet_grid(~ Age_Band_of_Casualty) + scale_x_chron(format="%H")
# ggsave("figures/all-age-time.png", width = 5, height = 5, units = "in", dpi = 100)

# and sex...

caVtac$Sex_of_Casualty <- factor(caVtac$Sex_of_Casualty, labels = c("Male", "Female"))

ggplot(aes(time, ..density..,), data = caVtac[ grepl("10|11|16|21", caVtac$Age_Band_of_Casualty) &
                                                  caVtac$cyclist == "Cyclist",]) + geom_histogram() + geom_density() + 
  facet_grid(Sex_of_Casualty ~ Age_Band_of_Casualty) + scale_x_chron(format="%H")
# ggsave("figures/cyclist-age-time.png", width = 5, height = 5, units = "in", dpi = 100)

ggplot(aes(time, ..density..,), data = caVtac[ grepl("10|11|16|21", caVtac$Age_Band_of_Casualty) ,]) + geom_histogram() + geom_density() + 
  facet_grid(Sex_of_Casualty~ Age_Band_of_Casualty) + scale_x_chron(format="%H")
# ggsave("figures/all-age-time.png", width = 5, height = 5, units = "in", dpi = 100)

# accident severity by gender

b <- caVtac[ caVtac$Type == "Cyclist", ]
caV <- caVtac
ts3 <- table(b$Severity, b$Sex_of_Casualty)
ts4 <- round(prop.table(table(b$Severity, b$Sex_of_Casualty), margin=2) * 100, 1)
kable(cbind(ts3, ts4))

table(caV$Type, caV$Sex_Casualty)
p1 <- prop.table(table(caV$Type, caV$Sex_Casualty) , 1)[,]
kable(round(p1 * 100, 1))
summary(caV$Type)
