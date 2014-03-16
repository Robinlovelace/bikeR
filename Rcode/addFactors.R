# Adding factors
library(XLConnect)
library(rJava)
wb <- loadWorkbook("Road-Accident-Safety-Data-Guide-1979-2004.xls" )
wb <- readWorksheet(wb, sheet = getSheets(wb))
names(wb)  <- sub(" ", ".", names(wb))


# Let's see which data need to become factors:
summary(acB)
acB$Accident_Sf <- factor(acB$Accident_Severity, labels = wb$Accident.Severity$label)
plot(acB$Accident_Sf)
summary(acB$Accident_Sf)
acB$Police_Ff <- factor(acB$Police_Force, labels = wb$Police.Force$label) # Not tested on full dataset
summary(acB$Police_Ff)
