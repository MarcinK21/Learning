# Google Trends a rynek akcji - regresja

# Wykorzystamy zbiór danych Google Trends. Pokażemy zastosowanie sieci
  # neuronowej do badania asocjacji pomiędzy trendami wyszukiwania Google,
  # a dziennym indeksem giełdowym - Dow Jones

google=read.csv("http://imul.math.uni.lodz.pl/~bartkiew/med/dane/google.csv",stringsAsFactors =T)
str(google)

# Opis zmiennych 
  # x - liczba
  # index
  # Date
  # Unemployment - indeks bezrobocia
  # Rental 
  # RealEstate
  # Mortage
  # Jobs
  # Investing
  # DJI_Index
  # StdJI
  # 30-Day Moving Average 
  # 180-Day MA

# Pierwsze trzy to identyfikatory, ostatnie to parametry statystyczne
# obliczone na podstawie poprzednich kolumn

# Usuwamy zmienne nieprzydatne do modelowania
google=google[,-1:-3]
google=google[,-9:-24]


str(google)
summary(google)

# Normalizujemy zbiór 
google.norm<-as.data.frame(lapply(google, normalize))

# Zmiennej RealEstate używamy jako zmiennej zależnej. Sprawdzamy, czy Google Real Estate Index może być przewidywany przez inne zmienne w naszym zbiorze danych google.

install.packages("caTools")
library(caTools)

set.seed(123)
split = sample.split(google.norm$RealEstate, SplitRatio = 0.7)
training_set = subset(google.norm, split == TRUE)
test_set = subset(google.norm, split == FALSE)

summary(google.norm$RealEstate)
summary(training_set$RealEstate)


# Model sieci

# install.packages("neuralnet")
library(neuralnet)
google.nn1<-neuralnet(RealEstate~Unemployment+Rental+Mortgage+Jobs+Investing+DJI_Index+StdDJI, data=training_set)

google.nn1


# Funkcja nuralnet z pakietu neuralnet zwraca obiekt sieci NN

  # call; wywołanie funkcji
  # response; odpowiedz sieci
  # covariate; odpowiedzi sieci dla zmiennych
  # model.list; lista zmiennych
  # err.fct and act.fct; funkcja błędu i funkcja aktywacji
  # net.result; lista zawierająca ogólny wynik sieci neuronowej dla każdego powtórzenia
  # weights; wagi
  # result.matrix; zapisany graf sieci

m <- neuralnet(target ~ predictors, data=mydata, hidden=1)

  # target; zmienna celu
  # predictors; .....
  # data; zbiór treningowy
  # hidden; liczba ukrytych neurownów

plot(google.nn1)

# Błąd reprezentuje zagregowaną sumę błędów kwadratowych, kroki to liczba iteracji, przez które przeszedł model
# Wyniki mogą być różne, jeśli zostanie kilkukrotnie uruchomiony

# Ocena modelu
google_pred<-compute(google.nn1, test_set)
pred_results<-google_pred$net.result
MSE(pred_results, test_set$RealEstate)
cor(pred_results, test_set$RealEstate)

# Ponieważ rozpatrujemy regresje, nie używamy macierzy pomyłek. Aby ocenić model, można policzyć korelację pomiędzy wartościami
  # otrzymanymi z modelu sieciowego a tymi, które rzeczywiście występują w zbiorze danych

# Poprawa wydajności modelu
  # model złożony z 4 węzłów w warstwie ukrytej
set.seed(123)
google.nn2<-neuralnet(RealEstate~Unemployment+Rental+Mortgage+Jobs+Investing+DJI_Index+StdDJI, data=training_set, hidden = 4)
plot(google.nn2)
google_pred2<-compute(google.nn2, test_set)
pred_results2<-google_pred2$net.result

MSE(pred_results2, test_set$RealEstate)

cor(pred_results2, test_set$RealEstate)
# Przewidywane i obserwowane indeksy RealEstate wykazują silną zależność liniową


# Dodanie kolejnych warstw, model złożony z 7 ukrytych neuronów
set.seed(123)
google.nn2<-neuralnet(RealEstate~Unemployment+Rental+Mortgage+Jobs+Investing+DJI_Index+StdDJI, data=training_set, hidden = 7)
plot(google.nn2)
google_pred2<-compute(google.nn2, test_set)
pred_results2<-google_pred2$net.result
MSE(pred_results2,test_set$RealEstate)
cor(pred_results2, test_set$RealEstate)


# Dodanie kolejnych warstw
set.seed(123)
google.nn43<-neuralnet(RealEstate~Unemployment+Rental+Mortgage+Jobs+Investing+DJI_Index+StdDJI, data=training_set, hidden = c(4,3,3))
plot(google.nn43)
google_pred43<-compute(google.nn43, test_set)
pred_results43<-google_pred43$net.result
MSE(pred_results43, test_set$RealEstate)
cor(pred_results43, test_set$RealEstate)



#Jednakże, ta ulepszona sieć neuronowa może skomplikować interpretację wyników (lub może nadmiernie 
  #dopasować sieć do wewnętrznego szumu w danych).
#Widzimy, że nie uzyskaliśmy poprawy w modelu, zatem możemy nie komplikować sieci.