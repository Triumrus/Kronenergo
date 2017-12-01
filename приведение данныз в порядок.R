library(RJDBC)
library(data.table)
library(mice)
drv <- JDBC("com.mysql.jdbc.Driver",
            "C:/Users/user/Documents/Downloads/sqldeveloper/jdbc/lib/mysql-connector-java-3.1.14/mysql-connector-java-3.1.14-bin.jar", "`")

con <- dbConnect(drv,"jdbc:mysql://185.220.32.98:3306/energo","alex", "ksf8DL347#dkfj45*")
zapros <- "select  a.DATE as DATE_FACT,a.HOUR as HOUR_FACT,a.FACT
,a.id
,w.DATE
,w.HOUR
,dt
,dt_iso
,city_id
,city_name
,lat
,lon
,temp
,temp_min
,temp_max
,pressure
,sea_level
,grnd_level
,humidity
,wind_speed
,wind_deg
,rain_1h
,rain_3h
,rain_24h
,rain_today
,snow_1h
,snow_3h
,snow_24h
,snow_today
,clouds_all
,weather_id
,weather_main
,weather_description
,weather_icon
,dt_iso_2
,w.id  
FROM energo.fact_energoeffect a

inner join (
SELECT max(id) as id FROM energo.fact_energoeffect
group by DATE,HOUR) b
on a.id=b.id

left join (SELECT DATE(dt_iso_2) as DATE,HOUR(dt_iso_2) as HOUR,we.dt
,dt_iso
,city_id
,city_name
,lat
,lon
,temp
,temp_min
,temp_max
,pressure
,sea_level
,grnd_level
,humidity
,wind_speed
,wind_deg
,rain_1h
,rain_3h
,rain_24h
,rain_today
,snow_1h
,snow_3h
,snow_24h
,snow_today
,clouds_all
,weather_id
,weather_main
,weather_description
,weather_icon
,dt_iso_2
,id  
,@quot as lag_quot
,@quot:=(HOUR(dt_iso_2)+1) curr_quote
,@quot2 as lag_quot2
,@quot2:=(HOUR(dt_iso_2)+2) curr_quote2
FROM  (
select a.* 
from energo.historical_data_weather a
inner join (
select max(id) as id
from energo.historical_data_weather
group by dt_iso_2) b
on a.id=b.id

) we
join (select @quot= -1 ) r
join (select @quot= -2 ) r2

order by dt_iso_2
) w
on a.DATE=w.DATE and a.HOUR = 
case 
when a.HOUR = w.HOUR then  w.HOUR
when a.HOUR != w.HOUR and a.HOUR != w.curr_quote then  w.curr_quote2
when a.HOUR != w.HOUR  then  w.curr_quote
end  "
data<- dbGetQuery(con, zapros)
# dbDisconnect(con)

data <- as.data.table(data)
# md.pattern(data)
data[,.(.N),by=.(DATE_FACT,HOUR_FACT)][N>1]
data[,`:=`(N=.N),by=.(DATE_FACT,HOUR_FACT)]
data<- data[,tail(.SD,1),by=.(DATE_FACT,HOUR_FACT)]

data<- copy(data[,.(DATE_FACT,HOUR_FACT,FACT,temp,temp_min,temp_max,
        pressure,sea_level,grnd_level,humidity,weather_id,
        weather_main,weather_description,weather_icon,clouds_all,
        wind_speed,wind_deg,rain_3h,snow_3h
        )])

data
data$DATE_FACT <- as.Date(data$DATE_FACT,'%Y-%m-%d')
data$weather_main <- as.factor(data$weather_main)
data$weather_description <- as.factor(data$weather_description)
data$weather_icon <- as.factor(data$weather_icon)
data$sea_level <- as.numeric(data$sea_level)
data$grnd_level <- as.numeric(data$grnd_level)
data$dayly<-as.factor(format(data$DATE_FACT,'%A'))
data$month<-as.factor(format(data$DATE_FACT,'%B'))
data$work<-ifelse(data$dayly == 'суббота',0,ifelse(data$dayly == 'воскресенье',0,1))
data[210:220,]
for (i in which(is.na(data$temp))) {print(i)
data[i,4:19] <- data[i-1,4:19]
}
# from kelvin to Celsius
data$temp <- data$temp - 273.15
data$temp_min <- data$temp_min - 273.15
data$temp_max <- data$temp_max - 273.15


 data[,`:=`(
Clouds = as.numeric(weather_main=="Clouds"),
Clear = as.numeric(weather_main=="Clear"),
Fog = as.numeric(weather_main=="Fog"),
Mist = as.numeric(weather_main=="Mist"),
Rain= as.numeric(weather_main=="Rain"),
Drizzle= as.numeric(weather_main=="Drizzle"),
Snow= as.numeric(weather_main=="Snow"),
Thunderstorm= as.numeric(weather_main=="Thunderstorm"),
Haze= as.numeric(weather_main=="Haze")
)
]
 data$weather_main <- NULL

 data[,`:=`(
   cod_200 = as.numeric(weather_id==200),
   cod_201 = as.numeric(weather_id==201),
   cod_202 = as.numeric(weather_id==202),
   cod_211 = as.numeric(weather_id==211),
   cod_300 = as.numeric(weather_id==300),
   cod_301 = as.numeric(weather_id==301),
   cod_302 = as.numeric(weather_id==302),
   cod_310 = as.numeric(weather_id==310),
   cod_312 = as.numeric(weather_id==312),
   cod_500 = as.numeric(weather_id==500),
   cod_501 = as.numeric(weather_id==501),
   cod_502 = as.numeric(weather_id==502),
   cod_503 = as.numeric(weather_id==503),
   cod_602 = as.numeric(weather_id==602),
   cod_615 = as.numeric(weather_id==615),
   cod_701 = as.numeric(weather_id==701),
   cod_721 = as.numeric(weather_id==721),
   cod_741 = as.numeric(weather_id==741),
   cod_800 = as.numeric(weather_id==800),
   cod_801 = as.numeric(weather_id==801),
   cod_802 = as.numeric(weather_id==802),
   cod_803 = as.numeric(weather_id==803),
   cod_804 = as.numeric(weather_id==804)
 )]
 data$weather_id <- NULL
 
 
 data[,`:=`(
      
      'broken clouds' = as.numeric(weather_description=="broken clouds"),
      'drizzle' = as.numeric(weather_description=="drizzle"),
      'few clouds' = as.numeric(weather_description=="few clouds"),
      'fog' = as.numeric(weather_description=="fog"),
      'haze' = as.numeric(weather_description=="haze"),
      'heavy intensity drizzle' = as.numeric(weather_description=="heavy intensity drizzle"),
      'heavy intensity rain' = as.numeric(weather_description=="heavy intensity rain"),
      'heavy intensity rain and drizzle' = as.numeric(weather_description=="heavy intensity rain and drizzle"),
      'heavy snow' = as.numeric(weather_description=="heavy snow"),
      'light intensity drizzle' = as.numeric(weather_description=="light intensity drizzle"),
      'light intensity drizzle rain' = as.numeric(weather_description=="light intensity drizzle rain"),
      'light rain' = as.numeric(weather_description=="light rain"),
      'light rain and snow' = as.numeric(weather_description=="light rain and snow"),
      'mist' = as.numeric(weather_description=="mist"),
      'moderate rain' = as.numeric(weather_description=="moderate rain"),
      'overcast clouds' = as.numeric(weather_description=="overcast clouds"),
      'proximity thunderstorm' = as.numeric(weather_description=="proximity thunderstorm"),
      'scattered clouds' = as.numeric(weather_description=="scattered clouds"),
      'sky is clear' = as.numeric(weather_description=="sky is clear"),
      'thunderstorm' = as.numeric(weather_description=="thunderstorm"),
      'thunderstorm with heavy rain' = as.numeric(weather_description=="thunderstorm with heavy rain"),
      'thunderstorm with light rain' = as.numeric(weather_description=="thunderstorm with light rain"),
      'thunderstorm with rain' = as.numeric(weather_description=="thunderstorm with rain"),
      'very heavy rain' = as.numeric(weather_description=="very heavy rain")
      

 )]
 
 data$weather_description <- NULL
 
 data[,`:=`(
 i01d =  as.numeric(weather_icon=="01d"),
 i01n =  as.numeric(weather_icon=="01n"),
 i02 =  as.numeric(weather_icon=="02"),
 i02d =  as.numeric(weather_icon=="02d"),
 i02n =  as.numeric(weather_icon=="02n"),
 i03 =  as.numeric(weather_icon=="03"),
 i03d =  as.numeric(weather_icon=="03d"),
 i03n =  as.numeric(weather_icon=="03n"),
 i04 =  as.numeric(weather_icon=="04"),
 i04d =  as.numeric(weather_icon=="04d"),
 i04n =  as.numeric(weather_icon=="04n"),
 i09d =  as.numeric(weather_icon=="09d"),
 i09n =  as.numeric(weather_icon=="09n"),
 i10d =  as.numeric(weather_icon=="10d"),
 i10n =  as.numeric(weather_icon=="10n"),
 i11d =  as.numeric(weather_icon=="11d"),
 i11n =  as.numeric(weather_icon=="11n"),
 i13d =  as.numeric(weather_icon=="13d"),
 i13n =  as.numeric(weather_icon=="13n"),
 i50d =  as.numeric(weather_icon=="50d"),
 i50n =  as.numeric(weather_icon=="50n")
 )]
 
 data$weather_icon <- NULL
 
 data[,`:=`(
   Monday= as.numeric(dayly=="понедельник"),
   Tuesday= as.numeric(dayly=="вторник"),
   Wednesday= as.numeric(dayly=="среда"),
   Thursday= as.numeric(dayly=="четверг"),
   Friday= as.numeric(dayly=="пятница"),
   Saturday= as.numeric(dayly=="суббота"),
   Sunday= as.numeric(dayly=="воскресенье")
 )]
 
 data$dayly <- NULL
 
 data[,`:=`(
   January= as.numeric(month=="Январь"),
   February= as.numeric(month=="Февраль"),
   March= as.numeric(month=="Март"),
   April= as.numeric(month=="Апрель"),
   May= as.numeric(month=="Май"),
   June= as.numeric(month=="Июнь"),
   July= as.numeric(month=="Июль"),
   August= as.numeric(month=="Август"),
   September= as.numeric(month=="Сентябрь"),
   October= as.numeric(month=="Октябрь"),
   November= as.numeric(month=="Ноябрь"),
   December= as.numeric(month=="Декабрь")
 )]
 
 data$month <- NULL

 
