library(RJDBC)
library(data.table)
library(mice)
setwd("E:/Cronus/R test")
getwd()
data<- fread("data.csv",integer64 = "numeric")
# min (data$FACT)
# data<- data[,c(1:167,204:335),with=F]
# data<- data[,c(1:97,109:259),with=F]
# data<- data[,grep("day",names(data),invert = T),with=F]

# names(data)

data$DATE <- as.Date(data$DATE,'%Y-%m-%d')
data[FACT<0]$FACT <- 0
# del_name<- data[,lapply(.SD,function(x){all(unique(x)!=c(-9999,0))})]
# data<- data[,which(t(del_name)),with=F]
# finish_test <- data[DATE >='2017-04-01'][DATE <'2017-05-01']
nr<- nrow(data)

finish_test <- data[(nr-6*30*24):nr,]
# finish_test <- data[DATE >='2017-04-01']
# data <- data[DATE > '2017-01-01']
# data <- data[DATE < '2017-04-01' | DATE >= '2017-05-01']
# data <- data[DATE < '2017-04-01' ]
# data <- data[DATE > '2017-01-01']
# data <- data[DATE > '2017-05-01']
# data[DATE=='2017-06-01']
# data[DATE=='2017-04-15']

# data <- data[FACT<=685]
# data <- data[FACT>=-151]

finish_test_DATE <- finish_test$DATE
finish_test_HOUR <- finish_test$HOUR
finish_test_FACT <- finish_test$FACT
finish_test$DATE <- NULL
finish_test$HOUR <- NULL



data_DATE <- data$DATE
data_HOUR <- data$HOUR
data$DATE <- NULL
data$HOUR <- NULL

# str(data)
# names(data) <- c("FACT",paste0("V",2:ncol(data)))
# names(finish_test) <- c("FACT",paste0("V",2:ncol(finish_test)))
# name<- read.table("names.txt")
# name<- name$V1
# name <- as.character(name)
# name<- name[3:length(name)]
# data <- data[(nrow(data)-720):nrow(data)]
# train <- data[1:673]
# test <- data[674:721]
# BOOSTRAP
set.seed(777)



sam<- sample(nrow(data),nrow(data),replace = T)
# sam<- sample(nrow(data),nrow(data)*0.7,replace = F)
# train<- data[1:2641,]
# test<- data[2642:2664,]
train <- copy(data[sam,])
test <- copy(data[-sam,])



# train <- data
# data <- as.data.frame(data)
# for (i in 1:ncol(data)) {
#   # print(c(i,any(is.na(data[,i,with=F]))))
#   print(c(i,any(is.infinite(data[,i]))))
#   print(c(i,any(is.na(data[,i]))))
#   print(c(i,any(is.nan(data[,i]))))
#   print(c(i,all(data[,i]==0)))
# }

data <- as.data.frame(data)
for (i in 1:ncol(data)) {
  ifelse(any(is.infinite(data[,i])),names(data[,i,with=F]),next)
}
for (i in 1:ncol(data)) {
  ifelse(any(is.na(data[,i])),names(data[,i,with=F]),next)
}
for (i in 1:ncol(data)) {
  ifelse(any(is.nan(data[,i])),names(data[,i,with=F]),next)
}
for (i in 1:ncol(data)) {
  ifelse(all(data[,i]==0),names(data[,i,with=F]),next)
}
for (i in 1:ncol(data)) {
  ifelse(all(data[,i]==-9999),names(data[,i,with=F]),next)
}
data <- as.data.table(data)

# library(MASS)
# fit_ridge<-lm.ridge(FACT~.,data = train,lambda = seq(0,100,1))
# plot(x = fit_ridge$lambda,y = fit_ridge$GCV,type="o")
# lambda<-fit_ridge$GCV[which.min(fit_ridge$GCV)]
# lamda<-as.numeric(names(lambda))
# fit_ridge<-lm.ridge(FACT~.,data = train,lambda = lamda)
# beta.fit_ridge<-coef(fit_ridge)
# m<-length(coef(fit_ridge))
# 
# all(names(train[,2:ncol(train)])%in%names(beta.fit_ridge[2:m]))
#  # names(train[,-"FACT"][,which(names(train[,2:ncol(train)])%in%names(beta.fit_ridge[2:m])==F),with=F])
#  # names(beta.fit_ridge[2:m])[which(names(train[,2:ncol(train)])%in%names(beta.fit_ridge[2:m])==F)]
# 
# 

# train$ridge <- beta.fit_ridge[1]+as.matrix(train[,-"FACT"])%*%beta.fit_ridge[2:m]
# train[,.(mean(abs(FACT-ridge)))]
# 
# test$ridge <- beta.fit_ridge[1]+as.matrix(test[,-"FACT"])%*%beta.fit_ridge[2:m]
# test[,.(mean(abs(FACT-ridge)))]
# 
# finish_test<- finish_test[,which(names(finish_test)%in%names(train)),with=F]
# 
# finish_test$ridge <- beta.fit_ridge[1]+as.matrix(finish_test[,-"FACT"])%*%beta.fit_ridge[2:m]
# 
# finish_test[,.(mean(abs(FACT-ridge)))]
# 
# cbind(test$FACT,test$ridge)[(which.min(test$ridge)-10):(which.min(test$ridge)+10),]
# t(test[which.min(test$ridge),])
# test[which.min(test$ridge),][,2]
# 
# (cor(cbind(test$FACT,test$ridge))^2)[1,2]
# plot(test$FACT,test$ridge)
# 
# train$ridge <- beta.fit_ridge[1]+as.matrix(train[,-"FACT"])%*%beta.fit_ridge[2:m]
# (cor(cbind(train$FACT,train$ridge))^2)[1,2]
# plot(train$FACT,train$ridge)
# summary(train$ridge)
# summary(train$FACT)
# 
# save(fit_ridge,file="fit_ridge.rda")
# load("fit_ridge.rda")


# XGBOOST liner
library(xgboost)
trainLabel <-  train$FACT
testlabel <- test$FACT
train$FACT <-  NULL
test$FACT <-  NULL

dtrain = xgb.DMatrix(data=data.matrix(train),label=trainLabel,missing = NaN)
dtest = xgb.DMatrix(data=data.matrix(test),label=testlabel,missing = NaN)
watchlist<-list(train=dtrain,test=dtest)


# evalerror <- function(preds, dtrain) {
#   labels <- getinfo(dtrain, "label")
#   err <-(cor(cbind(preds,labels))^2)[1,2]
#     return(list(metric = "R2", value = err))
# }



evalerror <- function(preds, dtrain) {
  # labels <- getinfo(dtrain, "label")
  labels <- getinfo(dtrain, "label")
  err <-mean(abs(preds-labels))
  return(list(metric = "absotkl", value = err))
}

# evalerror <- function(preds, dtrain) {
#   labels <- getinfo(dtrain, "label")
#   err <-mean((abs(preds-labels)/labels)*100)
#   return(list(metric = "otklpercent", value = err))
# }


param <- list(  objective           = "reg:linear",
                booster = "gblinear",
                eval_metric = "mae",
                # eval_metric = evalerror,
                eta                 = 0.3, # 0.06, #0.01,
                max_depth           = 6, #changed from default of 8
                subsample           = 0.7, # 0.7
                colsample_bytree    = 0.7
                
                
                # num_parallel_tree   = 2
                # alpha = 0.0001,
                # lambda = 1
                , lambda_bias = 1
                
)
set.seed(777)
clf2 <- xgb.train(   
                     params              = param,
                     data                = dtrain,
                     nrounds             = 300000,
                     verbose             = 1,
                     early.stop.round    = 150,
                     #feval = normalizedGini,
                     watchlist           = watchlist,
                     maximize            = F
                     
)


data
finish_test
lag <- 24*7

anscols = paste("lag", 1:lag, sep="_")
cols <- "FACT"
# data[,(anscols):=shift(.SD, 1:lag, -9999, "lag"),.SDcols=cols][]
finish_test_check<- as.data.table(cbind(as.character(finish_test_DATE),finish_test_HOUR,finish_test$FACT))
finish_test_check$pred <- -9999
finish_test_check$V3 <- as.numeric(finish_test_check$V3)

for (i in 181:nrow(finish_test)) {
finish_test_check$pred[i] <- predict(clf2,data.matrix(finish_test[i,-"FACT"]),ntreelimit = clf2$best_iteration)
finish_test$FACT[i]<- predict(clf2,data.matrix(finish_test[i,-"FACT"]),ntreelimit = clf2$best_iteration)
ifelse(any(i==seq(181,nrow(finish_test),24)),finish_test$FACT <- finish_test_check$V3,print(i))
finish_test[,(anscols):=shift(.SD, 1:lag, -9999, "lag"),.SDcols=cols][]
  }

# finish_test_check[181:216,]
# finish_test$FACT[181:216]
# finish_test$lag_1[181:217]

# 4317: 2018-06-30               19 7283  7569.523
# 4318: 2018-06-30               20 7097  7561.035

finish_test_check[pred!=-9999][]
finish_test_check[pred!=-9999 & V1 == "2018-08-09"][order(as.integer(finish_test_HOUR),decreasing = T)][,.(pred)]
# finish_test_check[V3==0,`:=`(V3=1)]
finish_test_check[pred!=-9999][V3!=0][,.(abs_otk=mean(abs(V3-pred)),percent=(mean((abs(V3-pred)/V3)*100))),by=month(V1)]
save(clf2,file="tatenergosbyt_8_1.rda")
test$pred_y<- predict(clf2,data.matrix(test),ntreelimit = clf2$best_iteration)

finish_test_check[month(V1)==5]
plot(finish_test_check[month(V1)==5][,.(V3,pred)])
plot(finish_test_check[month(V1)==5]$V3,type="l",col="red")
lines(finish_test_check[month(V1)==5]$pred,col="green")

fwrite(finish_test_check[pred!=-9999,.(DATE=V1,HOUR=finish_test_HOUR,FACT=V3,PROGNOZ=pred,OTKLONENIE=abs(V3-pred),OTKLONENIE_procent=abs(V3-pred)/V3)],"finish_test_check.csv",sep = ";",dec = ",")
# train$pred_y<- predict(clf2,data.matrix(train),ntreelimit = clf2$best_iteration)
# finish_test$pred_y<- predict(clf2,data.matrix(finish_test[,-"FACT"]),ntreelimit = clf2$best_iteration)
# mean(abs(finish_test$FACT-predict(clf2,data.matrix(finish_test[,-"FACT"]),ntreelimit = clf2$best_iteration)))
# aasas<- xgb.importance(model = clf2)
# 
# lmm<- lm(FACT~.,train)
# mean(abs(finish_test$FACT-predict(lmm,finish_test[,-"FACT"])))
# 
# # cor(testlabel,test$ridge)^2
# # plot(testlabel,test$pred_y)
# # plot(trainLabel,train$pred_y)
# 
xgb.importance(model = clf2)
# save(clf2,file="clf2.rda")
# 
# library(RRF)
# trainLabel <-  train$FACT
# testlabel <- test$FACT
# train$FACT <-  NULL
# test$FACT <-  NULL
# model_RRF<- RRF(x=train,y=trainLabel,flagReg=1,ntree = 10)
# # test$pred_y_rrf<- model_RRF$test$predicted
# test$pred_y_rrf<- predict(model_RRF,test)
# cor(testlabel,test$pred_y_rrf)^2
# # plot(test$pred_y_rrf,testlabel)
# 
# train$pred_y_rrf<- predict(model_RRF,train)
# finish_test$pred_y_rrf<- predict(model_RRF,finish_test[,-"FACT"])
# finish_test[,.(mean(abs(FACT-pred_y_rrf)))]
# # plot(train$pred_y_rrf,trainLabel)
# 
# save(model_RRF,file="model_RRF.rda")
# 
# dtrain = xgb.DMatrix(data=data.matrix(train),label=trainLabel,missing = NaN)
# dtest = xgb.DMatrix(data=data.matrix(test),label=testlabel,missing = NaN)
# watchlist<-list(train=dtrain,test=dtest)
# 
# 
# param <- list(  objective           = "rank:pairwise",
#                 booster = "gbtree",
#                 # eval_metric = "rmse",
#                 eval_metric = evalerror,
#                 eta                 = 0.1, # 0.06, #0.01,
#                 max_depth           = 8, #changed from default of 8
#                 subsample           = 0.6, # 0.7
#                 colsample_bytree    = 0.7 # 0.7
#                 # num_parallel_tree   = 2
#                 # alpha = 0.0001,
#                 # lambda = 1
#                 # lambda_bias = 1
# )
# set.seed(777)
# clf3 <- xgb.train(   params              = param,
#                      data                = dtrain,
#                      nrounds             = 5000,
#                      verbose             = 1,
#                      early.stop.round    = 10,
#                      #feval = normalizedGini,
#                      watchlist           = watchlist,
#                       maximize            = F
#                      
# )
# 
# test$pred_clf3<- predict(clf3,data.matrix(test),ntreelimit = clf3$best_iteration)
# train$pred_clf3<- predict(clf3,data.matrix(train),ntreelimit = clf3$best_iteration)
# cor(trainLabel,train$pred_clf3)^2
# cor(testlabel,test$pred_clf3)^2
# # plot(testlabel,test$pred_clf3)
# # plot(trainLabel,train$pred_clf3)
# 
# save(clf3,file="clf3.rda")
# 
# dtrain = xgb.DMatrix(data=data.matrix(train),label=trainLabel,missing = NaN)
# dtest = xgb.DMatrix(data=data.matrix(test),label=testlabel,missing = NaN)
# watchlist<-list(train=dtrain,test=dtest)
# 
# 
# 
# 
# param <- list(  objective           = "reg:linear",
#                 booster = "gblinear",
#                 eval_metric = "rmse",
#                 # eval_metric = evalerror,
#                 eta                 = 0.1, # 0.06, #0.01,
#                 max_depth           = 8 #changed from default of 8
#                 # subsample           = 0.3, # 0.7
#                 # colsample_bytree    = 0.3 # 0.7
#                 # num_parallel_tree   = 2
#                 # alpha = 0.0001,
#                 # lambda = 1
#                 # ,reg_lambda_bias = 1
#                 
#                 
#                 
# )
# set.seed(777)
# clf4 <- xgb.train(  params              = param,
#                     data                = dtrain,
#                     nrounds             = 1000,
#                     verbose             = 1,
#                     maximize            = FALSE,
#                     early.stop.round    = 5,
#                     #feval = normalizedGini,
#                     watchlist           = watchlist
#                      
# )
# 
# test$pred_clf4<- predict(clf4,data.matrix(test),ntreelimit = clf4$best_iteration)
# train$pred_clf4<- predict(clf4,data.matrix(train),ntreelimit = clf4$best_iteration)
# cor(trainLabel,train$pred_clf4)^2
# cor(testlabel,test$pred_clf4)^2
# # plot(testlabel,test$pred_clf4)
# # plot(trainLabel,train$pred_clf4)
# save(clf4,file="clf4.rda")
# 
# xgb.importance(name[-1],clf2)
# cor(cbind(testlabel,test$pred_y,test$pred_y_rrf,test$pred_clf3,test$ridge,test$pred_clf4))[,1]^2
# 
# # library(RRF)
# # model_RRF2<- RRF(x=train,y=trainLabel,flagReg=1)
# # # test$pred_y_rrf<- model_RRF$test$predicted
# # test$pred_y_rrf2<- predict(model_RRF2,test)
# # cor(testlabel,test$pred_y_rrf2)^2
# # 
# # train$pred_y_rrf2<- predict(model_RRF,train)
# # cor(cbind(testlabel,test$pred_y,test$pred_y_rrf,test$pred_clf3,test$ridge,test$pred_clf4,test$pred_y_rrf2))[,1]^2
# # 
# # save(model_RRF2,file="model_RRF2.rda")
# 
# # train$pred_clf5 <- NULL
# dtrain = xgb.DMatrix(data=data.matrix(train),label=trainLabel,missing = NaN)
# dtest = xgb.DMatrix(data=data.matrix(test),label=testlabel,missing = NaN)
# watchlist<-list(train=dtrain,test=dtest)
# 
# 
# param <- list(  objective           = "reg:linear",
#                 booster = "gbtree",
#                 # eval_metric = "rmse",
#                 eval_metric = evalerror
#                 # eta                 = 0.1, # 0.06, #0.01,
#                 # max_depth           = 6, #changed from default of 8
#                 # subsample           = 0.3, # 0.7
#                 # colsample_bytree    = 0.3 # 0.7
#                 # num_parallel_tree   = 2
#                  # alpha = 0.0001
#                 # lambda = 1
#                 # lambda_bias = 1
# )
# set.seed(777)
# clf5 <- xgb.train(   params              = param,
#                      data                = dtrain,
#                      nrounds             = 1000,
#                      verbose             = 1,
#                      early.stop.round    = 10,
#                      
#                      #feval = normalizedGini,
#                      watchlist           = watchlist,
#                      maximize            = F
#                      
# )
# 
# 
# save(clf5,file="clf5.rda")
# test$pred_clf5<- predict(clf5,data.matrix(test),ntreelimit = clf5$best_iteration)
# train$pred_clf5<- predict(clf5,data.matrix(train),ntreelimit = clf5$best_iteration)
# cor(cbind(testlabel,test$pred_y,test$pred_y_rrf,test$pred_clf3,test$ridge,test$pred_clf4,test$pred_clf5))[,1]^2
# cor(cbind(testlabel,test$pred_y,test$pred_y_rrf,test$pred_clf3,test$pred_clf4,test$pred_clf5))[,1]^2
# cor(cbind(trainLabel,train$pred_y,train$pred_y_rrf,train$pred_clf3,train$pred_clf4,train$pred_clf5))[,1]^2
# 
