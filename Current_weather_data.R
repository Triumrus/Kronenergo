library(RCurl)
library(jsonlite)
library(data.table)
library(RJDBC)

setwd("D:/Cronus/Virtual_machine/Base_MYSQL/API_weather")
getwd()


# ID всех городов
#  all_city_id <- fromJSON("city.list.json")
#  as.data.table(all_city_id)
#  all_city_id$lon<- all_city_id$coord$lon
#  all_city_id$lat<- all_city_id$coord$lat
# all_city_id$coord <- NULL

# API key
key <- "bab64f8cbd90271f5da08e40a4f4e968"

api_forecatby_id <- "api.openweathermap.org/data/2.5/forecast?id="
city_id <- "797062"

# прогноз на 5 дней по 3 часа
zapros <- paste0(api_forecatby_id,city_id,"&units=metric","&APPID=",key)  
a<- fromJSON(getURL(zapros))

# Информация о городе
city<- unlist(a$city)

# Инфомарция о погоде главная часть
weather_main<- a$list$main

# Инфомарция о погоде погодные условия
weather_weather <- a$list$weather[[1]]
for(i in a$list$weather) {
  weather_weather <- rbind(weather_weather,i)
}
weather_weather <- weather_weather[2:nrow(weather_weather),]
row.names(weather_weather) <- 1:nrow(weather_weather)

# Инфомарция о погоде облачность
weather_clouds<- a$list$clouds

# Инфомарция о погоде скорость ветра
weather_wind <- a$list$wind

# Инфомарция о погоде возможные обьем осадков
weather_rain<- a$list$rain
names(weather_rain) <- "rain"
# НЕЗНАЮ
weather_sys<- a$list$sys

#Инфомарция о погоде Дата и час погоды
weather_data<- data.frame(date=as.Date(a$list$dt_txt,"%Y-%m-%d"),hour=as.character(format(as.POSIXlt(a$list$dt_txt,"%Y-%m-%d %H:%M:%S"),"%H")))

weather<- as.data.table(cbind(weather_data,weather_sys,weather_rain,weather_wind,weather_clouds,weather_weather,weather_main))
weather$pod <- as.factor(weather$pod)
weather$main <- as.factor(weather$main)
weather$description <- as.factor(weather$description)
weather$icon <- as.factor(weather$icon)
str(weather)
rm(list = ls()[ls()!="weather"])
weather$hour <- as.numeric(as.character(weather$hour))
weather2<- copy(weather)
weather2[,hour:=hour+1]
weather3<- copy(weather)
weather3[,hour:=hour+2]
weather
weather2
weather3
weather4<- rbind(weather,weather2,weather3)
weather4<- weather4[order(date,hour)]
weather<- copy(weather4)
rm(list = ls()[ls()!="weather"])
names(weather)<- gsub("^all","alll",names(weather))
names(weather)<- gsub("^id","city_id",names(weather))
weather


drv <- JDBC("com.mysql.jdbc.Driver",
            "C:/Users/user/Documents/Downloads/sqldeveloper/jdbc/lib/mysql-connector-java-3.1.14/mysql-connector-java-3.1.14-bin.jar", "`")

con <- dbConnect(drv,"jdbc:mysql://185.220.32.98:3306/energo","api", "vfnhbo8934ykfjhg")

# Презапись таблицы 
# dbWriteTable(con,"weather",weather)
# dbWriteTable(con,"weather",all_city_id)

weather$date<- as.character(weather$date)
weather$pod<- as.character(weather$pod)
weather$main<- as.character(weather$main)
weather$description<- as.character(weather$description)
weather$icon<- as.character(weather$icon)


for(i in 1:nrow(weather)){
  req <- paste("INSERT INTO weather (date, hour, pod, rain, speed, deg, alll, 
city_id, main, description, icon, temp, temp_min, temp_max, pressure, sea_level,
grnd_level, humidity, temp_kf) VALUES
               ('",weather[i,1],"',",weather[i,2],",'",weather[i,3],"',",ifelse(is.na(weather[i,4]),"NULL",weather[i,4]),",",weather[i,5],","
               ,weather[i,6],",",weather[i,7],",",weather[i,8],",'",weather[i,9],"','",weather[i,10],"','"
               ,weather[i,11],"',",weather[i,12],",",weather[i,13],",",weather[i,14],",",weather[i,15],","
               ,weather[i,16],",",weather[i,17],",",weather[i,18],",",weather[i,19],")",sep = "")
  # not run, but do to send your query 
  dbSendUpdate(con,req)
  print(i/nrow(weather))
}
dbDisconnect(con)

