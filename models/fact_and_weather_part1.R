library(RJDBC)
library(data.table)
library(mice)
setwd("D:/Cronus/Virtual_machine/R/models")
getwd()

drv <- JDBC("com.mysql.jdbc.Driver",
            "C:/Users/user/Documents/Downloads/sqldeveloper/jdbc/lib/mysql-connector-java-3.1.14/mysql-connector-java-3.1.14-bin.jar", "`")

con <- dbConnect(drv,"jdbc:mysql://185.220.32.98:3306/energo","alex", "ksf8DL347#dkfj45*")
zapros <- "select  a.DATE as DATE_FACT,a.HOUR as HOUR_FACT,a.FACT
,a.id
,w.DATE
,w.HOUR
,w.dt
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
,f.day_dt
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
end  
left join factory_calendar f
on a.DATE = f.dt "
data<- dbGetQuery(con, zapros)
dbDisconnect(con)

data <- as.data.table(data)
# md.pattern(data)
data[,.(.N),by=.(DATE_FACT,HOUR_FACT)][N>1]
data[,`:=`(N=.N),by=.(DATE_FACT,HOUR_FACT)]
data<- data[,tail(.SD,1),by=.(DATE_FACT,HOUR_FACT)]

data<- copy(data[,.(DATE_FACT,HOUR_FACT,FACT,temp,temp_min,temp_max,
        pressure,sea_level,grnd_level,humidity,weather_id,
        weather_main,weather_description,weather_icon,clouds_all,
        wind_speed,wind_deg,rain_3h,snow_3h,day_dt
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
      
      'broken_clouds' = as.numeric(weather_description=="broken clouds"),
      'drizzle' = as.numeric(weather_description=="drizzle"),
      'few_clouds' = as.numeric(weather_description=="few clouds"),
      'fog' = as.numeric(weather_description=="fog"),
      'haze' = as.numeric(weather_description=="haze"),
      'heavy_intensity_drizzle' = as.numeric(weather_description=="heavy intensity drizzle"),
      'heavy_intensity_rain' = as.numeric(weather_description=="heavy intensity rain"),
      'heavy_intensity_rain_and_drizzle' = as.numeric(weather_description=="heavy intensity rain and drizzle"),
      'heavy_snow' = as.numeric(weather_description=="heavy snow"),
      'light_intensity_drizzle' = as.numeric(weather_description=="light intensity drizzle"),
      'light_intensity_drizzle_rain' = as.numeric(weather_description=="light intensity drizzle rain"),
      'light_rain' = as.numeric(weather_description=="light rain"),
      'light_rain_and_snow' = as.numeric(weather_description=="light rain and snow"),
      'mist' = as.numeric(weather_description=="mist"),
      'moderate_rain' = as.numeric(weather_description=="moderate rain"),
      'overcast_clouds' = as.numeric(weather_description=="overcast clouds"),
      'proximity_thunderstorm' = as.numeric(weather_description=="proximity thunderstorm"),
      'scattered_clouds' = as.numeric(weather_description=="scattered clouds"),
      'sky_is_clear' = as.numeric(weather_description=="sky is clear"),
      'thunderstorm' = as.numeric(weather_description=="thunderstorm"),
      'thunderstorm_with_heavy_rain' = as.numeric(weather_description=="thunderstorm with heavy rain"),
      'thunderstorm_with_light_rain' = as.numeric(weather_description=="thunderstorm with light rain"),
      'thunderstorm_with_rain' = as.numeric(weather_description=="thunderstorm with rain"),
      'very_heavy_rain' = as.numeric(weather_description=="very heavy rain")
      

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
 
 data$HOUR_FACT_0<-ifelse(test = data$HOUR_FACT==1,yes = 1,no = 0)
 data$HOUR_FACT_1<-ifelse(test = data$HOUR_FACT==2,yes = 1,no = 0)
 data$HOUR_FACT_2<-ifelse(test = data$HOUR_FACT==3,yes = 1,no = 0)
 data$HOUR_FACT_3<-ifelse(test = data$HOUR_FACT==4,yes = 1,no = 0)
 data$HOUR_FACT_4<-ifelse(test = data$HOUR_FACT==5,yes = 1,no = 0)
 data$HOUR_FACT_5<-ifelse(test = data$HOUR_FACT==6,yes = 1,no = 0)
 data$HOUR_FACT_6<-ifelse(test = data$HOUR_FACT==7,yes = 1,no = 0)
 data$HOUR_FACT_7<-ifelse(test = data$HOUR_FACT==8,yes = 1,no = 0)
 data$HOUR_FACT_8<-ifelse(test = data$HOUR_FACT==9,yes = 1,no = 0)
 data$HOUR_FACT_9<-ifelse(test = data$HOUR_FACT==10,yes = 1,no = 0)
 data$HOUR_FACT_10<-ifelse(test = data$HOUR_FACT==11,yes = 1,no = 0)
 data$HOUR_FACT_11<-ifelse(test = data$HOUR_FACT==12,yes = 1,no = 0)
 data$HOUR_FACT_12<-ifelse(test = data$HOUR_FACT==13,yes = 1,no = 0)
 data$HOUR_FACT_13<-ifelse(test = data$HOUR_FACT==14,yes = 1,no = 0)
 data$HOUR_FACT_14<-ifelse(test = data$HOUR_FACT==15,yes = 1,no = 0)
 data$HOUR_FACT_15<-ifelse(test = data$HOUR_FACT==16,yes = 1,no = 0)
 data$HOUR_FACT_16<-ifelse(test = data$HOUR_FACT==17,yes = 1,no = 0)
 data$HOUR_FACT_17<-ifelse(test = data$HOUR_FACT==18,yes = 1,no = 0)
 data$HOUR_FACT_18<-ifelse(test = data$HOUR_FACT==19,yes = 1,no = 0)
 data$HOUR_FACT_19<-ifelse(test = data$HOUR_FACT==20,yes = 1,no = 0)
 data$HOUR_FACT_20<-ifelse(test = data$HOUR_FACT==21,yes = 1,no = 0)
 data$HOUR_FACT_21<-ifelse(test = data$HOUR_FACT==22,yes = 1,no = 0)
 data$HOUR_FACT_22<-ifelse(test = data$HOUR_FACT==23,yes = 1,no = 0)
 data$HOUR_FACT_23<-ifelse(test = data$HOUR_FACT==24,yes = 1,no = 0)
 
 data$HOUR_FACT <- NULL
 
 
 
 
 con <- dbConnect(drv,"jdbc:mysql://185.220.32.98:3306/energo","alex", "ksf8DL347#dkfj45*")
 zapros <- "SELECT year(dt) as year,month(dt) as month,max(day(dt)) as day FROM energo.factory_calendar
group by month(dt),year(dt)
order by 1,2"
 datemax<- dbGetQuery(con, zapros)
 dbDisconnect(con)
 

 
 data[,`:=`( 
   year2=as.numeric(format(DATE_FACT,"%Y")),
   mont2=as.numeric(format(DATE_FACT,"%m")),
   day2=as.numeric(format(DATE_FACT,"%d"))
 )]
 
 
 
 data<- merge(data,datemax,by.x=c("year2","mont2"),by.y=c("year","month"),all.x = T,all.y = F)[,`:=`(p_day=day2/day)]
 data$year2 <- NULL
 data$mont2 <- NULL
 data$day2 <- NULL
 data$day <- NULL


 data[,`:=`(
   day_1= as.numeric(as.numeric(format(DATE_FACT,"%d"))==1),
   day_2= as.numeric(as.numeric(format(DATE_FACT,"%d"))==2),
   day_3= as.numeric(as.numeric(format(DATE_FACT,"%d"))==3),
   day_4= as.numeric(as.numeric(format(DATE_FACT,"%d"))==4),
   day_5= as.numeric(as.numeric(format(DATE_FACT,"%d"))==5),
   day_6= as.numeric(as.numeric(format(DATE_FACT,"%d"))==6),
   day_7= as.numeric(as.numeric(format(DATE_FACT,"%d"))==7),
   day_8= as.numeric(as.numeric(format(DATE_FACT,"%d"))==8),
   day_9= as.numeric(as.numeric(format(DATE_FACT,"%d"))==9),
   day_10= as.numeric(as.numeric(format(DATE_FACT,"%d"))==10),
   day_11= as.numeric(as.numeric(format(DATE_FACT,"%d"))==11),
   day_12= as.numeric(as.numeric(format(DATE_FACT,"%d"))==12),
   day_13= as.numeric(as.numeric(format(DATE_FACT,"%d"))==13),
   day_14= as.numeric(as.numeric(format(DATE_FACT,"%d"))==14),
   day_15= as.numeric(as.numeric(format(DATE_FACT,"%d"))==15),
   day_16= as.numeric(as.numeric(format(DATE_FACT,"%d"))==16),
   day_17= as.numeric(as.numeric(format(DATE_FACT,"%d"))==17),
   day_18= as.numeric(as.numeric(format(DATE_FACT,"%d"))==18),
   day_19= as.numeric(as.numeric(format(DATE_FACT,"%d"))==19),
   day_20= as.numeric(as.numeric(format(DATE_FACT,"%d"))==20),
   day_21= as.numeric(as.numeric(format(DATE_FACT,"%d"))==21),
   day_22= as.numeric(as.numeric(format(DATE_FACT,"%d"))==22),
   day_23= as.numeric(as.numeric(format(DATE_FACT,"%d"))==23),
   day_24= as.numeric(as.numeric(format(DATE_FACT,"%d"))==24),
   day_25= as.numeric(as.numeric(format(DATE_FACT,"%d"))==25),
   day_26= as.numeric(as.numeric(format(DATE_FACT,"%d"))==26),
   day_27= as.numeric(as.numeric(format(DATE_FACT,"%d"))==27),
   day_28= as.numeric(as.numeric(format(DATE_FACT,"%d"))==28),
   day_29= as.numeric(as.numeric(format(DATE_FACT,"%d"))==29),
   day_30= as.numeric(as.numeric(format(DATE_FACT,"%d"))==30),
   day_31= as.numeric(as.numeric(format(DATE_FACT,"%d"))==31)
 )]
 
 DATE_FACT<- data$DATE_FACT
 data$DATE_FACT <- NULL
 
 
 data[,`:=`(
   short_day= as.numeric(day_dt=="short day"),
   weekend= as.numeric(day_dt=="weekend"),
   work_plan= as.numeric(day_dt=="work")
    )]
 data$day_dt <- NULL
 
 f_dowle2 = function(DT) {
   for (i in names(DT))
     DT[is.na(get(i)), (i):=-9999]
 }
 
f_dowle2(data)

lag <- 24*7

anscols = paste("lag", 24:lag, sep="_")
cols <- "FACT"
data[,(anscols):=shift(.SD, 24:lag, 0, "lag"),.SDcols=cols][]
data<- copy(data[(lag+1):nrow(data),])



get_pca2 <- function(test_data,name){
  fit <- prcomp(test_data[,-name,with=F])   
  save(fit,file="fit_pca.rda")
  cum_prop <- summary(fit)$importance['Cumulative Proportion',]    
  test_data <- cbind(test_data, fit$x)    
  return(test_data)    
}

data<- get_pca2(data,"FACT")


transform_x = function(data)
{
  do_transform = function(x, lambd) {
    if (lambd > 0) x ^ lambd else if (lambd < 0) -(x ^ lambd) else log(x) }
  
  x_data = data[,2]
  y_data = data[,1]
  lambdas = round(seq(-5, 5, 0.1)[-61],1)
  corrs = sapply(lambdas, 
                 function(lambd) cor(do_transform(x_data, lambd), y_data))
  lambda = lambdas[which.max(abs(corrs))]
  return(lambda)
}



nc<- ncol(data)

for(i in 2:(nc)) {print(i)
  if(all(data[,i,with = F]==-9999)==T){next}
  if(all(data[,i,with = F]==0)==T){next}
  data <- cbind(data,subset(data,select = i)^transform_x(subset(data,select = c(1,i)))
  )
  names(data)[ncol(data)] <- paste0(names(data)[i],"^",transform_x(subset(data,select = c(1,i))))
}

data<-copy(data[,round(.SD,4)])

del_name<- data[,lapply(.SD,function(x){length(unique(x))>1})]
data<- data[,which(t(del_name)),with=F]
names(data)
write(names(data),"names.txt")
fwrite(data,"data.csv")



