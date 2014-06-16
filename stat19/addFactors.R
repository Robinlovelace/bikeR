# Adding factors
library(XLConnect)
library(rJava)

wb <- loadWorkbook("Road-Accident-Safety-Data-Guide-1979-2004.xls" )
wb <- readWorksheet(wb, sheet = getSheets(wb))
names(wb)  <- sub(" ", ".", names(wb))
names(wb)  <- sub(" ", ".", names(wb))
names(wb)  <- sub("1", ".", names(wb))
names(wb)  <- sub("- ", ".", names(wb))
names(wb)  <- sub(" ", ".", names(wb))
names(wb)


# Let's see which data need to become factors (1st for cyclists in WY, then everywhere):
# summary(ac)
ac$Accident_Sf <- factor(ac$Accident_Severity, labels = wb$Accident.Severity$label)
plot(ac$Accident_Sf)
summary(ac$Accident_Sf)

# Police force
summary(ac$Police_Force)
ac$Police_Ff <- factor(ac$Police_Force, labels = wb$Police.Force$label[1]) # Not tested on full dataset
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
ac$Road_Tf <- factor(ac$Road_Type, labels = wb$Road.Type$label[]) # didnt' work...
wb$Road.Type$label[unique(ac$Road_Type)]
wb$Road.Type$label[-unique(ac$Road_Type)]
ac$Road_Tf <- factor(ac$Road_Type, labels = wb$Road.Type$label[1:6]) # didnt' work...
summary(ac$Road_Tf)
qplot(ac$Road_Tf) + xlab("Type of road") + ylab("Count") + 
  theme(axis.text.x = element_text(angle=20, color = "black"),
        panel.background = element_rect(fill = "white"),
        panel.grid.major.y = element_line(color = "grey", linetype=3)) 
colors()
ggsave("~/Desktop/roadtype.png")

wb$Junction.Detail
unique(ac$Junction_Detail)
summary(as.factor(ac$Junction_Detail))
plot(ac$Junction_Detail)
ac$Junction_Df <- factor( ac$Junction_Detail, labels = wb$Junction.Detail$label[c(10, 1:9)] )
qplot(ac$Junction_Df) + bikeR_theme_1
ggsave("~/Desktop/junctiondetail.png")

summary(ac$Speed_limit) # speed limit is fine

wb$Ped.Cross..Human # human crossing - not that interesting
wb$Ped.Cross..Physical # not hugely interesting atm

wb$Light.Conditions # light conditions - disproportionately dangerous @ night?
summary(as.factor(ac$Light_Conditions)) # ok - no unknown factors (rm -1)
ac$Light_f <- factor(ac$Light_Conditions, labels = wb$Light.Conditions$label[1:5])
qplot(ac$Light_f) + bikeR_theme_1
ggsave("~/Desktop/lightconds.png")

wb$Weather
summary(as.factor(ac$Weather_Conditions))
ac$Weather <- factor(ac$Weather_Conditions, labels = wb$Weather$label[c(10, 1:9)])
qplot(ac$Weather) + bikeR_theme_1
ggsave("~/Desktop/weather.png")

wb$Road.Surface
summary(as.factor(ac$Road_Surface_Conditions))
ac$Road_Surface <- factor(ac$Road_Surface_Conditions, label = wb$Road.Surface$label[c(8, 1:5)])
qplot(ac$Road_Surface) + bikeR_theme_1
ggsave("~/Desktop/roadsurface.png")

wb$Special.Conditions.at.Site # Interesting but one to save for later
wb$Carriageway.Hazards # Again v. interesting - add later

# Now for vehicle type
nrow(vt) / nrow(ac) # average of almost 2 vehicles per incident: reasonable
summary(as.factor(vt$Vehicle_Type))
wb$Vehicle.Type
(tfact <- wb$Vehicle.Type$label[ as.character(wb$Vehicle.Type$code) %in% levels(as.factor(vt$Vehicle_Type)) ])
tfact[c(20, 1:19)]
vt$Vehicle_Tf <- factor(vt$Vehicle_Type, labels=tfact[c(20, 1:19)])
summary(vt$Vehicle_Tf)
qplot(vt$Vehicle_Tf) + bikeR_theme_1
ggsave("~/Desktop/vtype.png")

summary(as.factor(vt$Vehicle_Manoeuvre))
wb$Vehicle.Manoeuvre
vt$Vehicle_Manf <- factor(vt$Vehicle_Manoeuvre, labels = wb$Vehicle.Manoeuvre$label[c(19,1:18)])
qplot(vt$Vehicle_Manf) + bikeR_theme_1
ggsave("~/Desktop/vmanoeuvre.png")

summary(as.factor(vt$Journey_Purpose_of_Driver))
wb$Journey.Purpose
vt$Journey_Purpose <- factor(vt$Journey_Purpose_of_Driver, labels = wb$Journey.Purpose$label[c(8,1:7)])
qplot(vt$Journey_Purpose) + bikeR_theme_1
ggsave("~/Desktop/vpurpose.png")

summary(as.factor(vt$Sex_of_Driver ))
wb$Sex.of.Driver
vt$Sex_Driver_f <- factor(vt$Sex_of_Driver , labels = wb$Sex.of.Driver$label[c(4,1:3)])
qplot(vt$Sex_Driver_f ) + bikeR_theme_1
ggsave("~/Desktop/sexdriver.png")

summary(as.factor(vt$Age_Band_of_Driver ))
wb$Age.Band
vt$Age_Band <- factor(vt$Age_Band_of_Driver , labels = c("na", wb$Age.Band$label[c(11,1:10)]))
qplot(vt$Age_Band ) + bikeR_theme_1
ggsave("~/Desktop/sexdriver.png")

summary(as.factor(vt$Driver_IMD_Decile ))
wb$IMD.Decile
vt$Driver_IMD <- factor(vt$Driver_IMD_Decile , labels = c(wb$IMD.Decile$label[c(11,1:10)]))
qplot(vt$Driver_IMD ) + bikeR_theme_1
ggsave("~/Desktop/dimd.png")

summary(as.factor(vt$Driver_Home_Area_Type )) # potentially interesting but not priority

########################################################################################
########################################################################################

names(ca) # identify casualty variables
nrow(ca) / nrow(ac) # 1.3 casualties per incident: reasonable
summary(as.factor(ca$Casualty_Class))
wb$Casualty.Class # OK this is interesting: how many cyclists hit pedestrians?
ca$Casualty_Class_f <- factor(ca$Casualty_Class, labels = wb$Casualty.Class$label)
qplot(ca$Casualty_Class_f) + bikeR_theme_1
ggsave("~/Desktop/casualtyclass.png")

summary(as.factor(ca$Sex_of_Casualty))
wb$Sex.of.Casualty # Does it correspond to cyclist?
ca$Sex_Casualty <- factor(ca$Sex_of_Casualty, labels = wb$Sex.of.Casualty$label[c(3,1,2)])
qplot(ca$Sex_Casualty) + bikeR_theme_1
ggsave("~/Desktop/casualtysex.png")

summary(as.factor(ca$Age_Band_of_Casualty))
wb$Age.Band #
ca$Age_Band_Cf <- factor(ca$Age_Band_of_Casualty, labels = c("na", wb$Age.Band$label[c(1:11)]))
qplot(ca$Age_Band_Cf) + bikeR_theme_1
ggsave("~/Desktop/casualtyage.png")

summary(as.factor(ca$Casualty_Severity))
wb$Casualty.Severity # OK this is interesting: how many cyclists hit pedestrians?
ca$Severity <- factor(ca$Casualty_Severity, labels = wb$Casualty.Severity$label)
qplot(ca$Severity) + bikeR_theme_1
ggsave("~/Desktop/casualtysex.png")

summary(as.factor(ca$Casualty_Type))
wb$Casualty.Type[,] # Same as cyclist?
ca$Type <- factor(ca$Casualty_Type , labels = wb$Casualty.Type$label[c(1:17, 19:21)])
qplot(ca$Type) + bikeR_theme_1
ggsave("~/Desktop/casualtytype.png")


