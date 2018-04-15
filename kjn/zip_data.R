require(zipcode)
require(ggplot2)

dspath <- getwd()
df <- read.csv(paste0(dspath, "/Data/master.csv"))
location <- read.csv(paste0(dspath, "/Data/signupsheet.csv"))
location <- location[, c("ID", "Type")]
levels(location$Type) <- c("GF", "GF", "GF", "GF", "GF", "NE", "NE", "PAC", "PAC")
df <- merge(df, location, by = "ID")

ind <- which(colnames(df)=="City" | colnames(df)=="State")
df <- df[, -ind]

df$Zip <- clean.zipcodes(df$Zip)

data(zipcode)

df <- merge(df, zipcode, by.x="Zip", by.y="zip")

df <- df[df$state == "DE" | df$state == "PA" | df$state == "NJ",]

states <- map_data("state", region=c("pennsylvania", "new jersey", "delaware"))
counties <- map_data("county", region=c("pennsylvania", "new jersey", "delaware"))

df$hours.grp <- cut(df$Life.hours, summary(df$Life.hours)[c(1,3,6)], include.lowest=T)
df.map <- df[!is.na(df$hours.grp),]

ggplot() + 
  geom_polygon(data=states, aes(x=long, y=lat, group=group, fill=region), alpha=0.2) +
  geom_path(data=counties, aes(x=long, y=lat, group=group), color="red") +
#  coord_quickmap(xlim=c(-75.7, -74.9), ylim=c(39.7, 40.4)) + #region
  coord_quickmap(xlim=c(-75.4, -74.8), ylim=c(39.8, 40.2)) + #zoom
#  guides(fill=TRUE)
  geom_count(data=df.map, aes(x=longitude, y=latitude, color=hours.grp), 
             alpha=0.5, position="jitter")

df.map <- df[!is.na(df$Type.x),]
ggplot() + 
  geom_polygon(data=states, aes(x=long, y=lat, group=group, fill=region), alpha=0.2) +
  geom_path(data=counties, aes(x=long, y=lat, group=group), color="red") +
  #  coord_quickmap(xlim=c(-75.7, -74.9), ylim=c(39.7, 40.4)) + #region
  coord_quickmap(xlim=c(-75.4, -74.8), ylim=c(39.8, 40.2)) + #zoom
  #  guides(fill=TRUE)
  geom_count(data=df.map, aes(x=longitude, y=latitude, color=Type.x), 
             alpha=0.5, position="jitter")




