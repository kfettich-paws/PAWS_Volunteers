require(zipcode)
require(ggplot2)
require(maps)
require(dplyr)
require(ggmap)


# dspath <- getwd()
# df <- read.csv(paste0(dspath, "/Data/master.csv"))
# location <- read.csv(paste0(dspath, "/Data/signupsheet.csv"))
# location <- location[, c("ID", "Type")]
# levels(location$Type) <- c("GF", "GF", "GF", "GF", "GF", "NE", "NE", "PAC", "PAC")
# df <- merge(df, location, by = "ID")
# 
# ind <- which(colnames(df)=="City" | colnames(df)=="State")
# df <- df[, -ind]
# 
# df$Zip <- clean.zipcodes(df$Zip)

df <- readRDS(paste0(getwd(),"/Data/merged.Rds"))
df <- df %>%
  filter(Orientation.Date.Primary >= "2017-01-01", Orientation.Date.Primary < "2017-09-01")

# create factor for how many shifts attended
df$shifts_attended <- case_when(
  as.numeric(df$total_shifts) <= 0 ~ "no shifts",
  as.numeric(df$total_shifts) <= 1 ~ "1 shift",
  as.numeric(df$total_shifts) <= 9 ~ "2-9 shifts",
  as.numeric(df$total_shifts) > 10 ~ "10+ shifts"
)
df$shifts_attended <- factor(df$shifts_attended,
                                            levels = c("no shifts",
                                                       "1 shift", 
                                                       "2-9 shifts",
                                                       "10+ shifts"))

data(zipcode)
df <- merge(df, zipcode, by.x="Zip", by.y="zip")
df <- df[df$state == "DE" | df$state == "PA" | df$state == "NJ",]

states <- map_data("state", region=c("pennsylvania", "new jersey", "delaware"))
counties <- map_data("county", region=c("pennsylvania", "new jersey", "delaware"))
df <- df[df$city_clean == "Philadelphia",]

bc_bbox <- make_bbox(lat = latitude, lon = longitude, data = df.map)
bc_bbox["left"] <- -75.4
bc_bbox["bottom"] <- 39.91
bc_bbox["right"] <- -74.8
bc_bbox["top"] <- 40.1
phila <- get_map(location = bc_bbox, source = "google", maptype = "roadmap")
ggmap(phila) + 
  geom_point(data = df, mapping = aes(x = longitude, y = latitude, color = shifts_attended))


# from Kristen's code
df.map <- df
ggplot() + 
  geom_polygon(data=states, aes(x=long, y=lat, group=group, fill=region), alpha=0.2) +
  geom_path(data=counties, aes(x=long, y=lat, group=group), color="red") +
  coord_quickmap(xlim=c(-75.4, -74.8), ylim=c(39.8, 40.2)) + 
  geom_count(data=df.map, aes(x=longitude, y=latitude, color=shifts_attended), 
             alpha=0.5, position="jitter")

ggplot() + 
  geom_polygon(data=states, aes(x=long, y=lat, group=group, fill=region), alpha=0.2) +
  geom_path(data=counties, aes(x=long, y=lat, group=group), color="red") +
  #  coord_quickmap(xlim=c(-75.7, -74.9), ylim=c(39.7, 40.4)) + #region
  coord_quickmap(xlim=c(-75.4, -74.8), ylim=c(39.8, 40.2)) + #zoom
  #  guides(fill=TRUE)
  geom_count(data=df.map, aes(x=longitude, y=latitude, color=primary_type), 
             alpha=0.5, position="jitter")




