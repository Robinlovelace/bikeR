library(dplyr)
library(lubridate)

load("~/repos/bikeR/stat19/WYall.RData")
names(acWY)
head(acWY$date)
class(acWY$date)
class(acWY$Time)
summary(acWY$Time)
acWY$time <- as.character(acWY$Time)

# classify age bands
oldage <- levels(factor(caWY$Age_Band_of_Casualty))
summary(factor(caWY$Age_Band_of_Casualty))

caWY$Age_Band <- factor(caWY$Age_Band_of_Casualty , labels = c( wb$Age.Band$label[c(1:11)]))
summary(caWY$Age_Band)
caWY$ageband <- as.character(caWY$Age_Band)
caWY$ageband[ grepl("0 - 5|6 - 10", caWY$Age_Band)] <- "0 - 10"
caWY$ageband[ grepl("56|75", caWY$Age_Band)] <- "56+" 
summary(factor(caWY$ageband))

names(caWY)
acWY@data <- rename(acWY@data, Acc_Index = Accident_Index)
caWY <- inner_join(caWY, vtWY[1:3])
caWY <- inner_join(caWY, acWY@data)

caWY$yr_month <- as.character(floor_date(caWY$date, unit = "year"))
class(caWY$yr_month)


months <- group_by(caWY, yr_month)
my_month <- summarise(months,
  n = n(),
  prop_cycle = sum(Vehicle_Type == 1) /  n()
  )
head(my_month)
library(ggplot2)
qplot(yr_month, prop_cycle, data = my_month) # proof of concept

# disaggregate by age
summary(caWY$Age_Band_of_Casualty)
summary(factor(caWY$ageband))
by_month <- summarise(months,
  prop_0_10 = sum(Vehicle_Type == 1 & ageband == "0 - 10") / n(),
  prop_11_15 = sum(Vehicle_Type == 1 & ageband == "11 - 15") / n(),
  prop_16_20 = sum(Vehicle_Type == 1 & ageband == "16 - 20") / n(),
  prop_21_25 = sum(Vehicle_Type == 1 & ageband == "21 - 25") / n(),
  prop_26_35 = sum(Vehicle_Type == 1 & ageband == "26 - 35") / n(),
  prop_36_45 = sum(Vehicle_Type == 1 & ageband == "36 - 45") / n(),
  prop_46_55 = sum(Vehicle_Type == 1 & ageband == "46 - 55") / n(),
  prop_56_100 = sum(Vehicle_Type == 1 & ageband == "56+") / n()
  )
summary(by_month)
library(tidyr)
by_month[-1] <- apply(by_month[-1], 2, function(x)
  x / x[1])

bm <- gather(data = by_month, Age, Percent, -yr_month )
head(bm)
summary(bm)
levels(bm$Age) <- gsub("prop_", "", levels(bm$Age))
levels(bm$Age) <- gsub("_", " - ", levels(bm$Age))
qplot(yr_month, Percent, data = bm, colour = Age) # proof of concept

bm <- rename(bm, Year = yr_month)
bm$Year <- gsub("-01-01", "", bm$Year) 
bm$Year <- as.numeric(bm$Year)

qplot(Year, Percent, data = bm, colour = Age, geom = "line") +
  scale_color_brewer(type = "qual", guide = guide_legend("Age of\ncyclist\ncasualty")) + ylab("Proportion of accidents") + theme_bw() 

# double check we've got the age bands right
# age_yr <- group_by(caWY, yr_month, Age_Band_of_Casualty)
# aband <- summarise(age_yr, pcycle = mean())
