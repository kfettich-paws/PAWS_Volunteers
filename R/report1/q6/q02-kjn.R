#What is the typical volunteer behavior in the first month? In the first 2 months?
require(dplyr)

dspath <- getwd()
dfMaster <- read.csv(paste0(dspath, "/Data/master.csv"))
dfService <- read.csv(paste0(dspath,"/Data/service.csv"))
dfOrient <- read.csv(paste0(dspath, "/Data/signupsheet.csv"))


dfOrient$Orientation.Date <- as.Date(dfOrient$Orientation.Date, format = "%m/%d/%y")
dfService$From.date  <- as.Date(dfService$From.date, format = "%m-%d-%Y")

shifts <- dfService[order(dfService$From.date), c("ID", "From.date")]
shifts <- group_by(shifts, ID)
shifts <- data.frame(mutate(shifts, count=seq(n())))

# FIRST SHIFT----

shifts.1 <- shifts[shifts$count == 1,]
df.1 <- merge(dfOrient, shifts.1, by="ID")

df.1$diff <- as.numeric(df.1$From.date - df.1$Orientation.Date)
df.1$diff[df.1$diff < 0] <- NA

# SECOND SHIFT----

shifts.2 <- shifts[shifts$count == 2,]
df.2 <- merge(dfOrient, shifts.2, by="ID")

df.2$diff <- as.numeric(df.2$From.date - df.2$Orientation.Date)
df.2$diff[df.2$diff < 0] <- NA


# THIRD SHIFT----

shifts.3 <- shifts[shifts$count == 3,]
df.3 <- merge(dfOrient, shifts.3, by="ID")

df.3$diff <- as.numeric(df.3$From.date - df.3$Orientation.Date)
df.3$diff[df.3$diff < 0] <- NA

# PLOT SHIFT # RELATIVE TO ORIENTATION DATE

ggplot() +
  geom_bar(data=df.1, aes(x=diff), fill="red", alpha=0.5) +
  geom_bar(data=df.2, aes(x=diff), fill="blue", alpha=0.5) +
  geom_bar(data=df.3, aes(x=diff), fill="green", alpha=0.5) +
  xlim(c(0,60))