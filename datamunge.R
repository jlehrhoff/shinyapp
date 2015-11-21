library(dplyr)
library(ggmap)
library(timeDate)
library(shiny)

###########################################
## Load, Filter, and Select Weather Data ##
###########################################

weather <- read.csv('data/weather.csv')
weather <- filter(weather, STATION_NAME == "NEW YORK CENTRAL PARK OBS BELVEDERE TOWER NY US")
weather <- select(weather, DATE, PRCP, TMAX, TMIN)
weather$DATE <- as.POSIXct(as.character(weather$DATE), format = "%Y%m%d")

####################
## Load Uber Data ##
####################

uber4 <- read.csv('data/uber-raw-data-apr14.csv', stringsAsFactors = FALSE)
uber4 <- select(uber4, -Base)
ubertest <- head(uber4, 10000)

uber5 <- read.csv('data/uber-raw-data-may14.csv', stringsAsFactors = FALSE)
uber5 <- select(uber5, -Base)

uber6 <- read.csv('data/uber-raw-data-jun14.csv', stringsAsFactors = FALSE)
uber6 <- select(uber6, -Base)

uber7 <- read.csv('data/uber-raw-data-jul14.csv', stringsAsFactors = FALSE)
uber7 <- select(uber7, -Base)

uber8 <- read.csv('data/uber-raw-data-aug14.csv', stringsAsFactors = FALSE)
uber8 <- select(uber8, -Base)

uber9 <- read.csv('data/uber-raw-data-sep14.csv', stringsAsFactors = FALSE)
uber9 <- select(uber9, -Base)


#############################################
## Load Citibike Data, change column names ##
#############################################

citi4 <- read.csv('data/201404-citibike-tripdata.csv', stringsAsFactors = FALSE)
citi4 <- mutate(citi4,Lon = start.station.longitude, Lat = start.station.latitude) %>%
  select(., starttime, Lon, Lat)
cititest <- head(citi4, 10000)

citi5 <- read.csv('data/201405-citibike-tripdata.csv', stringsAsFactors = FALSE)
citi5 <- mutate(citi5,Lon = start.station.longitude, Lat = start.station.latitude) %>%
  select(., starttime, Lon, Lat)

citi6 <- read.csv('data/201406-citibike-tripdata.csv', stringsAsFactors = FALSE)
citi6 <- mutate(citi6,Lon = start.station.longitude, Lat = start.station.latitude) %>%
  select(., starttime, Lon, Lat)

citi7 <- read.csv('data/201407-citibike-tripdata.csv', stringsAsFactors = FALSE)
citi7 <- mutate(citi7,Lon = start.station.longitude, Lat = start.station.latitude) %>%
  select(., starttime, Lon, Lat)

citi8 <- read.csv('data/201408-citibike-tripdata.csv', stringsAsFactors = FALSE)
citi8 <- mutate(citi8,Lon = start.station.longitude, Lat = start.station.latitude) %>%
  select(., starttime, Lon, Lat)

citi9 <- read.csv('data/201409-citibike-tripdata.csv', stringsAsFactors = FALSE)
citi9 <- mutate(citi9,Lon = start.station.longitude, Lat = start.station.latitude) %>%
  select(., starttime, Lon, Lat)

############################################################
## Time Function for Cleaning and Creating Time Variables ##
############################################################

timefunc <- function(df, column, format){
  df$date <- as.POSIXct(column, format = format)
  df$weekend <- sapply(df$date, isWeekend)
  df$time <- format(df$date, format="%H:%M")
  df$DATE <- as.POSIXct(format(df$date, format="%Y-%m-%d"))
  df$morning <- df$time >= "07:00" & df$time < "10:00"
  df$evening <- df$time >= "16:00" & df$time < "19:00"
  df$night <- df$time >= "19:00" & df$time <= "23:59"
  df <- inner_join(df, weather, by="DATE")
  return(df)
}

##################################
## Test and apply Time Function ##
##################################

ubertest <- timefunc(ubertest, ubertest$Date.Time, "%m/%d/%Y %H:%M:%S")
cititest <- timefunc(cititest, cititest$starttime, "%Y-%m-%d %H:%M:%S")

uber4 <- timefunc(uber4, uber4$Date.Time, "%m/%d/%Y %H:%M:%S")
uber5 <- timefunc(uber5, uber5$Date.Time, "%m/%d/%Y %H:%M:%S")
uber6 <- timefunc(uber6, uber6$Date.Time, "%m/%d/%Y %H:%M:%S")
uber7 <- timefunc(uber7, uber7$Date.Time, "%m/%d/%Y %H:%M:%S")
uber8 <- timefunc(uber8, uber8$Date.Time, "%m/%d/%Y %H:%M:%S")
uber9 <- timefunc(uber9, uber9$Date.Time, "%m/%d/%Y %H:%M:%S")

citi4 <- timefunc(citi4, citi4$starttime, "%Y-%m-%d %H:%M:%S")
citi5 <- timefunc(citi5, citi5$starttime, "%Y-%m-%d %H:%M:%S")
citi6 <- timefunc(citi6, citi6$starttime, "%Y-%m-%d %H:%M:%S")
citi7 <- timefunc(citi7, citi7$starttime, "%Y-%m-%d %H:%M:%S")
citi8 <- timefunc(citi8, citi8$starttime, "%Y-%m-%d %H:%M:%S")
citihelp <- timefunc(citi9, citi9$starttime, "%m/%d/%Y %H:%M:%S")

################################
## Overall Ridership Function ##
################################

makeridership <- function(dataset, ridership){
  summarise(group_by(dataset, DATE), 
            count=n(), 
            PRCP=mean(PRCP), 
            TMAX=mean(TMAX), 
            TMIN=mean(TMIN)) %>%
    mutate(., weekend = sapply(.$DATE, isWeekend)) %>%
    rbind(ridership, .)
}

############################################
## Ridership Applied To Uber and Citibike ##
############################################

uberridership <- group_by(uber4, DATE) %>%
  summarise(., count=n(), PRCP=mean(PRCP), TMAX=mean(TMAX), TMIN=mean(TMIN))
uberridership$weekend <- sapply(uberridership$DATE, isWeekend)

uberridership <- makeridership(uber5, uberridership)
uberridership <- makeridership(uber6, uberridership)
uberridership <- makeridership(uber7, uberridership)
uberridership <- makeridership(uber8, uberridership)
uberridership <- makeridership(uber9, uberridership)

citiridership <- group_by(citi4, DATE) %>%
  summarise(., count=n(), PRCP=mean(PRCP), TMAX=mean(TMAX), TMIN=mean(TMIN))
citiridership$weekend <- sapply(citiridership$DATE, isWeekend)

citiridership <- makeridership(citi5, citiridership)
citiridership <- makeridership(citi6, citiridership)
citiridership <- makeridership(citi7, citiridership)
citiridership <- makeridership(citi8, citiridership)
citiridership <- makeridership(citi9, citiridership)

###############################
## Final Ridership Variables ##
###############################

citiridership <- mutate(citiridership, drizzle = PRCP > 0 & PRCP <100, 
                        downpour = PRCP >=100, hot = TMAX>267, ride="Citi")
uberridership <- mutate(uberridership, drizzle = PRCP > 0 & PRCP <100, 
                        downpour = PRCP >=100, hot = TMAX>267, ride="Uber")

###################################################
## Join Ridership data, add month, and summarize ##
###################################################

ridership1 <- rbind(uberridership, citiridership)
ridership1$DATElt <- as.POSIXlt(ridership1$DATE)
ridership1$mon <- ridership1$DATElt$mon+1
ridership1 <- select(ridership1, count, ride, mon)
ridership1 <- group_by(ridership1, ride, mon) %>% summarise(., sum(count))

##################
## Make NYC Map ##
##################

map <- get_map(location = "Columbus Circle", zoom = 12, source = "stamen", 
               scale = c(1200,1200), maptype = "toner")
map1 <- ggmap(map, extent="normal", fullpage = TRUE)

#######################
## Save Cleaned Data ##
#######################

save(citiridership, file = "citiride.Rdata")
save(uberridership, file = "uberride.Rdata")
save(ridership1, file="ridership.Rdata")
save(uber4, citi4, map1, file="uber.Rdata")
save(ubertest, cititest, file="test.Rdata")
