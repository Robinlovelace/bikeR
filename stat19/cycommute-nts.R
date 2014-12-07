# library(foreign) # for loading stata files
# library(dplyr) # for fast manipulation of data
# # stages_dat <- read.dta("/media/robin/SAMSUNG/data/UKDA-5340-stata11-2/stata11/stage.dta")
# stages <- read.spss("/media/robin/SAMSUNG/data/UKDA-5340-spss/spss/spss19//stage.sav")
# stages <- as.data.frame(stages)
# names(stages) # which variables are we interested in?
# stages <- select(stages, SurveyYear, StageID, TripID, DayID, IndividualID, HouseholdID, PSUID, VehicleID, StageMode_B04ID, StageDistance, StageTime )
# stages <- rename(stages, mode = StageMode_B04ID, dist_smiles = StageDistance, time_smin = StageTime)
# summary(stages$mode) / nrow(stages) # 1.713 % stages by bicycle

trips <- as.data.frame(read.spss("/media/robin/SAMSUNG/data/UKDA-5340-spss/spss/spss19//trip.sav"))
names(trips)
trips <- select(trips, SurveyYear, TripID, DayID, IndividualID, HouseholdID, PSUID, NumStages, MainMode_B04ID, TripPurpose_B04ID, TripTotalTime, JD)
trips <- rename(trips, modetrp = MainMode_B04ID, purp = TripPurpose_B04ID)
summary(trips$modetrp) / nrow(trips) # 1.719 % trips by bike

# add stage data!
# strips <- inner_join(stages, trips)
# trips <- strips

names(trips)
trips$Mode <- "Other"
trips$Mode[ trips$modetrp == "Bicycle"] <- "Bicycle"
trips$Purpose <- "Other"
trips$Purpose[ trips$purp == "Commuting"] <- "Commuting"

yr <- group_by(trips, SurveyYear, Mode, Purpose)
res <- summarise(yr, dist = mean(JD))
# res <- summarise(yr, dist = mean(dist_smiles))
res$Year <- as.integer(res$SurveyYear)
res$dist <- res$dist * 1.61

library(ggplot2)
qplot(Year, dist, colour = Purpose, data = res, geom = "line") +
  facet_grid( Mode ~ ., scales = "free") + scale_x_continuous(breaks = 2002:2012) + ylab("Average distance of one way trips (km)") +
  theme_bw()

ggsave("figures/Distance-commute.png")
