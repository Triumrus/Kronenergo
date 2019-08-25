library(RJDBC)
library(data.table)
library(mice)
library(stringr)
library(xgboost)
library(RRF)
setwd("C:/Users/trium/Downloads/R test")
getwd()

drv <- JDBC("com.mysql.jdbc.Driver",
            "E:/Cronus/mysql-connector-java-5.1.45/mysql-connector-java-5.1.45/mysql-connector-java-5.1.45-bin.jar", "`")
# "C:/Users/user/Documents/Downloads/sqldeveloper/jdbc/lib/mysql-connector-java-3.1.14/mysql-connector-java-3.1.14-bin.jar", "`")

con <- dbConnect(drv,"jdbc:mysql://185.220.32.98:3306/energo","alex", "ksf8DL347#dkfj45*")
zapros <- "
SELECT * FROM energo.data_predict
where ID_COMPANY = 5
and ID_GTP = 3
"

data<- dbGetQuery(con, zapros)
dbDisconnect(con)

data <- as.data.table(data)
data
# md.pattern(data)
data[,.(.N),by=.(DATE,HOUR)][N>1]
data[,`:=`(N=.N),by=.(DATE,HOUR)]
data<- data[,tail(.SD,1),by=.(DATE,HOUR)]

ID_COMPANY<- data$ID_COMPANY
ID_GTP<- data$ID_GTP
date_pred <- data$DATE
CITY_ID <- unique(data$CITY_ID)

data<- copy(data[,.(DATE,HOUR,FACT,temp,temp_min,temp_max,
                    pressure,sea_level,grnd_level,humidity,speed,deg,rain,
                    snow,alll,weather_id,main,description,icon,day_dt
)])


data$DATE <- as.Date(data$DATE,'%Y-%m-%d')
data$main <- as.factor(data$main)
data$description <- as.factor(data$description)
data$icon <- as.factor(data$icon)
data$sea_level <- as.numeric(data$sea_level)
data$grnd_level <- as.numeric(data$grnd_level)
Sys.setlocale("LC_TIME", "C")
data$dayly<-as.factor(format(data$DATE,'%A'))
data$month<-as.factor(format(data$DATE,'%B'))
data$work<-ifelse(data$dayly == 'Saturday',0,ifelse(data$dayly == 'Sunday',0,1))

for (i in which(is.na(data$temp))) {print(i)
  data[i,4:19] <- data[i-1,4:19]
}

# data[,lapply(.SD,function(x){all(is.na(x))})]



# from kelvin to Celsius
# data$temp <- data$temp - 273.15
# data$temp_min <- data$temp_min - 273.15
# data$temp_max <- data$temp_max - 273.15


data[,`:=`(
  Clouds = as.numeric(main=="Clouds"),
  Clear = as.numeric(main=="Clear"),
  Fog = as.numeric(main=="Fog"),
  Mist = as.numeric(main=="Mist"),
  Rain= as.numeric(main=="Rain"),
  Drizzle= as.numeric(main=="Drizzle"),
  Snow= as.numeric(main=="Snow"),
  Thunderstorm= as.numeric(main=="Thunderstorm"),
  Haze= as.numeric(main=="Haze")
)
]
data$main <- NULL

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
  
  'broken_clouds' = as.numeric(description=="broken clouds"),
  'drizzle' = as.numeric(description=="drizzle"),
  'few_clouds' = as.numeric(description=="few clouds"),
  'fog' = as.numeric(description=="fog"),
  'haze' = as.numeric(description=="haze"),
  'heavy_intensity_drizzle' = as.numeric(description=="heavy intensity drizzle"),
  'heavy_intensity_rain' = as.numeric(description=="heavy intensity rain"),
  'heavy_intensity_rain_and_drizzle' = as.numeric(description=="heavy intensity rain and drizzle"),
  'heavy_snow' = as.numeric(description=="heavy snow"),
  'light_intensity_drizzle' = as.numeric(description=="light intensity drizzle"),
  'light_intensity_drizzle_rain' = as.numeric(description=="light intensity drizzle rain"),
  'light_rain' = as.numeric(description=="light rain"),
  'light_rain_and_snow' = as.numeric(description=="light rain and snow"),
  'mist' = as.numeric(description=="mist"),
  'moderate_rain' = as.numeric(description=="moderate rain"),
  'overcast_clouds' = as.numeric(description=="overcast clouds"),
  'proximity_thunderstorm' = as.numeric(description=="proximity thunderstorm"),
  'scattered_clouds' = as.numeric(description=="scattered clouds"),
  'sky_is_clear' = as.numeric(description=="sky is clear"),
  'thunderstorm' = as.numeric(description=="thunderstorm"),
  'thunderstorm_with_heavy_rain' = as.numeric(description=="thunderstorm with heavy rain"),
  'thunderstorm_with_light_rain' = as.numeric(description=="thunderstorm with light rain"),
  'thunderstorm_with_rain' = as.numeric(description=="thunderstorm with rain"),
  'very_heavy_rain' = as.numeric(description=="very heavy rain")
  
  
)]

data$description <- NULL

data[,`:=`(
  i01d =  as.numeric(icon=="01d"),
  i01n =  as.numeric(icon=="01n"),
  i02 =  as.numeric(icon=="02"),
  i02d =  as.numeric(icon=="02d"),
  i02n =  as.numeric(icon=="02n"),
  i03 =  as.numeric(icon=="03"),
  i03d =  as.numeric(icon=="03d"),
  i03n =  as.numeric(icon=="03n"),
  i04 =  as.numeric(icon=="04"),
  i04d =  as.numeric(icon=="04d"),
  i04n =  as.numeric(icon=="04n"),
  i09d =  as.numeric(icon=="09d"),
  i09n =  as.numeric(icon=="09n"),
  i10d =  as.numeric(icon=="10d"),
  i10n =  as.numeric(icon=="10n"),
  i11d =  as.numeric(icon=="11d"),
  i11n =  as.numeric(icon=="11n"),
  i13d =  as.numeric(icon=="13d"),
  i13n =  as.numeric(icon=="13n"),
  i50d =  as.numeric(icon=="50d"),
  i50n =  as.numeric(icon=="50n")
)]

data$icon <- NULL

data[,`:=`(
  Monday= as.numeric(dayly=="Monday"),
  Tuesday= as.numeric(dayly=="Tuesday"),
  Wednesday= as.numeric(dayly=="Wednesday"),
  Thursday= as.numeric(dayly=="Thursday"),
  Friday= as.numeric(dayly=="Friday"),
  Saturday= as.numeric(dayly=="Saturday"),
  Sunday= as.numeric(dayly=="Sunday")
)]

data$dayly <- NULL

data[,`:=`(
  January= as.numeric(month=="January"),
  February= as.numeric(month=="February"),
  March= as.numeric(month=="March"),
  April= as.numeric(month=="April"),
  May= as.numeric(month=="May"),
  June= as.numeric(month=="June"),
  July= as.numeric(month=="July"),
  August= as.numeric(month=="August"),
  September= as.numeric(month=="September"),
  October= as.numeric(month=="October"),
  November= as.numeric(month=="November"),
  December= as.numeric(month=="December")
)]

data$month <- NULL

data$HOUR_0<-ifelse(test = data$HOUR==0,yes = 1,no = 0)
data$HOUR_1<-ifelse(test = data$HOUR==1,yes = 1,no = 0)
data$HOUR_2<-ifelse(test = data$HOUR==2,yes = 1,no = 0)
data$HOUR_3<-ifelse(test = data$HOUR==3,yes = 1,no = 0)
data$HOUR_4<-ifelse(test = data$HOUR==4,yes = 1,no = 0)
data$HOUR_5<-ifelse(test = data$HOUR==5,yes = 1,no = 0)
data$HOUR_6<-ifelse(test = data$HOUR==6,yes = 1,no = 0)
data$HOUR_7<-ifelse(test = data$HOUR==7,yes = 1,no = 0)
data$HOUR_8<-ifelse(test = data$HOUR==8,yes = 1,no = 0)
data$HOUR_9<-ifelse(test = data$HOUR==9,yes = 1,no = 0)
data$HOUR_10<-ifelse(test = data$HOUR==10,yes = 1,no = 0)
data$HOUR_11<-ifelse(test = data$HOUR==11,yes = 1,no = 0)
data$HOUR_12<-ifelse(test = data$HOUR==12,yes = 1,no = 0)
data$HOUR_13<-ifelse(test = data$HOUR==13,yes = 1,no = 0)
data$HOUR_14<-ifelse(test = data$HOUR==14,yes = 1,no = 0)
data$HOUR_15<-ifelse(test = data$HOUR==15,yes = 1,no = 0)
data$HOUR_16<-ifelse(test = data$HOUR==16,yes = 1,no = 0)
data$HOUR_17<-ifelse(test = data$HOUR==17,yes = 1,no = 0)
data$HOUR_18<-ifelse(test = data$HOUR==18,yes = 1,no = 0)
data$HOUR_19<-ifelse(test = data$HOUR==19,yes = 1,no = 0)
data$HOUR_20<-ifelse(test = data$HOUR==20,yes = 1,no = 0)
data$HOUR_21<-ifelse(test = data$HOUR==21,yes = 1,no = 0)
data$HOUR_22<-ifelse(test = data$HOUR==22,yes = 1,no = 0)
data$HOUR_23<-ifelse(test = data$HOUR==23,yes = 1,no = 0)

# data$HOUR <- NULL




con <- dbConnect(drv,"jdbc:mysql://185.220.32.98:3306/energo","alex", "ksf8DL347#dkfj45*")
zapros <- "SELECT year(dt) as year,month(dt) as month,max(day(dt)) as day FROM energo.factory_calendar
group by month(dt),year(dt)
order by 1,2"
datemax<- dbGetQuery(con, zapros)
dbDisconnect(con)



data[,`:=`( 
  year2=as.numeric(format(DATE,"%Y")),
  mont2=as.numeric(format(DATE,"%m")),
  day2=as.numeric(format(DATE,"%d"))
)]



data<- merge(data,datemax,by.x=c("year2","mont2"),by.y=c("year","month"),all.x = T,all.y = F)[,`:=`(p_day=day2/day)]
data$year2 <- NULL
data$mont2 <- NULL
data$day2 <- NULL
data$day <- NULL


data[,`:=`(
  day_1= as.numeric(as.numeric(format(DATE,"%d"))==1),
  day_2= as.numeric(as.numeric(format(DATE,"%d"))==2),
  day_3= as.numeric(as.numeric(format(DATE,"%d"))==3),
  day_4= as.numeric(as.numeric(format(DATE,"%d"))==4),
  day_5= as.numeric(as.numeric(format(DATE,"%d"))==5),
  day_6= as.numeric(as.numeric(format(DATE,"%d"))==6),
  day_7= as.numeric(as.numeric(format(DATE,"%d"))==7),
  day_8= as.numeric(as.numeric(format(DATE,"%d"))==8),
  day_9= as.numeric(as.numeric(format(DATE,"%d"))==9),
  day_10= as.numeric(as.numeric(format(DATE,"%d"))==10),
  day_11= as.numeric(as.numeric(format(DATE,"%d"))==11),
  day_12= as.numeric(as.numeric(format(DATE,"%d"))==12),
  day_13= as.numeric(as.numeric(format(DATE,"%d"))==13),
  day_14= as.numeric(as.numeric(format(DATE,"%d"))==14),
  day_15= as.numeric(as.numeric(format(DATE,"%d"))==15),
  day_16= as.numeric(as.numeric(format(DATE,"%d"))==16),
  day_17= as.numeric(as.numeric(format(DATE,"%d"))==17),
  day_18= as.numeric(as.numeric(format(DATE,"%d"))==18),
  day_19= as.numeric(as.numeric(format(DATE,"%d"))==19),
  day_20= as.numeric(as.numeric(format(DATE,"%d"))==20),
  day_21= as.numeric(as.numeric(format(DATE,"%d"))==21),
  day_22= as.numeric(as.numeric(format(DATE,"%d"))==22),
  day_23= as.numeric(as.numeric(format(DATE,"%d"))==23),
  day_24= as.numeric(as.numeric(format(DATE,"%d"))==24),
  day_25= as.numeric(as.numeric(format(DATE,"%d"))==25),
  day_26= as.numeric(as.numeric(format(DATE,"%d"))==26),
  day_27= as.numeric(as.numeric(format(DATE,"%d"))==27),
  day_28= as.numeric(as.numeric(format(DATE,"%d"))==28),
  day_29= as.numeric(as.numeric(format(DATE,"%d"))==29),
  day_30= as.numeric(as.numeric(format(DATE,"%d"))==30),
  day_31= as.numeric(as.numeric(format(DATE,"%d"))==31)
)]

DATE<- data$DATE
datedata<- data$DATE 
# data$DATE <- NULL


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

anscols = paste("lag", 1:lag, sep="_")
cols <- "FACT"
data[,(anscols):=shift(.SD, 1:lag, -9999, "lag"),.SDcols=cols][]

name <- read.table("names.txt")
name<- name$V1
name <- as.character(name)
which(!names(data)%in%name)
which(!name%in%names(data))
data<- data[,which(names(data)%in%name),with=F]
names_data <- names(data)

# names(data) <- c("FACT",paste0("V",2:ncol(data)))

#murmask atomsbt

#

DATE <- data$DATE
HOUR <- data$HOUR
data$DATE <- NULL
data$HOUR <- NULL


load("C:/Users/trium/Downloads/R test/atomsbt_5_3.rda")


N_unknow<- data[FACT==-9999,.N]


datainbase<- data[,.(PREDICT=-9999,DATE=DATE,HOUR=HOUR,ID_COMPANY=ID_COMPANY,ID_GTP=ID_GTP)]

for (i in ((nrow(data)-N_unknow)+1):nrow(data)) {
  datainbase$PREDICT[i] <- predict(clf2,data.matrix(data[i,-"FACT"]),ntreelimit = clf2$best_iteration)
  data$FACT[i]<- predict(clf2,data.matrix(data[i,-"FACT"]),ntreelimit = clf2$best_iteration)
  data[,(anscols):=shift(.SD, 1:lag, -9999, "lag"),.SDcols=cols]
}

datainbase<- tail(datainbase,168)
datainbase$DATE_ZALIVA <- as.character(as.Date(Sys.Date(),"YYYY-MM-DD"))
datainbase$DATE <- as.character(datainbase$DATE)
# datainbase$DATE_ZALIVA <- as.character(datainbase$DATE_ZALIVA)


drv <- JDBC("com.mysql.jdbc.Driver",
            "E:/Cronus/mysql-connector-java-5.1.45/mysql-connector-java-5.1.45/mysql-connector-java-5.1.45-bin.jar", "`")
# "C:/Users/user/Documents/Downloads/sqldeveloper/jdbc/lib/mysql-connector-java-3.1.14/mysql-connector-java-3.1.14-bin.jar", "`")

con <- dbConnect(drv,"jdbc:mysql://185.220.32.98:3306/energo","alex", "ksf8DL347#dkfj45*")
check_zap<- paste("SELECT * FROM energo.PREDICT_ENERGO
                  where ID_COMPANY = 5 and ID_GTP = 3 and DATE >=",min(datainbase$DATE)," order by id desc limit 24")
check <- dbGetQuery(con, check_zap)
check<- as.data.table(check)
check<- check[order(ID)]
if (nrow(check) != 0) {if(all(round(check$PREDICT,4)%in%round(tail(datainbase$PREDICT,168),4))){q("no")} }

for(i in 1:nrow(datainbase)){
  req <- paste("INSERT INTO PREDICT_ENERGO (PREDICT,DATE,HOUR,ID_COMPANY,ID_GTP,DATE_ZALIVA) VALUES
               (",ifelse(is.na(datainbase[i,1]),"NULL",datainbase[i,1]),",
               '",ifelse(is.na(datainbase[i,2]),"NULL",datainbase[i,2]),"',
               ",ifelse(is.na(datainbase[i,3]),"NULL",datainbase[i,3]),",
               ",ifelse(is.na(datainbase[i,4]),"NULL",datainbase[i,4]),",
               ",ifelse(is.na(datainbase[i,5]),"NULL",datainbase[i,5]),",
               '",ifelse(is.na(datainbase[i,6]),"NULL",datainbase[i,6]),"'
               )"
               ,sep = "")
  # not run, but do to send your query 
  dbSendUpdate(con,req)
  print(i/nrow(datainbase))
}

library(RCurl)

fwrite(datainbase[,.(DATE,HOUR,PREDICT,ID_COMPANY,ID_GTP,CITY_ID=CITY_ID)],"predict.csv",sep = ';',dec = ',')
ftpUpload("predict.csv", "ftp://api:vfnhbo8934ykfjhg@185.220.32.98/clients/marem/predict/predict.csv")

dbDisconnect(con)



