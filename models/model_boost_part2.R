library(RJDBC)
library(data.table)
library(mice)
setwd("D:/Cronus/Virtual_machine/R/models")
getwd()
data<- fread("data.csv",integer64 = "numeric")
str(data)
names(data) <- c("FACT",paste0("V",2:ncol(data)))
name<- read.table("names.txt")
name<- name$V1
name <- as.character(name)


# BOOSTRAP
 set.seed(777)
sam<- sample(nrow(data),nrow(data),replace = T)
# sam<- sample(nrow(data),nrow(data)*0.7,replace = F)
train <- copy(data[sam,])
test <- copy(data[-sam,])
# train <- data


# library(MASS)
# fit_ridge<-lm.ridge(FACT~.,data = train,lambda = seq(0,10000,1))
# # plot(x = fit_ridge$lambda,y = fit_ridge$GCV,type="o")
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
# test$ridge <- beta.fit_ridge[1]+as.matrix(test[,-"FACT"])%*%beta.fit_ridge[2:m]
# summary(test$ridge)
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


evalerror <- function(preds, dtrain) {
  labels <- getinfo(dtrain, "label")
  err <-(cor(cbind(preds,labels))^2)[1,2]
    return(list(metric = "R2", value = err))
}


param <- list(  objective           = "reg:linear",
                booster = "gbtree",
                eval_metric = "rmse",
                eta                 = 0.01, # 0.06, #0.01,
                max_depth           = 6, #changed from default of 8
                subsample           = 0.3, # 0.7
                colsample_bytree    = 0.3 # 0.7
                # num_parallel_tree   = 2
                # alpha = 0.0001,
                # lambda = 1
                # lambda_bias = 1
)
set.seed(777)
clf2 <- xgb.train(   params              = param,
                     data                = dtrain,
                     nrounds             = 10000,
                     verbose             = 1,
                     early.stop.round    = 100,
                     #feval = normalizedGini,
                     watchlist           = watchlist,
                     maximize            = F
                     
)

test$pred_y<- predict(clf2,data.matrix(test),ntreelimit = clf2$best_iteration)
train$pred_y<- predict(clf2,data.matrix(train),ntreelimit = clf2$best_iteration)
cor(trainLabel,train$pred_y)^2
cor(testlabel,test$pred_y)^2
# cor(testlabel,test$ridge)^2
# plot(testlabel,test$pred_y)
# plot(trainLabel,train$pred_y)

# xgb.importance(name[2:969],model = clf2)
save(clf2,file="clf2.rda")

library(RRF)
model_RRF<- RRF(x=train,y=trainLabel,flagReg=1)
# test$pred_y_rrf<- model_RRF$test$predicted
test$pred_y_rrf<- predict(model_RRF,test)
cor(testlabel,test$pred_y_rrf)^2
# plot(test$pred_y_rrf,testlabel)

train$pred_y_rrf<- predict(model_RRF,train)
# plot(train$pred_y_rrf,trainLabel)

save(model_RRF,file="model_RRF.rda")

dtrain = xgb.DMatrix(data=data.matrix(train),label=trainLabel,missing = NaN)
dtest = xgb.DMatrix(data=data.matrix(test),label=testlabel,missing = NaN)
watchlist<-list(train=dtrain,test=dtest)


param <- list(  objective           = "reg:gamma",
                booster = "gbtree",
                eval_metric = "rmse",
                eta                 = 0.01, # 0.06, #0.01,
                max_depth           = 8, #changed from default of 8
                subsample           = 0.6, # 0.7
                colsample_bytree    = 0.7 # 0.7
                # num_parallel_tree   = 2
                # alpha = 0.0001,
                # lambda = 1
                # lambda_bias = 1
)
set.seed(777)
clf3 <- xgb.train(   params              = param,
                     data                = dtrain,
                     nrounds             = 5000,
                     verbose             = 1,
                     early.stop.round    = 100,
                     #feval = normalizedGini,
                     watchlist           = watchlist
                     # maximize            = T
                     
)

test$pred_clf3<- predict(clf3,data.matrix(test),ntreelimit = clf3$best_iteration)
train$pred_clf3<- predict(clf3,data.matrix(train),ntreelimit = clf3$best_iteration)
cor(trainLabel,train$pred_clf3)^2
cor(testlabel,test$pred_clf3)^2
# plot(testlabel,test$pred_clf3)
# plot(trainLabel,train$pred_clf3)

save(clf3,file="clf3.rda")

dtrain = xgb.DMatrix(data=data.matrix(train),label=trainLabel,missing = NaN)
dtest = xgb.DMatrix(data=data.matrix(test),label=testlabel,missing = NaN)
watchlist<-list(train=dtrain,test=dtest)


param <- list(  objective           = "reg:tweedie",
                booster = "gbtree",
                eval_metric = "rmse",
                eta                 = 0.01, # 0.06, #0.01,
                max_depth           = 8, #changed from default of 8
                subsample           = 0.3, # 0.7
                colsample_bytree    = 0.3 # 0.7
                # num_parallel_tree   = 2
                # alpha = 0.0001,
                # lambda = 1
                ,reg_lambda_bias = 1
                
                
                
)
set.seed(777)
clf4 <- xgb.train(   params              = param,
                     data                = dtrain,
                     nrounds             = 5000,
                     verbose             = 1,
                     early.stop.round    = 100,
                     #feval = normalizedGini,
                     watchlist           = watchlist
                     # maximize            = F
                     
                     
)

test$pred_clf4<- predict(clf4,data.matrix(test),ntreelimit = clf4$best_iteration)
train$pred_clf4<- predict(clf4,data.matrix(train),ntreelimit = clf4$best_iteration)
cor(trainLabel,train$pred_clf4)^2
cor(testlabel,test$pred_clf4)^2
# plot(testlabel,test$pred_clf4)
# plot(trainLabel,train$pred_clf4)
save(clf4,file="clf4.rda")

xgb.importance(names(train),clf2)
cor(cbind(testlabel,test$pred_y,test$pred_y_rrf,test$pred_clf3,test$ridge,test$pred_clf4))[,1]^2

# library(RRF)
# model_RRF2<- RRF(x=train,y=trainLabel,flagReg=1)
# # test$pred_y_rrf<- model_RRF$test$predicted
# test$pred_y_rrf2<- predict(model_RRF2,test)
# cor(testlabel,test$pred_y_rrf2)^2
# 
# train$pred_y_rrf2<- predict(model_RRF,train)
# cor(cbind(testlabel,test$pred_y,test$pred_y_rrf,test$pred_clf3,test$ridge,test$pred_clf4,test$pred_y_rrf2))[,1]^2
# 
# save(model_RRF2,file="model_RRF2.rda")

# train$pred_clf5 <- NULL
dtrain = xgb.DMatrix(data=data.matrix(train),label=trainLabel,missing = NaN)
dtest = xgb.DMatrix(data=data.matrix(test),label=testlabel,missing = NaN)
watchlist<-list(train=dtrain,test=dtest)


param <- list(  objective           = "reg:linear",
                booster = "gbtree",
                eval_metric = "rmse",
                eta                 = 0.01, # 0.06, #0.01,
                max_depth           = 6, #changed from default of 8
                subsample           = 0.3, # 0.7
                colsample_bytree    = 0.3 # 0.7
                # num_parallel_tree   = 2
                 # alpha = 0.0001
                # lambda = 1
                # lambda_bias = 1
)
set.seed(777)
clf5 <- xgb.train(   params              = param,
                     data                = dtrain,
                     nrounds             = 10000,
                     verbose             = 1,
                     early.stop.round    = 100,
                     #feval = normalizedGini,
                     watchlist           = watchlist,
                     maximize            = F
                     
)
save(clf5,file="clf5.rda")
test$pred_clf5<- predict(clf4,data.matrix(test),ntreelimit = clf5$best_iteration)
train$pred_clf5<- predict(clf4,data.matrix(train),ntreelimit = clf5$best_iteration)
cor(cbind(testlabel,test$pred_y,test$pred_y_rrf,test$pred_clf3,test$ridge,test$pred_clf4,test$pred_clf5))[,1]^2
cor(cbind(testlabel,test$pred_y,test$pred_y_rrf,test$pred_clf3,test$pred_clf4,test$pred_clf5))[,1]^2
cor(cbind(trainLabel,train$pred_y,train$pred_y_rrf,train$pred_clf3,train$pred_clf4,train$pred_clf5))[,1]^2

