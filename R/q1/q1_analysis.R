
library(dplyr)
library(ggplot2)

# import data

master <- read.csv(paste0(getwd(),"/Data/master.csv"))
orientation <- read.csv(paste0(getwd(),"/Data/signupsheet.csv"))
service <- read.csv(paste0(getwd(),"/Data/service.csv"))

# create a dataset that lists each volunteer, 
# their first orientation day, first day in the system,
# first time they logged into the system, and their first 10 shifts

# transform each dataset to "wide" so that there's only one row per volunteer

volunteers <- unique(orientation$ID)
orientation <- reshape(orientation,timevar="orientation",idvar="ID",direction="wide")
service <- service[order(service$ID, service$From.date),]
service$shift <- sequence(rle(as.character(service$ID))$lengths)
service <- reshape(service,timevar="shift",idvar="ID",direction="wide")

# merge all datasets into one master dataset

v.activity <- merge(master,orientation, by="ID")
v.activity <- merge(v.activity,service, by="ID")

# convert dates so that they can be compared

v.activity$Orientation.Date.Primary <- strptime(as.character(v.activity$Orientation.Date.Primary), "%m/%d/%y")
v.activity$Orientation.Date.Secondary <- strptime(as.character(v.activity$Orientation.Date.Secondary), "%m/%d/%y")
v.activity$Date.entered <- strptime(as.character(v.activity$Date.entered), "%m-%d-%Y")
v.activity$Start.date <- strptime(as.character(v.activity$Start.date), "%m-%d-%Y")
v.activity$From.date.1 <- strptime(as.character(v.activity$From.date.1), "%m-%d-%Y")
v.activity$From.date.2 <- strptime(as.character(v.activity$From.date.2), "%m-%d-%Y")
v.activity$From.date.3 <- strptime(as.character(v.activity$From.date.3), "%m-%d-%Y")
v.activity$From.date.4 <- strptime(as.character(v.activity$From.date.4), "%m-%d-%Y")
v.activity$From.date.5 <- strptime(as.character(v.activity$From.date.5), "%m-%d-%Y")

# keep only volunteers who had their first orientation after March 1st, 2017

v.activity <- v.activity[v.activity$Orientation.Date.Primary > "2017-03-01",]

v.activity$t.orientation.to.entered <- difftime(v.activity$Date.entered,
                                                v.activity$Orientation.Date.Primary,
                                                units = "days")
v.activity$t.entered.to.start <- difftime(v.activity$Start.date,
                                                v.activity$Date.entered,
                                                units = "days")
v.activity$start.to.shift1 <- difftime(v.activity$From.date.1,
                                                v.activity$Date.entered,
                                                units = "days")
v.activity$shift1.to.shift2 <- difftime(v.activity$From.date.2,
                                       v.activity$From.date.1,
                                       units = "days")
v.activity$shift2.to.shift3 <- difftime(v.activity$From.date.3,
                                       v.activity$From.date.2,
                                       units = "days")

### what sort of orientations did volunteers participate in? 
v.activity <- v.activity[v.activity$t.orientation.to.entered >0,]
v <- v.activity[,c("ID", "Type.Primary")] %>% count(Type.Primary)
ggplot(v, aes(x = Type.Primary, y = n)) + geom_bar(stat = "identity")

# most volunteers attended the PAC cat orientation, followed by NE, and GF Basic + WD. 

### overall, what is the timeline of a volunteer from orientation, to entered, to started in system, to shift 1?

weird.1 <- v.activity[which(v.activity$start.to.shift1 <0),]
v.activity <- v.activity[which(v.activity$start.to.shift1 >=0),]
mean(v.activity$t.orientation.to.entered)
quantile(v.activity$t.orientation.to.entered)
mean(v.activity$t.entered.to.start)
quantile(v.activity$t.entered.to.start)
mean(v.activity$start.to.shift1)
quantile(v.activity$start.to.shift1)

# the typical volunteer is entered into the system 3 days after orientation, 
# signs up on volgistics the same day,
# and starts their first shift 20 days later.

### by location, what is the timeline of a volunteer from orientation, to entered, to started in system, to shift 1?

v.activity$attended.1 <- ifelse(v.activity$Absence.1 ==1 | 
                                  is.na(v.activity$Absence.1),0,1)
v.activity$attended.2 <- ifelse(v.activity$Absence.2 ==1 | 
                                  is.na(v.activity$Absence.2),0,1)

v <- na.omit(group_by(v.activity[,c("Present.Primary", "Site.1", "attended.1", "attended.2")], 
                    Site.1, Present.Primary, attended.1, attended.2)) %>%
  summarise (n = n()) 

%>%
  mutate(freq = n / sum(n))
  summarise_at(.vars = vars(t.orientation.to.entered,
                            t.entered.to.start,
                            start.to.shift1,
                            shift1.to.shift2,
                            shift2.to.shift3),
               .funs = c(median="median"))

summarise(grouped, mean=mean())

v <- v.activity[,c("ID", "Type.Primary", "t.orientation.to.entered")] %>% 
  mean(t.orientation.to.entered)
ggplot(v, aes(x = Type.Primary, y = n, fill = Assignment.1)) + geom_bar(stat = "identity")


# compute averages
v.activity <- v.activity[which(v.activity$t.orientation.to.entered >=0),]
v.activity <- v.activity[which(v.activity$t.entered.to.start >=0),]
v.activity <- v.activity[which(v.activity$start.to.shift1 >=0),]
v.activity <- v.activity[which(v.activity$shift1.to.shift2 >=0),]
v.activity <- v.activity[which(v.activity$shift2.to.shift3 >=0),]

mean(v.activity$t.orientation.to.entered, na.rm=TRUE)
mean(v.activity$t.entered.to.start, na.rm=TRUE)
mean(v.activity$shift1.to.shift2, na.rm=TRUE)
mean(v.activity$shift2.to.shift3, na.rm=TRUE)