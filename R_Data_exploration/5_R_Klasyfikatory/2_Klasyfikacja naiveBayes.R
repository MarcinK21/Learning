# Klasyfikacja naiwnego Bayesa  ------------------------------------------------------

install.packages("e1071")
library(e1071)


komp <- read.csv("http://imul.math.uni.lodz.pl/~bartkiew/med/dane/komputerowy.csv", stringsAsFactors = T)
komp


model.komp<- naiveBayes(kupi_komputer~., data=komp)
print(model.komp)


komp[15,1]=15
komp[15,2]="<=30"
komp[15,3]="sredni"
komp[15,4]="tak"
komp[15,5]="kawaler"


predict(model.komp, komp[15,])
komp[15,6]=predict(model.komp, komp[15,])


# Wymyślamy innego klienta

komp[16,1]=16
komp[16,2]=">40"
komp[16,3]="niski"
komp[16,4]="tak"
komp[16,5]="kawaler"


#predict(model.komp, komp[16,])
komp[16,6]=predict(model.komp, komp[16,])



# Klasyfikator - naiwny Bayes

wbcd <- read.csv("http://imul.math.uni.lodz.pl/~bartkiew/med/dane/wisc_bc_data.csv", stringsAsFactors = T)
str(wbcd)
summary(wbcd)
wbcd <- wbcd[-1]


levels(wbcd$diagnosis)<- c("łagodny", "złośliwy")


# Klasyfikator - naiwny Bayes

set.seed(14)
Train_Test <- sample(c("train","test"),nrow(wbcd),replace =TRUE, prob = c(0.7,0.3))
Train_Test

wbcd_train=subset(wbcd,Train_Test=="train")
wbcd_test=subset(wbcd,Train_Test=="test")


model.bayes<- naiveBayes(diagnosis~., data=wbcd_train) 
model.bayes
bayes.pred <- predict(model.bayes, wbcd_test)
bayes.pred2 <- predict(model.bayes, wbcd_test, type = "raw")
bayes.pred2
table(wbcd_test$diagnosis,bayes.pred )
acc<-sum(wbcd_test$diagnosis==bayes.pred)/nrow(wbcd_test)
acc

# Macierz pomyłek

install.packages("gmodels")
library(gmodels)

CrossTable(wbcd_test$diagnosis, bayes.pred,
           prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
           dnn = c('actual default', 'predicted default'))









