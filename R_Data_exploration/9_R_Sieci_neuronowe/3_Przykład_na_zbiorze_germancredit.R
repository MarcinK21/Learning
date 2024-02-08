# Zbiór germancredit

gc<-read.csv("http://imul.math.uni.lodz.pl/~bartkiew/med/dane/germancredit.csv", stringsAsFactors = T)
gc.dv <- dummyVars("~ .",gc[-21], fullRank = F)
gcd = as.data.frame(predict(gc.dv, newdata=gc[-21]))

summary(gc.d)

gc.d<- as.data.frame(lapply(gcd, normalize))

gc.d=cbind(gc.d,gc[21])
str(gc.d)

library(caTools)

set.seed(12345)
split = sample.split(gc.d$credit_risk, SplitRatio = 0.7)
gc.d.Train <- subset(gc.d, split == TRUE)
gc.d.Test <- subset(gc.d, split == FALSE)

set.seed(14)
gc.nn = nnet(credit_risk~ ., data = gc.d.Train, size = 10, decay = 0.1, maxit = 200)
summary(gc.nn)
gc.nn
plotnet(gc.nn)

gc.predict = predict(gc.nn, gc.d.Test)
gc.predict.class <- ifelse(gc.predict >= 0.5, 1, 0)
table(gc.d.Test$credit_risk, gc.predict.class)

library(pROC)
nn.roc = roc(gc.d.Test$credit_risk, gc.predict)
x=plot(nn.roc)
x