## analysis of the nts for % trips by bicycle over time
# part of the DutchBikes research project - let's look at monthly responses

ntstrips <- read.spss("/scratch/data/DfT-NTS-2002-2008/UKDA-5340-spss/spss/spss12//trips.sav")
ntstrips <- data.frame(ntstrips)
names(ntstrips)
summary(ntstrips$TRAVDATE)
summary(ntstrips$j36a) / nrow(ntstrips) # 1.7 % trips made by bicycle nationwide 2002-2008
summary(ntstrips$jdungross) # 8 mile = av. trip length
summary(ntstrips$jdungross[which(ntstrips$j36a == "Bicycle")]) # 2.4 mile = average bike trip length

# sorting months out
head(ntstrips$TRAVMM)
levels(ntstrips$TRAVMM)
ntstrips$TRAVMMn <- factor(ntstrips$TRAVMM, labels=c(paste0("0", as.character(1:9)), 10:12) )
head(ntstrips$TRAVMMn)
ntstrips$yearMonth <- paste(ntstrips$TRAVYYYY, ntstrips$TRAVMMn, sep="/")
head(ntstrips$yearMonth)

# percent cycling by monthy
ntpm <- aggregate(ntstrips$TRAVDATE, list(ntstrips$yearMonth), function(x) length(x))
ntpm <- data.frame(ntpm)
head(ntpm)
nbikes <- aggregate(ntstrips$j36, list(ntstrips$yearMonth), function(b) length(which(b == "Bicycle")))[2]
ntpm <- cbind(ntpm, nbikes)
head(ntpm)
ntpm <- cbind(ntpm, ntpm[3] / ntpm[2])
head(ntpm)
plot(ntpm[[1]], ntpm[[4]]) # no pattern - how dissapointing - now try per yr agg.

# percent cycling by yearly
ntpm <- aggregate(ntstrips$TRAVDATE, list(ntstrips$TRAVYYYY), function(x) length(x))
ntpm <- data.frame(ntpm)
head(ntpm)
nbikes <- aggregate(ntstrips$j36, list(ntstrips$TRAVYYYY), function(b) length(which(b == "Bicycle")))[2]
ntpm <- cbind(ntpm, nbikes)
head(ntpm)
ntpm <- cbind(ntpm, ntpm[3] / ntpm[2])
head(ntpm)
plot(ntpm[[1]], ntpm[[4]]) # no pattern - how dissapointing - now try per yr agg.
write.csv(ntpm, "nts/ntpm.csv")

# after adding edited data
(ntpy <- read.csv("nts/ntpm-agg.csv", sep="\t"))
names(ntpy) <- c("Year", "Prop.cycle", "Source")
qplot(data=ntpy, x=Year, y=Prop.cycle * 100, color = Source) + geom_smooth(fill=NA) +
  ylim(c(0,2)) + theme_bw() + ylab("Percentage of trips by bicycle") 
ggsave("~/Dropbox/DutchBikes/figures/nts-time.png")

## color scheme for output
library(RColorBrewer)
myColors <- brewer.pal(4,"Set1")
names(myColors) <- c("Current rate", "Needed rate", "10 yr doubling", "DfT's NTM")
colScale <- scale_colour_manual(name = "Model",values = myColors)

# making hypothetical future data
x <- 1:7
y <- ntpy[14:20,2] * 100
df <- data.frame(cbind(x,y))
lm1 <- lm(y ~ x, data=df)
df2 <- data.frame(x= 2000:2500 -2004)
df2 <- data.frame(x= 2000:2050 -2004)
p1 <- predict(lm1, df2) # 1/2 way there by 2500 at current rate!
df2050 <- data.frame(Year = 2000:2050, prop.cycle = p1, model = "Current rate" )
dfneed <- data.frame(Year = 2000:2050, prop.cycle = c(p1[1:15], seq(1.7,25,length.out=36)), model = "Needed rate" )
df2050 <- rbind(df2050, dfneed)
qplot(data = df2050, x = Year, y = prop.cycle, color = model) + ylab("Percentage of trips by bicycle") +
  theme_bw() + colScale
dfneed[20,2] - dfneed[19,2] # rate of cycling need to grow by 0.67% points pa for next 35 years
# ggsave("~/Dropbox/DutchBikes/figures/nts-time2050.png")

# the real world can be linear http://data.london.gov.uk/datastore/package/cycle-flows-tfl-road-network
rw <- read.csv("lndn-counts.csv")
class(rw$Pedal.Cycle.Counts.Indexed)
plot(1:nrow(rw), rw$Pedal.Cycle.Counts.Indexed)
rw$Year <- seq(2000, 2014, length.out=nrow(rw))
qplot(rw$Year, rw$Pedal.Cycle.Counts.Indexed) + geom_smooth(method=lm, fill = NA) +
  scale_x_continuous(breaks = 2000:2014) + xlab("Year") + ylab("Cycle count index") + 
  theme_bw() 
1.7 / 8
1.7 * 8 # could hit 25% by 2050, just if it's exponential
# ggsave("~/Dropbox/DutchBikes/figures/lnd-linear.png")

# distance cycled
dc <- read.csv("nts/nts0306-avdist.csv", sep = "\t")
dct <- data.frame(Year = ntpy$Year[8:20], Distance = as.numeric(dc[2,2:14]))
plot(dct)
ggplot(dct, aes(x=Year, y=Distance)) + geom_point() + ylab("Distance (miles)") + theme_bw() +
   colScale
# ggsave("~/Dropbox/DutchBikes/figures/avdist.png")

dw <- df2050[15:51,]
dw$model <- "10 yr doubling"
dw$prop.cycle <- 1.7 * (2^(0:36/10))
plot(dw)
df2050 <- rbind(df2050, dw)
qplot(data = df2050, x = Year, y = prop.cycle, color = model) + ylab("Percentage of trips by bicycle") +
  theme_bw() + colScale
# ggsave("~/Dropbox/DutchBikes/figures/doubling.png")

# analysis of DfT's projections:
(106.63 -109.73) / 127 # 2% in 2010
(130.163 - 127.067) / 152
dftntm <- data.frame(Year = 2010:2035, prop.cycle = seq(2.4, 2.04, length.out= 26), model = "DfT's NTM")
df2050 <- rbind(df2050, dftntm)
qplot(data = df2050, x = Year, y = prop.cycle, color = model) + ylab("Percentage of trips by bicycle") +
  theme_bw() + colScale
ggsave("~/Dropbox/DutchBikes/figures/ntm-out.png")


# the logistic growth model
k = 27
B = 1.7
r = 0.15
time = 0:35
lgrowth <- (B * k * exp(r * time)) / (k + B * (exp( r * time) - 1) ) 
plot(lgrowth)
lgrowth <- data.frame(Year = time + 2015, prop.cycle = lgrowth, model = "Logistic")

# redo colors, plot
myColors <- c(brewer.pal(4,"Set1"), "black")
names(myColors) <- c("Current rate", "Needed rate", "10 yr doubling", "DfT's NTM", "Logistic")
colScale <- scale_colour_manual(name = "Model",values = myColors)

df2050 <- rbind(df2050, lgrowth)
ggplot() + geom_point(data = df2050, aes(x = Year, y = prop.cycle, color = model)) + ylab("Percentage of trips by bicycle") +
  theme_bw() + colScale
ggsave("~/Dropbox/DutchBikes/figures/logistic.png")

## histogram of travel distance
nt <- ntstrips[ntstrips$jdungross < 500, ]
nt <- nt[-which(grepl("Other|Non|Tax|Mot|Lond|LT", nt$j36a)), ]
summary(nt$j36a)
nt$j36a <- factor(nt$j36a)
nt$x <- nt$jdungross / 10
# qplot(nt$jdungross, geom='blank') + geom_histogram() +  
#   stat_function(fun = dnorm)
# 
# p0 = qplot(data = nt, x = x, geom = 'blank') +   
#   geom_line(aes(y = ..density.., colour = 'Gaussian'), stat = 'density', adjust = 5, kernel = "gaussian") +  
#   geom_line(aes(y = ..density.., colour = 'Biweight'), stat = 'density', adjust = 5, kernel = "b") +
#   geom_histogram(aes(y = ..density..), alpha = 0.4) +                        
#   scale_colour_manual(name = 'Density', values = c('red', 'blue'))  + 
# #   opts(legend.position = c(0.85, 0.85)) +
#   facet_wrap(. ~ nt$j36a)
# print(p0)
# 
# ggplot(data=nt, aes(x = x)) + geom_histogram() +
#   geom_line(aes(y = ..density..)) + facet_wrap()
ggplot(nt, aes(x=x)) + geom_histogram() + theme_bw() + xlab("Distance (miles)")
ggsave("~/Dropbox/DutchBikes/figures/hist-raw.png")
ggplot(nt, aes(x=x)) + geom_histogram(aes(y = ..density..)) + geom_density(adjust = 10) + theme_bw() + xlab("Distance (miles)")
ggsave("~/Dropbox/DutchBikes/figures/hist-raw-kern.png")

ggplot(nt, aes(x=x, fill=j36a)) + geom_histogram() + theme_bw() + xlab("Distance (miles)")
ggsave("~/Dropbox/DutchBikes/figures/hist-color.png")
ggplot(nt, aes(x=x, fill=j36a)) + geom_density(alpha=.3, adjust = 10) +coord_cartesian(ylim=c(0, 0.4)) + theme_bw() + xlab("Distance (miles)")
ggsave("~/Dropbox/DutchBikes/figures/hist-overlay.png")

summary(nt$j36a)
barplot(summary(nt$j36a))

