#Funkcja rpart

#Drzewo klasyfikacyjne - funkcja rpart
#Wczytanie zbioru i podział na zbiór treningowy i testowy

#dataset = read.csv("sna.csv")
dataset<-read.csv("http://imul.math.uni.lodz.pl/~bartkiew/med/dane/sna.csv", stringsAsFactors = T)
dataset <- dataset[2:5]
str(dataset)
summary(dataset)
dataset$Purchased <- factor(dataset$Purchased, levels = c(0, 1))
levels(dataset$Purchased)<-c("nie kupi","kupi")

install.packages("caTools")
library(caTools)
set.seed(123)
split = sample.split(dataset$Purchased, SplitRatio = 0.7)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

prop.table(table(dataset$Purchased))
prop.table(table(training_set$Purchased))
prop.table(table(test_set$Purchased))

#Pakiet rpart.----------------------

install.packages("rpart")
library(rpart)
model= rpart(formula = Purchased ~ ., data = training_set)
model

#W modelu mamy zapisane drzewo w wersji tekstowej.
# model
# n= 280
# node), split, n, loss, yval, (yprob)
# * denotes terminal node
#  1) root 280 100 kupi (0.64285714 0.35714286) 
#  2) Age< 44.5 205 34 kupi (0.83414634 0.16585366) 
#  4) EstimatedSalary< 90000 170 6 kupi (0.96470588 0.03529412) *
#  5) EstimatedSalary>=90000 35 7 nie kupi (0.20000000 0.80000000) *
#  3) Age>=44.5 75 9 nie kupi (0.12000000 0.88000000) *
#  * oznacza wierzchołek końcowy - liść.


#Narysujemy drzewo

install.packages("rpart.plot")
library(rpart.plot)
rpart.plot(model)

#lub

install.packages("rattle")
library(rattle)
fancyRpartPlot(model)




#Testujemy zbudowany model drzewa

y_pred1 = predict(model, newdata = test_set) # otrzymujemy prawdopodobieństwa
y_pred1

#kupi nie kupi
#2 0.9647059 0.03529412
#4 0.9647059 0.03529412
#5 0.9647059 0.03529412
#9 0.9647059 0.03529412
#12 0.9647059 0.03529412
#14 0.9647059 0.03529412
#18 0.1200000 0.88000000

#W przypadku naszego zbioru, chcielibyśmy otrzymać przypisanie - dla każdej obserwacji ze zbioru 
#testowego jedną z etykiet: kupi - nie kupi.

#Dlatego można użyć parametru class w funkcji predict.

y_pred = predict(model, newdata = test_set, type = 'class')


#Macierz pomyłek (przykładowe trzy sposoby wygenerowania)

#1. funkcja table

table(test_set$Purchased, y_pred)
y_pred

#kupi  nie kupi
#kupi     67 10
#nie kupi  2 41

# Możemy sprawdzić accuracy 

acc <- function(y1,y2){
  sum(y1==y2)/length(y1)
}

acc(test_set$Purchased, y_pred)

asRules(model)

# Sprawdzamy, które obserwacje trafiłY do liścia nr 4 ------------
install.packages("dplyr")
library(dplyr)

training_set %>%
  filter(Age < 44,5 & EstimatedSalary < 90000)

# Wzór na entropie
 # Entropia(A) = suma od i=1 do m (pi log2(pi))


# Ile wynosi entropia w tym liściu?
-0.96 * log2(0.96) - 0.04 * log2(0.04)
# Entropia = 0,2422922

# Ile wynosi entropia w całym zbiorze
-0.64 * log2(0.64) - 0.36 * log2(0.36)
# = 0.9426832

# Entropia

ent <- function(p){
  ifelse(p==0 | p==1, 0, -p*log2(p) - (1-p)*log2(1-p))
}

curve(ent, 0.1, col = "tomato", lwd =3.5)
abline(h=0, v= 0:2/2, lty = 3, col = "gray")
abline(v = 0, h = 0:2/2, lty = 3, col = "gray")


#2.funkcja CrossTable - pakiet gmodels

# install.packages("gmodels")
library(gmodels)
CrossTable(test_set$Purchased, y_pred,
           prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
           dnn = c('actual default', 'predicted default'))



#3. funkcja confusionMatrix  - pakiet caret

#install.packages("caret")
library(caret)
confusionMatrix(table(y_pred, test_set$Purchased))


#Drzewo jako reguły
asRules(model)


#Parametry drzewa
model$control
model$cptable
model$variable.importance
summary(model)