# Identyfikacja i usuwanie danych zduplikowanych ------------------------------------------------------------

  # 1. Z pakietu bazowego R:
    # duplicated() - do identyfikacji identycznych obserwacji
    # unique() - do uzyskania różnych obserwacji
    # anyDuplicated() - numer pierwszego elementu(obserwacji) powtarzającej się

  # 2. Z pakietu dplyr:
    # distinct() - do usuwania zduplikowanych obserwacji

library(tidyverse)

x<-c(1, 1, 2, 2, 3, 3, 1, 4)
x
duplicated(x)
(xu <- x[!duplicated(x)])

# obliczane od końca
(xu2 <- x[!duplicated(x, fromLast = TRUE)])
(xu3<-anyDuplicated(x))
anyDuplicated(x, fromLast = TRUE)

unique(x)

# Przykład dla zbioru iris

duplicated(iris)
duplicated(iris[1:4])
(xu <- duplicated(iris))
TRUE %in% xu
iris[duplicated(iris),]
iris%>%
  distinct()

#liczba obserwacji dla których Petal.Width<2
iris%>%
  distinct()%>%
  filter(Petal.Width<2)%>%
  summarise( n=n())

#Jaka jest różnica pomiędzy:   
  
  unique(iris)
distinct(iris)

summary(unique(iris))
summary(distinct(iris))
