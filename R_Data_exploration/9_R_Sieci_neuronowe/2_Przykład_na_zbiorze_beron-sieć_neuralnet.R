# Zbiór beton

# Sieć neuronowa neuralnet

beton <- read.csv("http://imul.math.uni.lodz.pl/~bartkiew/med/dane/concrete.csv")

bn <- as.data.frame(lapply(beton, normalize))

library(caret)

inTrain <- createDataPartition(y=bn$strength, p=0.75, list=FALSE) 
bn_train <- bn[inTrain,]
bn_test <- bn[-inTrain,]

summary(bn$strength)
summary(bn_train$strength)
# summary pozwala nam zobaczyć rozkład zmiennej, obserwacje zostały dobrane bardzo dokładnie, różnica w medianie dopiero w 4  miejscu po przecinku, natomiast w średniej w 3 miejscu po przecinku

install.packages("neuralnet")
library(neuralnet)

# Budujemy pierwszy model przy użyciu neuralnetu
set.seed(2023)
model <- neuralnet(strength ~cement + slag+ ash + water + superplastic + coarseagg + fineagg + age, data = bn_train)
plot(model)


# W powyższym przykładzie został zbudowany model sieci, a następnie
  # sieć została narysowana.
# W tym prostym modelu mamy jeden węzeł wejściowy dla danych w zbiorze
  # ośmiu zmiennym oraz pojedyńczy ukryty węzeł i pojedyńczy węzeł wyjściowy,
  # który przewiduje siłę wiązania betonu. Na dole obrazka mamy
  # wypisaną liczbę kroków oraz błąd (SSE - Sum of Squared Errors)
# Oczywiście niższe wartości pozwalają wybrać lepszy model.

wyniki1 <- compute(model, bn_test)
wyniki1$neurons
predicted_strength <- wyniki1$net.result

MSE(predicted_strength, bn_test$strength) # MSE - błąd średniokwadratowy

cor(predicted_strength, bn_test$strength)
# Korelacja jak dobrze została odbudowana sieć jest na poziomie 0.8175892


# Ponieważ mamy do czynienia z zadaniem predykcji a nie klasyfikacji,
  # więc użyjemy korelacji a nie macierzy pomyłek.
# Poprawiamy nieco sieć:

model2 <- neuralnet(strength ~cement + slag+ 
                      ash + water + superplastic + coarseagg + fineagg + age, data = bn_train, hidden = 8)
plot(model2)
model2$weights


wyniki2 <- compute(model2, bn_test)
predicted_strength2 <- wyniki2$net.result
MSE(predicted_strength2, bn_test$strength)

cor(predicted_strength2, bn_test$strength)


# Sieć neuronowa nnet

# https://www.rdocumentation.org/packages/nnet/versions/7.3-12

install.packages("nnet")
library(nnet)

set.seed(2023)
beton.nn = nnet(strength ~ ., data = bn_train, size = 1, decay = 5e-4, maxit = 200)
summary(beton.nn)
# 8-1-1  ;  8 neuronów

beton.predict = predict(beton.nn, bn_test)
MSE(beton.predict, bn_test$strength)

cor(beton.predict, bn_test$strength)

install.packages("NeuralNetTools")
library(NeuralNetTools)
plotnet(beton.nn , alpha=0.6)


# Można dostroić sieć używając pakietu caret
library(caret)

control = trainControl(method="cv", number=10)
siatka=expand.grid(.decay=c(0.0005,0.1), .size=c(7,8,9))
model3 = train(strength ~ ., data = bn_train,
               method='nnet', tuneGrid=siatka,
               trControl=control, maxit = 200)

plot(model3)
model3
summary(model3)
plotnet(model3 , alpha=0.6)
model3.predict = predict(model3, bn_test)
MSE(model3.predict , bn_test$strength)
cor(model3.predict , bn_test$strength)












