# stat19 analysis for paper
# run after WY.R

# proportion of accidents involving bicycles
head(acWY@data)
plot(acWY$date)
range(acWY$date)

cyAcWY <- acWY[acWY$cyclist == "Cyclist",]
length(which(acWY$cyclist == "Cyclist")) / nrow(acWY)
nrow(cyAc) / nrow(ac)


qs <- qsd <- (max(ac$date) - min(ac$date)) / (8*4) # year quarters, to be used for aggregation
qs <- qs * 1:32 + min(ac$date)
qs.df <- data.frame(qs = qs, quarter = paste(rep(5:12, each = 4), rep(1:4, 8) , sep="."))
qs.df$quarter <- as.character(qs.df$quarter)
nchar(qs.df$quarter)
qs.df$quarter[ nchar(qs.df$quarter) < 4] <- paste0("0", qs.df$quarter[ nchar(qs.df$quarter) < 4])
plot(qs.df$quarter, qs.df$qs,)

# nationwide
for(j in 1:nrow(qs.df)){
  i <- qs.df$qs[j]
  qs.df$prop.bike[j] <- nrow(cyAc@data[ cyAc$date < i & cyAc$date >= (i - qsd) ,] ) / 
    nrow(ac@data[ ac$date < i & ac$date >= (i - qsd) ,])
}

# West Yorkshire
for(j in 1:nrow(qs.df)){
  i <- qs.df$qs[j]
  qs.df$prop.bike[j] <- nrow(cyAcWY@data[ cyAcWY$date < i & cyAcWY$date >= (i - qsd) ,] ) / 
    nrow(acWY@data[ acWY$date < i & acWY$date >= (i - qsd) ,])
}

qs.df
plot(qs.df$prop.bike)
qs.df$q <- paste0("Q", rep(1:4, 8))
qs.df$Season <- "Winter"
qs.df$Season[grepl("2|3", qs.df$q)] <- "Summer"

ggplot(data = qs.df) + geom_point(aes(x = 1:32, y = prop.bike, color = Season)) + 
  geom_smooth(aes(x = 1:32, y = prop.bike, color = Season), fill = NA ) +
#     geom_line(aes(x = 1:32, y = prop.bike, color = Season)) +
  scale_x_discrete(breaks = seq(1,32,4), labels = qs.df$quarter[seq(1,32,4)]) + 
  xlab("Year and quarter") + ylab("Proportion of incidents involving cyclists") +
  theme_classic() +
  ylim(c(0,0.15)) + theme(axis.text=element_text(size=7))
  
ggsave("figures/seasonalityWY.png", height=12, width = 14, units="cm")

mean(qs.df$prop.bike[which(qs.df$Season == "Summer")])
mean(qs.df$prop.bike[which(qs.df$Season == "Winter")])
