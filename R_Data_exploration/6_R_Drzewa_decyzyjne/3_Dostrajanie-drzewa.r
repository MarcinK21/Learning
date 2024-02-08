#Dostrajanie drzewa----------------------

#Dostrajanie algorytmu budującego drzewo decyzyjne

#A) Wybór miary podziału (pierwszy zysk informacyjny, a drugi indeks Giniego) - porównać modele:
  
model.inf <- rpart(Purchased~ .,training_set,
                     parms=list(split="information"))

fancyRpartPlot(model.inf)

model.inf.pred<-predict(model.inf , test_set ,type = "class")

table(test_set$Purchased,model.inf.pred)

model.gini <- rpart(Purchased~ .,training_set,
                    parms=list(split="gini"))

fancyRpartPlot(model.gini)

model.gini.pred<-predict(model.gini  , test_set ,type = "class")

table(test_set$RainTomorrow,model.gini.pred)

#B) Argument minsplit= podaje minimalną liczbę obserwacji, które muszą występować w węźle drzewa, 
#aby został on dalej dzielony

control=rpart.control(minsplit=172)

model.172 <- rpart(Purchased~ .,training_set,
                   control=control)

fancyRpartPlot(model.172)

model.172.pred<-predict(model.172, test_set ,type = "class")

table(test_set$Purchased,model.172.pred)

#C) Argument minbucket = jest minimalną liczbą obserwacji w każdym węźle liścia.

control=rpart.control(minbucket=5)

model.5 <- rpart(Purchased~ .,training_set,
                 control=control)

fancyRpartPlot(model.5)

model.5.pred<-predict(model.5, test_set ,type = "class")

table(test_set$Purchased,model.5.pred)

# Każdy ruch parametrem może spowodować inne drzewo

#D) Parametry modelu można odczytać z drzewa

#E)

model.5$control
model.172$control

#F) W poniższym przykładzie, budujemy pełne drzewo decyzyjne z cp =, minbucket= i minisplit = równymi
#zero. Wyświetlamy tablice wartości CP.

control <- rpart.control(cp=0, minbucket=0, minsplit = 0)
model.full <- rpart(Purchased~ .,training_set,
                    control = control)
model.full
fancyRpartPlot(model.full)
model.full.pred<-predict(model.full , test_set ,type = "class")
table(test_set$Purchased,model.full.pred)

#G) Tablica cp.
model.full$cptable

#Pierwsza kolumna oznaczona CP to wartość parametru cp. Druga kolumna, nsplit, 
#to liczba podziałów w drzewie. Błąd rel error oznacza względny błąd związany 
#z błędem średniokwadratowym (pierwiastek z  różnicy między wartością a wartością modelowaną) 
#i liczbą podziałów. Zarówno xerror, jak i xstd są oparte na dziesięciokrotnej walidacji krzyżowej, 
#przy czym xerror jest średnim błędem, a xstd - odchyleniem standardowym w procesie sprawdzania krzyżowego.

#H) Możemy zautomatyzować wybór parametru cp za pomocą następujących czynności:
  
xerr <- model.full$cptable[,"xerror"]
minxerr <- which.min(xerr)
mincp <- model.full$cptable[minxerr, "CP"]
mincp
model.prune <- prune(model.full,cp=mincp)
model.prune
fancyRpartPlot(model.prune)
model.prune.pred<-predict(model.prune , test_set ,type = "class")
table(test_set$Purchased,model.prune.pred)

#I) Można również narysować wykres cp
plotcp(model.full)



#Dostrajanie drzewa z użyciem pakietu e1071------------------

install.packages("e1071")
library(e1071)

me<-tune.rpart(Purchased~ .,training_set,
               cp=c(0.0077, 0.13, 0.1,0.2,0.3), minsplit = 18:24, minbucket = 6:8)
me


#W wyniku działania otrzymujemy najlepsze parametry, ale tylko spośród zadanych.

control <- rpart.control(cp=0.1,minsplit = 18,minbucket = 6)
m<-rpart(Purchased~ .,training_set,control = control)
fancyRpartPlot(m)
mc.pred<-predict(m, test_set ,type = "class")
table(test_set$Purchased,mc.pred)