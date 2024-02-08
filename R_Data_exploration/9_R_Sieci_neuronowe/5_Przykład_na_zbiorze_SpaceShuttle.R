# Space Shuttle - prom kosmiczny

# Zbiór danych pochodzący z symulacji dokowania promu kosmicznego, z pakietu MASS

install.packages("MASS")
library(MASS)

data(shuttle)
str(shuttle)

# Zwróćmy uwagę, że wszystkie zmienne są kategoryczne, a zmienna celu ma dwa czynniki auto i noauto.

  # stability :
  # error
  # sign
  # wind
  # magn
  # vis

# Wszystkie zmienne używane do budowy sieci muszą być numeryczne.
# Korzystając z dummy coding, przekształcamy nasz zbiór.

library(caret)

dummies <- dummyVars(use ~ .,shuttle, fullRank = T)
dummies
shuttle.2 = as.data.frame(predict(dummies, newdata = shuttle))
names(shuttle.2)
str(shuttle.2)

# Również przekształcamy zmienną celu.

shuttle.2$use <- ifelse(shuttle$use == "auto", 1, 0)
table(shuttle.2$use)


# Dzielimy na zbiór testowy i trengowy

set.seed(45)
trainIndex <- createDataPartition(shuttle.2$use, p = .7, list =FALSE)
shuttleTrain <- shuttle.2[trainIndex, ]
shuttleTest <- shuttle.2[-trainIndex, ]


# Modelowanie i ewaluacje
# Ponieważ budowanie formuł nie jest proste, pomocniczo używamy funkcji as.formula()

n <- names(shuttleTrain)
formula <- as.formula(paste("use ~", paste(n[!n %in% "use"],collapse = " + ")))
formula



# W funkcji neuralnet
  # act.fct - domyślnie funkcja sigmoidalna
  # err.fct - funkcja używana do obliczenia błędu (domyślnie sse)
    # w tym przykładzie mamy do czynienia z danymi binarnymi, więc wykorzystamy stałą ce w obliczeniu entropii
  # linear.output - dla danych binarnych stosujemy FALSE

set.seed(1234)
net1 <- neuralnet(formula, data = shuttleTrain, err.fct = "ce", linear.output = FALSE)

net1
plot(net1)

# Zwróćmy uwagę na bardzo niski błąd sieci.

res2 <- compute(net1, shuttleTest[, 1:10])
predTest2 <- res2$net.result
predTest2

# Jako wyniki otrzymujemy prawdopodobieństwa, więc przekształcamy aby
  # wygenerować macierz pomyłek

predTest2 <- ifelse(predTest2 >= 0.5, 1, 0)
table(predTest2, shuttleTest$use)

# Mamy tylko jeden błąd. Chcąc go poszukać, używamy funkcji which

which(predTest2 == 1 & shuttleTest$use == 0)

shuttleTest[60,]
shuttle[203,]

shuttle[60,]

# Więc nasza sieć mówi: użyj automatycznego sterowania, a astronauta użył sterowania ręcznego.





