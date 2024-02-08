# Testowanie ------------
# Funkcja microbenchmark jest z pakietu o takiej samej nazwie
# Domyślnie funkcja uruchamia i testuje każde wyrażenie 100 razy
# oraz dodatkowo funkcja losuje również kolejność wyrażeń

# W wyniku działania wyświetlona jest jednostka czasu, w której
# działał dany kod

# min - minimalny czas;
# lq - pierwszy kwartyl;
# mean - średni czas;
# median - mediana;
# uq - trzeci kwartyl;
# max - maksimum;

install.packages("microbenchmark")
library(microbenchmark)
x <- runif(1000000)
microbenchmark(sqrt(x), x ^ 0.5)
# Zdecydowanie szybciej działa funckja sqrt



# Wyznaczanie najmniejszej wartości wektora ------------

min.while<-function(x){
  m<-x[1]
  i<-2
  n<-length(x)
  while(i<=n){
    if(x[i] < m) m <- x[i]
    i<-i+1
  }
  return (m)
}




min.for.element<-function(x){
  m <- x[1]
  for(e in x) if(e < m) m <-e
  return (m)
}



min.for.indeks<-function(x){
  m<-x[1]
  for(i in 2:length(x)) if(x[i] < m) m <-x[i]
  return (m)
}



min.for.indeks<-function(x){
  m<-x[1]
  for(i in 2:length(x)) if(x[i] < m) m <-x[i]
  return (m)
}


x<-sample(10000)


(min(x))
(min.while(x))
(min.for.element(x))
(min.for.indeks(x))
microbenchmark(min(x),min.while(x),min.for.element(x),min.for.indeks(x))

