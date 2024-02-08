# Funkcja normalizacji i błędu

# Funkcja normalizacji

normalize <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}


# Funkcja błędu MSE
# https://pl.wikipedia.org/wiki/B%C5%82%C4%85d_%C5%9Bredniokwadratowy

MSE<- function(y.true, y.pred) { sum((y.true - y.pred)^2)/length(y.true)}
