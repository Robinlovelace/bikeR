# who hit who? - builds on who to look at driver + injured party

head(b[1:10])
names(b)
summary(b$Engine_Capacity_.CC.) # shows that there is NO car data in here - delete half variables
b <- b[-34]
names(b)
summary(b$Driver_IMD_Decile)
names(b)[ grepl("IMD", names(b))]
summary(b$Driver_IMD)
summary(b$Type)
summary(b$Journey_Purpose) # Yes we have purpose of trip of cyclists - crap tho it is...
summary(as.factor(b$Journey_Purpose_of_Driver)) # the original data
summary(b$Casualty_Class_f) # 39 people in West Yorkshire were cycle passengers
b$Casualty_Severity <- factor(b$Casualty_Severity, labels = wb$Casualty.Severity$label)
summary(b$Casualty_Severity)
summary(b$Severity)
summary(b$Casualty_Home_Area_Type)
summary(b$Age_of_Vehicle)
summary(b$Sex_of_Casualty)
summary(b$Sex_Driver_f)
summary(b$Sex_Casualty) # weird - driver reported as different sex in 5 cases
summary(b)

b <- b[-c(8:12, 20:30, 32:39, 47:50)]
summary(b)

# Get drivers in there
head(vt[ vt$Acc_Index %in% b$Accident_Index, 1:5])
vtInB <- vt[ vt$Acc_Index %in% b$Accident_Index, ]
nrow(vtInB) / nrow(b) # almost double number of vehicles as bicyles
summary(vtInB$Vehicle_Tf)  
vtBH <- vtInB[ -which(vtInB$Vehicle_Tf == "Pedal cycle"), ]
nrow(vtBH) / nrow(b) # almost double number of vehicles as bicyles
vtBH <- rename(vtBH, c("Acc_Index" = "Accident_Index"))
b <- join(b, vtBH, by="Accident_Index", match="first")
names(b)
duplicated(names(b))
b$Driver_IMD.1[ b$Driver_IMD.1 == "Data missing or out of range"] <- NA
b$Driver_IMD[ b$Driver_IMD == "Data missing or out of range"] <- NA
b$Driver_IMD.1[ b$Driver_IMD.1 == "NA's"] <- NA
b$Driver_IMD <- factor(b$Driver_IMD)
b$Driver_IMD.1 <- factor(b$Driver_IMD.1)
s1 <- summary(b$Driver_IMD)
s2 <- summary(b$Driver_IMD)
dfIMD <- data.frame(IMD = names(s1), who = rep("Driver", length(names(s1))), n = as.numeric(s1))
dfIMD2 <- data.frame(IMD = names(s2), who = rep("Cyclist", length(names(s2))), n = as.numeric(s2))
dfIMD3 <- rbind(dfIMD, dfIMD2) 
qplot(data= dfIMD3, x = IMD, y = n, fill = who, geom = "bar", position="dodge") + bikeR_theme_1 +
  xlab("IMD score of home") + ylab("Number") + scale_fill_discrete(name="")
# ggsave("figures/IMD1.png")

summary(b$Vehicle_Tf) # the real-deal: who hit the bicycle?
b$Vehicle_Tf2 <- factor(b$Vehicle_Tf)
qplot(b$Vehicle_Tf2) + bikeR_theme_1
# ggsave("/tmp/whodunit.png")
