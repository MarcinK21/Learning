# Kompromis bias-variance trade-off ------------------------------------------------

# Underfitting i overfitting to dwie najczęstsze przyczyny powstania błędów w modelu

# Bias to różnica pomiędzy średnią predykcją moedlu i prawidłową wartością, którą
  # próbujemy przewidzieć.

# Wariancja to wartość, która mówi nam o rozrzucie naszych danych


# W problemie underfitting zwykle uwzględniamy zbyt mało predyktorów lub budujemy
  # zbyt prosty model, aby opisać zależności/wzorce w zbiorze danych
# Rezultatem jest model, który jest określany jako biased: model, który osiąga  
  # słabe wyniki zarówno na danych, treningowych i testowych.
# Błąd związany z underfitting (zbyt prostym modelem) to bias.


# Problem overfitting występuje, gdy model działa zbyt dobrze na danych treningowych,
  # natomiast na danych testowych nie osiąga duże wartości błędu.
# Pokazuje jak bardzo rozproszona jest wartość przewidywana w odniesieniu do  
  # wartości rzeczywistej. Wysoka wariancja powoduje, że algorytm modeluje nie tylko
  # zależności/wzorce w danych, ale również szumy w danych treningowych.
# W overfitting zazwyczaj dołączamy zbyt wiele predyktorów lub budujemy   
  # zbyt złożony model.
# Błąd związany z overfittingiem (zbyt złożonym modelem) to wariancja.



# Pomiędzy underfitting i overfitting znajduje się model optymalny, który równoważy
  # kompromis pomiędzy biasem a wariancją ( balances the bias variance trade-off.)



# ACC functions and ROC function ---------------------------------------

#ACC
acc <- function(y.true, y.pred) { sum(y.pred==y.true)/length(y.true) }

# roc.function
#install.packages("ROCR")
library(ROCR)
roc.function<-function(y_pred,testY){
  pred <- prediction(as.numeric(y_pred), as.numeric(testY))
  perf.auc <- performance(pred, measure = "auc")
  auc<-round(unlist(perf.auc@y.values),2)
  perf <- performance(pred,"tpr","fpr")
  plot(perf,main=paste("ROC i AUC=",auc),colorize=TRUE, lwd = 3)
  abline(a = 0, b = 1, lwd = 2, lty = 2) #przekątna
}



# Model

dataset<-read.csv("http://imul.math.uni.lodz.pl/~bartkiew/med/dane/sna.csv", stringsAsFactors = T)
dataset <- dataset[2:5]
dataset$Purchased <- factor(dataset$Purchased, levels = c(0, 1))

# install.packages("caTools")
library(caTools)

set.seed(123)
split = sample.split(dataset$Purchased, SplitRatio = 0.7)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

# install.packages("rpart")
library(rpart)
library(rattle)

model= rpart(formula = Purchased ~ ., data = training_set)
fancyRpartPlot(model)
y_pred = predict(model, newdata = training_set, type = 'class')
table(y_pred,training_set$Purchased)
error=1-acc(y_pred,training_set$Purchased)

#błąd na zbiorze treningowym dla modelu optymalnego
error

model.y_pred = predict(model, newdata = test_set, type = 'class')
table(model.y_pred,test_set$Purchased)
error=1-acc(model.y_pred,test_set$Purchased)

#błąd na zbiorze testowym dla modelu optymalnego
error

roc.function(model.y_pred, test_set$Purchased)



# Underfitting ------------------------------------------------------------

control=rpart.control(minsplit=172)
model.172 <- rpart(Purchased~ .,training_set, control=control)
fancyRpartPlot(model.172)

y_pred.172 = predict(model.172, newdata = training_set, type = 'class')
table(y_pred.172,training_set$Purchased)
error=1-acc(y_pred.172,training_set$Purchased)

#błąd na zbiorze treningowym dla modelu underfitted 
error

model.172.pred<-predict(model.172, test_set ,type = "class")
table(model.172.pred,test_set$Purchased)
error=1-acc(model.172.pred,test_set$Purchased)

# błąd na zbiorze testowym dla modelu underfitted 
error

roc.function(model.172.pred, test_set$Purchased)


# Overfitting ------------------------------------------------------------

control <- rpart.control(cp=0, minbucket=0, minsplit = 0)
model.full <- rpart(Purchased~ .,training_set, control = control)
model.full
fancyRpartPlot(model.full)

y_pred.full = predict(model.full, newdata = training_set, type = 'class')
table(y_pred.full,training_set$Purchased)
error=1-acc(y_pred.full,training_set$Purchased)

#błąd na zbiorze treningowym dla modelu overfitted
error

model.full.pred<-predict(model.full , test_set ,type = "class")
table(model.full.pred,test_set$Purchased)
error=1-acc(model.full.pred,test_set$Purchased)

#błąd na zbiorze testowym dla modelu overfitted
error


roc.function(model.full.pred, test_set$Purchased














