library(RCurl)
library(jsonlite)
library(data.table)
library(RJDBC)
train<- fread("ftp://login:password@185.220.32.98/clients/energoeffect/upload/fact.csv")



drv <- JDBC("com.mysql.jdbc.Driver",
            "C:/Users/user/Documents/Downloads/sqldeveloper/jdbc/lib/mysql-connector-java-3.1.14/mysql-connector-java-3.1.14-bin.jar", "`")

con <- dbConnect(drv,"jdbc:mysql://185.220.32.98:3306/energo","login", "password")
train$DATE_ZALIVA <- Sys.Date()
train$DATE <- as.character(train$DATE)
train$DATE_ZALIVA <- as.character(train$DATE_ZALIVA)
for(i in 1:nrow(train)){
  req <- paste("INSERT INTO fact_energoeffect (DATE, HOUR, FACT, DATE_ZALIVA) VALUES
               ('",train[i,1],"',",train[i,2],",",ifelse(is.na(train[i,3]),"NULL",train[i,3]),",'",train[i,4],"')"
                                                              ,sep = "")
  # not run, but do to send your query 
  dbSendUpdate(con,req)
  print(i/nrow(train))
}

# TODO сделать удаление "ftp://login:password@185.220.32.98/clients/energoeffect/upload/fact.csv"
dbDisconnect(con)
