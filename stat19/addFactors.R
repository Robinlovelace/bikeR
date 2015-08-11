# Adding factors
library(XLConnect)
library(rJava)

wb <- loadWorkbook("Road-Accident-Safety-Data-Guide-1979-2004.xls" )
wb <- readWorksheet(wb, sheet = getSheets(wb))
#
names(wb)  <- sub(" ", ".", names(wb))
names(wb)  <- sub(" ", ".", names(wb))
names(wb)  <- sub("1", ".", names(wb))
names(wb)  <- sub("- ", ".", names(wb))
names(wb)  <- sub(" ", ".", names(wb))
names(wb) <- sub(".-.", ".", names(wb))
# names(wb)
# save(wb, file = "wb.RData")
load("wb.RData")

# Let's see which data need to become factors (1st for cyclists in WY, then everywhere):
# summary(ac)
ac$Accident_Sf <- factor(ac$Accident_Severity, labels = wb$Accident.Severity$label)
plot(ac$Accident_Sf)

table(ac$Accident_Sf, ac$Number_of_Vehicles)

summary(ac$Accident_Sf)

# Police force
summary(ac$Police_Force)
summary(wb$Police.Force)
levels(factor(ac$Police_Force))

ac$Police_Ff <- factor(ac$Police_Force, labels = wb$Police.Force$label) # Not tested on full dataset
summary(ac$Police_Ff)
plot(ac$Police_Ff)

# Road class
head(wb$.st.Road.Class)
summary(ac$X1st_Road_Class)
ac$X1st_Road_Cf <- factor(ac$X1st_Road_Class, labels = wb$.st.Road.Class$label)
summary(ac$X1st_Road_Cf)
plot(ac$X1st_Road_Cf)

# Road type (roundabouts etc)
wb$Road.Type # This is v. useful
summary(ac$Road_Type); unique(ac$Road_Type)
# ac$Road_Tf <- factor(ac$Road_Type, labels = wb$Road.Type$label[]) # didnt' work...
wb$Road.Type$label[unique(ac$Road_Type)]
wb$Road.Type$label[-unique(ac$Road_Type)]
ac$Road_Tf <- factor(ac$Road_Type, labels = wb$Road.Type$label[1:6]) # worked
summary(ac$Road_Tf)
qplot(ac$Road_Tf) + xlab("Type of road") + ylab("Count") +
  theme(axis.text.x = element_text(angle=20, color = "black"),
        panel.background = element_rect(fill = "white"),
        panel.grid.major.y = element_line(color = "grey", linetype=3))
head(colors())
# ggsave("~/Desktop/roadtype.png")

wb$Junction.Detail
unique(ac$Junction_Detail)
summary(as.factor(ac$Junction_Detail))
# plot(ac$Junction_Detail) # time consuming and uninformative plot
# ac$Junction_Df <- factor( ac$Junction_Detail, labels = wb$Junction.Detail$label[c(, 1:9)] ) # fail
ac$Junction_Df <- factor( ac$Junction_Detail, labels = wb$Junction.Detail$label[c(10, 1:9)] )
# levels(ac$Junction_Df)[c(1,4,7,8)] <- c("Not at junction", "T junction", "Multi-junction", "Private drive") # fail
summary(ac$Junction_Df)

source("stat19/plotting.R")

qplot(data=ac, x = Junction_Df) + bikeR_theme_1
# qplot(data = ac, x = Junction_Df) + facet_grid( cyclist ~., scales="free") + bikeR_theme_1
table(ac$Junction_Df, ac$Urban_or_Rural_Area)
colSums(table(ac$Junction_Df, ac$cyclist))
round(prop.table(table(ac$Junction_Df, ac$cyclist), margin=2) * 100, 1)
library(knitr)
kable(round(prop.table(table(ac$Junction_Df, ac$cyclist), margin=2) * 100, 1))
acSerious <- ac[ ac$Accident_Sf == "Serious" , ]
# kable(round(prop.table(table(acSerious$Junction_Df, acSerious$cyclist), margin=2) * 100, 1))
# acDeath <- ac[ ac$Accident_Sf == "Fatal" , ]
# kable(round(prop.table(table(acDeath$Junction_Df, acDeath$cyclist), margin=2) * 100, 1))

# ggsave("~/Desktop/junctiondetail.png")

summary(ac$Speed_limit) # speed limit is fine

wb$Ped.Cross.Human # human crossing - not that interesting
wb$Ped.Cross.Physical # human crossing - not that interesting

wb$Light.Conditions # light conditions - disproportionately dangerous @ night?
summary(as.factor(ac$Light_Conditions)) # ok - no unknown factors (rm -1)
ac$Light_f <- factor(ac$Light_Conditions, labels = wb$Light.Conditions$label[1:5])
qplot(ac$Light_f) + bikeR_theme_1
# ggsave("~/Desktop/lightconds.png")
kable(round(prop.table(table(ac$Light_f, ac$cyclist), margin=2) * 100, 1))
kable(round(prop.table(table(acSerious$Light_f, acSerious$cyclist), margin=2) * 100, 1))
# kable(round(prop.table(table(acDeath$Light_f, acDeath$cyclist), margin=2) * 100, 1))

wb$Weather
summary(as.factor(ac$Weather_Conditions))
ac$Weather <- factor(ac$Weather_Conditions, labels = wb$Weather$label[c(10, 1:9)])
qplot(ac$Weather) + bikeR_theme_1
# ggsave("~/Desktop/weather.png")

wb$Road.Surface
summary(as.factor(ac$Road_Surface_Conditions))
ac$Road_Surface <- factor(ac$Road_Surface_Conditions, label = wb$Road.Surface$label[c(8, 1:5)])
qplot(ac$Road_Surface) + bikeR_theme_1
# ggsave("~/Desktop/roadsurface.png")

wb$Special.Conditions.at.Site # Interesting but one to save for later
wb$Carriageway.Hazards # Again v. interesting - add later

# Now for vehicle type
nrow(vt) / nrow(ac) # average of almost 2 vehicles per incident: reasonable
summary(as.factor(vt$Vehicle_Type))
levels(vt$Vehicle_Type)
wb$Vehicle.Type
(tfact <- wb$Vehicle.Type$label[ as.character(wb$Vehicle.Type$code) %in% levels(as.factor(vt$Vehicle_Type)) ])
tfact[c(20, 1:19)]
vt$Vehicle_Tf <- factor(vt$Vehicle_Type, labels=tfact[c(20, 1:19, 21)]) # flags error with WY data
# vt$Vehicle_Tf <- factor(vt$Vehicle_Type, labels=tfact)
nrow(cyVt)
summary(vt$Vehicle_Tf)
barplot(summary(vt$Vehicle_Tf))
summary(vt$Vehicle_Tf) / nrow(vt)
qplot(vt$Vehicle_Tf) + bikeR_theme_1
# ggsave("~/Desktop/vtype.png")

# interesting to xtab with gende
summary(as.factor(vt$Vehicle_Manoeuvre))
wb$Vehicle.Manoeuvre
vt$Vehicle_Manf <- factor(vt$Vehicle_Manoeuvre, labels = wb$Vehicle.Manoeuvre$label[c(19,1:18)])
qplot(vt$Vehicle_Manf) + bikeR_theme_1
# ggsave("~/Desktop/vmanoeuvre.png")

summary(as.factor(vt$Journey_Purpose_of_Driver))
wb$Journey.Purpose
vt$Journey_Purpose <- factor(vt$Journey_Purpose_of_Driver, labels = wb$Journey.Purpose$label[c(8,1:7)])
qplot(vt$Journey_Purpose) + bikeR_theme_1
# ggsave("figures/vpurp-2013.png")

summary(as.factor(vt$Sex_of_Driver ))
wb$Sex.of.Driver
vt$Sex_Driver_f <- factor(vt$Sex_of_Driver , labels = wb$Sex.of.Driver$label[c(4,1:3)])
levels(vt$Sex_Driver_f)[1] <- levels(vt$Sex_Driver_f)[4]
qplot(vt$Sex_Driver_f) + bikeR_theme_1
# ggsave("~/Desktop/sexdriver.png")

summary(as.factor(ca$Age_Band_of_Casualty ))
wb$Age.Band
ca$Age_Band <- factor(ca$Age_Band_of_Casualty , labels = c(wb$Age.Band$label[c(11,1:10)]))

ca$ageband <- as.character(ca$Age_Band)
ca$ageband[ grepl("0 - 5|6 - 10", ca$Age_Band)] <- "0 - 10"
ca$ageband[ grepl("56|75", ca$Age_Band)] <- "56+"
summary(factor(ca$ageband))

qplot(ca$Age_Band ) + bikeR_theme_1
# ggsave("figures//agedriver.png")

summary(as.factor(vt$Driver_IMD_Decile ))
wb$IMD.Decile
vt$Driver_IMD <- factor(vt$Driver_IMD_Decile , labels = c(wb$IMD.Decile$label[c(11,1:10)]))
qplot(vt$Driver_IMD ) + bikeR_theme_1
# ggsave("~/Desktop/dimd.png")

summary(as.factor(vt$Driver_Home_Area_Type )) # potentially interesting but not priority

########################################################################################
########################################################################################

names(ca) # identify casualty variables
nrow(ca) / nrow(ac) # 1.3 casualties per incident: reasonable
summary(as.factor(ca$Casualty_Class))
wb$Casualty.Class # OK this is interesting: how many cyclists hit pedestrians?
ca$Casualty_Class_f <- factor(ca$Casualty_Class, labels = wb$Casualty.Class$label)
qplot(ca$Casualty_Class_f) + bikeR_theme_1
# ggsave("~/Desktop/casualtyclass.png")

summary(as.factor(ca$Sex_of_Casualty))
wb$Sex.of.Casualty # Does it correspond to cyclist?
ca$Sex_Casualty <- factor(ca$Sex_of_Casualty, labels = wb$Sex.of.Casualty$label[c(3,1,2)])
levels(ca$Sex_Casualty)[1] <- "Not known"
qplot(ca$Sex_Casualty) + bikeR_theme_1
# ggsave("figures/casualtysex.png")

summary(as.factor(ca$Age_Band_of_Casualty))
wb$Age.Band #
ca$Age_Band_Cf <- factor(ca$Age_Band_of_Casualty, labels = c("na", wb$Age.Band$label[c(1:11)]))
qplot(ca$Age_Band_Cf) + bikeR_theme_1
# ggsave("~/Desktop/casualtyage.png")

summary(as.factor(ca$Casualty_Severity))
wb$Casualty.Severity # OK this is interesting: how many cyclists hit pedestrians?
ca$CSeverity <- factor(ca$Casualty_Severity, labels = wb$Casualty.Severity$label)
qplot(ca$CSeverity) + bikeR_theme_1
# ggsave("~/Desktop/casualtysex.png")

summary(as.factor(ca$Casualty_Type))
ca$Casualty_Type <- as.factor(ca$Casualty_Type)
wb$Casualty.Type[,] # Same as cyclist?
levels(ca$Casualty_Type)
ca_type_labs <-
  wb$Casualty.Type$label[match(levels(ca$Casualty_Type), (wb$Casualty.Type$code))]


# ca$Type <- factor(ca$Casualty_Type , labels = wb$Casualty.Type$label[c(1:17, 19:21)]) # old
ca$Type <- factor(ca$Casualty_Type , labels = ca_type_labs) # new
summary(ca$Type)
summary(ca$Type) / nrow(ca)
qplot(ca$Type) + bikeR_theme_1
# ggsave("~/Desktop/casualtytype.png")
# save.image("/media/SAMSUNG/repos/bikeR/exclude/all_ac_processed+WY.RData")
# load("/media/SAMSUNG/repos/bikeR/exclude/all_ac_processed+WY.RData")

### additional factors


## out-takes

### attempt with gdata
# wb <- sheetNames("Road-Accident-Safety-Data-Guide-1979-2004.xls")
# wb  <- sub(" ", ".", wb)
# wb  <- sub(" ", ".", wb)
# wb  <- sub("1", ".", wb)
# wb  <- sub("- ", ".", wb)
# wb  <- sub(" ", ".", wb)
# wb
# wbN <- sheetNames("Road-Accident-Safety-Data-Guide-1979-2004.xls")
#
# wb <- as.list(wb)
#
# for(i in 1:length(wb)){
#   print(wbN[i])
#   wb$
#   wb <- read.xls("Road-Accident-Safety-Data-Guide-1979-2004.xls", sheet=wbN[i])
# }
# wbA <- read.xls("Road-Accident-Safety-Data-Guide-1979-2004.xls", sheet=wb[4])
# wb

summary(as.factor(ca$Age_Band_of_Casualty ))
age_cas_factor <- wb$Age.Band$label[match(wb$Age.Band$code, levels(as.factor(ca$Age_Band_of_Casualty )))]
wb$Age.Band
vt$Age.Band <- factor(vt$Age_Band_of_Driver , labels = c(NA, age_cas_factor))

qplot(vt$Age.Band ) + bikeR_theme_1

