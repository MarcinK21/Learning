# Walidacja krzyżowa Cross validation (cv) ------------------------------------

# Walidacja krzyżowa jest techniką walidacji modelu, która pomaga ocenić wydajność i
  # zdolność modelu uczenia maszynowego do generalizacji na niezależnym
  # zbiorze danych.

# Walidacja krzyżowa pomaga nam:

  # ocenić odporność modelu na niewidzianych danych
  # oszacować zakres dla metryk oceniających wydajność  
  # ocenić nadmierne overfitting i underfitting modeli

# Ogólna zasada walidacji krzyżowej polega na przetestowaniu modelu na całym  
  # zbiorze danych w kilku iteracjach poprzez podzielenie danych na grupy i użycie
  # wiekszości do treningu oraz mniejszości do testu. Powtarzające się rotacje
  # zapewniają, że model został przetestowany na wszystkich dostępnych 
  # obserwacjach. Ostateczne metryki wydajności modelu są agregowane i podsumowywane
  # na podstawie wyników wszystkich rotacji.


# Aby zbadać, czy model ma wyoski bias, możemy sprawdzić średnią (average) wydajność
  # modelu we wszystkich rotacjach. Jeśli średnia metryka wydajność:
  # ogólna dokładność (dla klasyfikacji) lub  
  # średni bezwzględny błąd procentowy (dla regresji) jest niska, to 
  # mamy do czynienia z wyoskim biasem i model niedouczony.


# Aby zbadać, czy model ma wysoką wariancję, możemy zbadać 
  # odchylenie standardowe pożądanych metryk wydajności w poszczególnych rotacjach.
  # Wysokie odchylenie standardowe wskazywałoby na to, że model będzie miał 
  # wysoką wariancję, czyli model będzie nadmiernie dopasowany.


# Istnieje kilka popularnych podejść w walidacji krzyżowej:
  # walidacja holdoutowa
  # walidacja krzyżowa k-krotna
  # walidacja typu hold-one-out (LOOCV)


# Walidacja Holdout ---------------------------------------------------

# Losowo dzielimy dostępny zbiór danych na treningowy i testowy. Najczęściej
  # stosowane proporcje podziału pomiędzy zb. treningowym i testowym to 70:30 lub 80:20

# Podczas tworzenia zbiorów treningowych i testowych ważne jest, aby oba zbiory
  # danych były niezależne od siebie i aby były reprezentatywnymi próbkami 
  # oryginalnych danych (lub problemu, który próbujemy rozwiązać)
  # Niezależność oznacza tutaj, że jeśli obserwacja jest wybrana z oryginalnego
  # zbioru danych jako część danych treningowych, nie może być również wybrana
  # jako część danych testowych i odwrotnie.


# Głównymi wadami tego podejścia jest to, że wydajność modelu jest oceniana 
  # tylko na podzbiorze testowego zbioru danych i może nie być 
  # najlepszą reprezentacją wydajności modelu. Ocena modelu będzie całkowicie
  # zależna od rodzaju podziału, a zatem od charakteru punktów danych, któRe
  # trafiają do szkoleniowych i testowych zbiorów danych, co może prowadzić
  # do znacznie różniących się wyników, a zatem do dużej wariamcji.




# Walidaca krzyżowa k-krotna (k-Fold Cross Validation)

# Technika ta jest najbardziej zalecanym podejściem do oceny modelu

# W tej technice:

  # dzielimy dane na k grup i używamy k-1 grup do treningu, a pozostałą część
    # (1 grupę) do walidacji;
  
  # proces jest powtarzany k razy, przy czym w każdej kolejnej iteracji do 
    # walidacji używana jest nowa grupa;

  # każda grupa jest wykorzystywana do testowania w jednej iteracji;

  # ogólne wyniki to średnie szacunki błędów w ciągu k iteracji.


# K-krotna walidacja krzyżowa likwiduje wady techniki holdout poprzez zmniejszenie
  # niebezpieczeństw związanych z podziałem zbioru, ponieważ każdy punkt danych
  # jest testowany raz w ciągu k iteracji.

# Wariancja modelu zmniejsza się wraz ze wzrostem wartości k. 
  # Najczęstsze wartości stosowane dla k to 5 lub 10

install.packages("caret")
library(caret)

control = trainControl(method="cv", number=10)
model.caret = train(Purchased ~ .,data=training_set, method="rpart", preProcess="scale", trControl=control)
plot(model.caret)

model.caret
model.caret$resample$Accuracy

sd(model.caret$resample$Accuracy)
cv.y_pred = predict(model.caret2, newdata = test_set, type = 'raw')
table(cv.y_pred,test_set$Purchased)


control = trainControl(method="repeatedcv", number=10,repeats=3)
model.caret2 = train(Purchased ~ .,data=training_set, method="rpart", preProcess="scale", trControl=control)
plot(model.caret2)

model.caret2
model.caret2$resample$Accuracy

sd(model.caret2$resample$Accuracy)
cv.y_pred.2 = predict(model.caret, newdata = test_set, type = 'raw')
table(cv.y_pred.2,test_set$Purchased)



# Walidacja hold One Out ------------------------------------------------

# Wybieramy liczbę partycji = liczbę dostępnych obserwacji danych.
  # Dlatego w jednej partycji mielibyśmy tylko jedną próbkę. Do treningu używamy
  # wszystkich próbek oprócz jednej, a model testujemy na próbce, która została
  # pominięta i powtarzamy to n razy, gdzie n jest liczbą próbek treningowych.
# Główną wadą tej techniki jest to, że model jest trenowany n razy, co czyni go
  # kosztownym obliczeniowym
# Walidacja Hold-one-out jest również nazywana Leave-One-Out Cross-Validation (LOOCV)



control = trainControl(method="LOOCV")
model.caret3 = train(Purchased ~ .,data=training_set, method="rpart", trControl=control)
plot(model.caret3)

model.caret3

cv.y_pred.3 = predict(model.caret3, newdata = test_set, type = 'raw')
table(cv.y_pred.3,test_set$Purchased)


# inne metody

trainControl <- trainControl(method="LOOCV")
fit <- train(Purchased ~ .,data=training_set, trControl=trainControl, method="nb")
fit
plot(fit)

trainControl <- trainControl(method="LOOCV")
fit <- train(Purchased ~ .,data=training_set, trControl=trainControl, method="knn")
fit
plot(fit)


# Każdy algorytm uczenia maszynowego będzie miał inny zestaw skojarzonych 
  # hiperparametrów, które pomogą modelowi ignorować błędy (szum), a więc
  # poprawią zdolności generalizacyjne


