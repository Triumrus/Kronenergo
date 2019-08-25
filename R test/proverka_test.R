library("data.table")
library(RJDBC)
library(data.table)
library(mice)
setwd("E:/Cronus/R test")
getwd()
Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre-10.0.1')
drv <- JDBC("com.mysql.jdbc.Driver",
            "E:/Cronus/mysql-connector-java-5.1.45/mysql-connector-java-5.1.45/mysql-connector-java-5.1.45-bin.jar", "`")
# "C:/Users/user/Documents/Downloads/sqldeveloper/jdbc/lib/mysql-connector-java-3.1.14/mysql-connector-java-3.1.14-bin.jar", "`")
con <- dbConnect(drv,"jdbc:mysql://185.220.32.98:3306/energo","alex", "ksf8DL347#dkfj45*")
zapros <- "
select a.* from energo.PREDICT_ENERGO a
inner join (
  SELECT DATE,HOUR,ID_COMPANY,ID_GTP,max(id) as id
  FROM energo.PREDICT_ENERGO
  GROUP BY DATE,HOUR,ID_COMPANY,ID_GTP) b
on a.ID = b.ID
"
predict<- dbGetQuery(con, zapros)

# predict<- fread("C:/Users/trium/Downloads/data.csv")

zapros <- "
select a.* from energo.fact_energoeffect a
inner join (
  SELECT DATE,HOUR,ID_COMPANY,ID_GTP,max(id) as id
  FROM energo.fact_energoeffect
  GROUP BY DATE,HOUR,ID_COMPANY,ID_GTP) b
on a.ID = b.ID
"
fact <- dbGetQuery(con, zapros)

# fact<- fread("C:/Users/trium/Downloads/fact_5_1.csv")
fact$DATE<- as.Date(fact$DATE)
fact$DATE_ZALIVA<- as.Date(fact$DATE_ZALIVA)
str(fact)
str(predict)
predict$DATE <- as.Date(predict$DATE)
predict$DATE_ZALIVA<- as.Date(predict$DATE_ZALIVA)

# fact[,.(.N),by=.(DATE,HOUR,ID_COMPANY,ID_GTP)][N>1]
# fact[,`:=`(N=.N),by=.(DATE,HOUR)]
# fact<- fact[,tail(.SD,1),by=.(DATE,HOUR,ID_COMPANY,ID_GTP)]
# fact
# 
# predict <- predict[PREDICT >= 0]
# predict[,.(.N),by=.(DATE,HOUR,ID_COMPANY,ID_GTP)][N>1]
# predict[,`:=`(N=.N),by=.(DATE,HOUR)]
# predict<- predict[,tail(.SD,1),by=.(DATE,HOUR,ID_COMPANY,ID_GTP)]

# predict<- predict[order(-DATE,-HOUR)]
# predict[ID_COMPANY == 5 & PREDICT < 0]


# predict[DATE=="2018-09-03"]
# fact[DATE=="2018-09-03"]

# fact <- fact[order(-DATE,-HOUR)]
# fact
merger<- merge(fact,predict,by.x = c("DATE","HOUR","ID_COMPANY","ID_GTP"),by.y = c("DATE","HOUR","ID_COMPANY","ID_GTP"),all.x = F,all.y = F)
merger<- as.data.table(merger)
# merger<- merger[order(-DATE,-HOUR)]
merger$month <- month(merger$DATE)
merger[,.(FACT,PREDICT,OTKLONENIE=abs(FACT-PREDICT)),by=.(DATE,HOUR,ID_COMPANY,ID_GTP)]
merger[,.(mean(FACT),mean(PREDICT),OTKLONENIE=sprintf("%f",mean(abs(FACT-PREDICT)/FACT)*100)),by=.(month,ID_COMPANY,ID_GTP)][order(ID_COMPANY)]
merger[,.(avg_fact=mean(FACT),avg_predict=mean(PREDICT),OTKLONENIE=mean(abs(FACT-PREDICT)/FACT)*100),by=.(month,ID_COMPANY,ID_GTP)][order(ID_COMPANY,ID_GTP,month),.(month,ID_COMPANY,ID_GTP,avg_fact,avg_predict,OTKLONENIE=round(OTKLONENIE,2))]

fwrite(finish_test_check[pred!=-9999,.(DATE=V1,HOUR=finish_test_HOUR,FACT=V3,PROGNOZ=pred,OTKLONENIE=abs(V3-pred),OTKLONENIE_procent=abs(V3-pred)/V3)],"finish_test_check.csv",sep = ";",dec = ",")

as.numeric(aa$OTKLONENIE)
round(aaaaa$OTKLONENIE,2)

sprintf("%f", aa$OTKLONENIE)
       