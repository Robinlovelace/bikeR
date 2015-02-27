library(dplyr)
library(lubridate)
library(ggplot2)
# load data with preliminaries.R, until time generated

names(ac)
head(ac$date)
class(ac$date)
class(ac$Time)
summary(ac$Time)
ac$time <- as.character(ac$Time)

names(ca)
ac <- rename(ac, Acc_Index = Accident_Index)
ca <- inner_join(ca, vt[1:3])
ca <- inner_join(ca, ac)

ca$yr_month <- as.character(floor_date(ca$date, unit = "year"))
class(ca$yr_month)

load("wb.RData")
ca$Age_Band <- factor(ca$Age_Band_of_Casualty , labels = c("na", wb$Age.Band$label[c(1:11)]))
# ca$Age_Band <- factor(ca$Age_Band_of_Casualty , labels = c("na", wb$Age.Band$label[c(11, 1:10)])) # wrong
qplot(ca$Age_Band_of_Casualty)
qplot(ca$Age_Band)

ca$ageband <- as.character(ca$Age_Band)
ca$ageband[ grepl("0 - 5|6 - 10", ca$Age_Band)] <- "0 - 10"
ca$ageband[ grepl("56|75", ca$Age_Band)] <- "56+" 
summary(factor(ca$ageband))
qplot(ca$Age_Band)

months <- group_by(ca, yr_month)
my_month <- summarise(months,
  n = n(),
  prop_cycle = sum(Vehicle_Type == 1) /  n()
  )
head(my_month)
library(ggplot2)
qplot(yr_month, prop_cycle, data = my_month) # proof of concept

# disaggregate by age
summary(ca$Age_Band_of_Casualty)

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

bmuk <- gather(data = by_month, Age, Percent, -yr_month )
head(bmuk)
summary(bmuk)
levels(bmuk$Age) <- gsub("prop_", "", levels(bmuk$Age))
levels(bmuk$Age) <- gsub("_", " - ", levels(bmuk$Age))
qplot(yr_month, Percent, data = bmuk, colour = Age) # proof of concept

bmuk <- rename(bmuk, Year = yr_month)
bmuk$Year <- gsub("-01-01", "", bmuk$Year) 
bmuk$Year <- as.numeric(bmuk$Year)

qplot(Year, Percent, data = bmuk, colour = Age, geom = "line") +
  scale_color_brewer(type = "qual", guide = guide_legend("Age of\ncyclist\ncasualty")) + ylab("Proportion of incidents") + theme_bw() 

bmuk$Location <- "UK"
bm$Location <- "West Yorkshire"

bmall <- rbind(bm, bmuk)

qplot(Year, Percent, data = bmall, colour = Age, geom = "line") +
  scale_color_brewer(type = "qual", guide = guide_legend("Age of\ncyclist\ncasualty")) + ylab("Proportion of incidents (relative)") + theme_bw() +
  facet_grid( ~ Location)

file.copy("figures/age-band-time-uk.png", "figures/age-band-time-uk-orig.png")
# ggsave("figures/age-band-time-uk.png")
