library("curl") 
library(data.table)


zapis<- function(train,fold){
  library(RCurl)
  library(jsonlite)
  library(data.table)
  library(RJDBC)
  drv <- JDBC("com.mysql.jdbc.Driver",
              "C:/Cronus/mysql-connector-java-5.1.45/mysql-connector-java-5.1.45/mysql-connector-java-5.1.45-bin.jar", "`")
  # "C:/Users/user/Documents/Downloads/sqldeveloper/jdbc/lib/mysql-connector-java-3.1.14/mysql-connector-java-3.1.14-bin.jar", "`")
  
  con <- dbConnect(drv,"jdbc:mysql://185.220.32.98:3306/energo","alex", "ksf8DL347#dkfj45*")
  
  train$DATE_ZALIVA <- Sys.Date()
  train$DATE<- as.Date(train$DATE,"%d.%m .%Y")
  train$DATE <- as.character(train$DATE)
  train$DATE_ZALIVA <- as.character(train$DATE_ZALIVA)
  for(i in 1:nrow(train)){
    req <- paste("INSERT INTO predict_from_gtp (DATE, HOUR, PREDICT_GTP, DATE_ZALIVA,ID_COMPANY,ID_GTP,CITY_ID) VALUES
                 ('",train[i,"DATE"],"',",train[i,"HOUR"],",",ifelse(is.na(train[i,"PREDICT_GTP"]),"NULL",train[i,"PREDICT_GTP"]),",'",train[i,"DATE_ZALIVA"],"'
                 ,",train[i,"ID_COMPANY"],",",train[i,"ID_GTP"],",",train[i,"CITY_ID"],"
                 )"
                 ,sep = "")
    # not run, but do to send your query 
    dbSendUpdate(con,req)
    # print(i/nrow(train))
  }
  
  library(RCurl)
  # setwd("E:/Cronus/Virtual_machine/Base_MYSQL/API_upload_fact")
  fwrite(train[0,.(DATE,HOUR,PREDICT_GTP,ID_COMPANY,ID_GTP,CITY_ID)],"predict_from_gtp.csv",sep = ";")
  ftpUpload("predict_from_gtp.csv",paste0("ftp://api:vfnhbo8934ykfjhg@185.220.32.98/clients/",fold,"/upload/predict_from_gtp.csv"))
  # TODO сделать удаление "ftp://api:vfnhbo8934ykfjhg@185.220.32.98/clients/energoeffect/upload/fact.csv"
  
  dbDisconnect(con)
}



ftp_base <- "ftp://api:vfnhbo8934ykfjhg@185.220.32.98/clients/"
list_files <- curl::new_handle()
curl::handle_setopt(list_files, ftp_use_epsv = TRUE, dirlistonly = TRUE)
con <- curl::curl(url = ftp_base, "r", handle = list_files)
files <- readLines(con)
close(con)


for (fold in files) {
  library("RCurl") 
  print(fold)
  ftp_base <- paste0("ftp://api:vfnhbo8934ykfjhg@185.220.32.98/clients/",fold,"/upload/")
  list_files <- curl::new_handle()
  curl::handle_setopt(list_files, ftp_use_epsv = TRUE, dirlistonly = TRUE)
  con <- curl::curl(url = ftp_base, "r", handle = list_files)
  filess <- readLines(con)
  close(con)
  if (length(filess)==0) {next }
  train<- fread(paste0("ftp://api:vfnhbo8934ykfjhg@185.220.32.98/clients/",fold,"/upload/predict_from_gtp.csv"),dec = ",")
  train<- train[!is.na(FACT)]
  if (exists("train")==F) {next}
  if (nrow(train)<=0) {next}
  try(zapis(train,fold),silent = T)
}
