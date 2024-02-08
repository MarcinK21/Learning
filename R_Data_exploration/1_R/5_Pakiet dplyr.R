# Pakiet dplyr ------------

# Dplyr to pakiet ułatwiający/umożliwiający manipulowanie danymi

# Przykładowe funkcje pakietu:

    # select() - wybór dowolnych kolumn
    # pull()   - wybór kolumn - odpowiednik operatora $
    # filter() - wybór wierszy
    # mutate() - kolumna obliczana, na podstawie innej kolumny
    # group_by() - dzieli dane na grupy
    # summarize() - generuje podsumowania


install.packages("dplyr")  # Instalowanie pakietu
library("dplyr")

# Pierwszy przykład - Star Wars

summary(starwars)
sw=starwars
select(starwars, species, name,height, mass, homeworld )
filter(starwars, species == "Human")
filter(starwars, mass > 70)
filter(starwars, hair_color == "none" & eye_color == "black")



 # Drugi przykład -  lotnisko

l=select(loty, flight, origin,dest, distance)
filter(l, origin=="JFK")

select(iris,1,3,5)
pull(iris,1)
iris$Sepal.Length
pull(iris,-5)
select(iris,-5)


# Pipe %>% lub nowa wersja |>   ------------

# Potoki, to konstrukcje, które pozwalają pobrać dane wyjściowe jednej
  # funkcji i wysłać ją bezpośrednio do następnej.
  # Najczęściej, wykorzystuje się je gdy użytkownik używa wielu funkcji 
  # na jednym zbiorze danych.


# Przykład 1 

pi %>% sin %>% cos
cos(sin(pi))

starwars %>%
  filter(species =="Human") %>%
  select(name, height, mass, homeworld) %>%
  head()

# Teraz robimy to samo tylko bez operatora pipe
# Musimy zacząć od końca

head(select(filter(starwars, species == "Human"), 
            name, height, mass, homeworld))



# Inne przykłady

# Pierwszy przykład

t4<-read.csv("http://imul.math.uni.lodz.pl/~bartkiew/med/dane/titanic.csv", stringsAsFactors = T)

summary(t4)

t4%>%
  filter(Sex=="male" & Survived ==1)%>%
  select(Name,Age)%>%
  head()

# Drugi przykład 

summary(iris)
iris%>%
  filter(Sepal.Length>5 & Sepal.Length<6)%>%
  select(Species)%>%
  tail(n=10)


# Trzeci przykład

starwars %>%
  filter(species == "Human") %>%
  select(name,height, mass, homeworld)


# Czwarty przykład

sw.droid<-starwars %>%
  filter(species == "Droid") %>%
  select(name,height, mass, homeworld)  



# Inne operatory typu pipe

# Operatory są stosowane w pakietach magrittr/dyplr/tidyverse


lhs %>% rhs # oznacza rhs(lhs)
    
lhs %<>% rhs # oznacza lhs <- rhs(lhs) (operator assignment pipe)

lhs %T>% rhs # oznacza { rhs(lhs); lhs} (operator tee)



# "Zwykły" potok

runif(100) %>%
  matrix(ncol = 2) %>%
  print()%>%
  plot(cex=2,col=3,pch=16)


# Assignment pipe

x <- sample(-10:10,10)
x
x %<>% abs %>% sort
x


# Potok tee - Stosowany jest w przypadku rozgałęzień, najczęściej do 
    # rysowania wykresów

sample(10,10) %>%
  matrix(ncol = 2) %>%
  print()%T>%
  plot(cex=2,col=3,pch=16) %>%
  colSums()



# Funkcja mutate ------------

x=mutate(starwars,wysokosc=height/2.5)

starwars%>%
  mutate(wysokosc.w.calach=height/2.5) %>%
  head()

starwars%>%
  mutate(wysokosc.w.calach=height/2.5) %>%
  select(name,wysokosc.w.calach,homeworld, mass) %>%
  filter(!is.na(mass)) %>%
  head(n=10)


# Funkcja group_by i summarize(sumarise) ------------

# Funkcja groupy_by() dzieli dane na grupy. 
# Gdy dane są pogrupowane funkcji summarize() można użyć do uzyskania
# podsumowania każdej grupy, w jednym wierszu.
# W funkcji summarize() można sotsować różne funkcje agregujące.

# Przydatne funkcje:

  # miary centralne: mean(), median()
  # miary rozrzutu: sd(), IQR(), mad()
  # zakres: min(), max(), quantile()
  # pozycja: first(), last()
  # zliczanie: n(), n_disticnt()
  # logiczne: any(), all()



gatunki <- group_by(iris,Species)
summarise(gatunki,
          liczba.roznych = n_distinct(Sepal.Length),
          liczba = n()
)


# Lub to samo


iris %>%
  group_by(Species) %>%
  summarise(
    liczba.roznych = n_distinct(Sepal.Length),
    liczba = n()
  )


starwars %>%
  group_by(species) %>%
  summarise(
    liczba = n(),
    waga = mean(mass, na.rm = TRUE)
  ) %>%
  filter(liczba> 1, waga > 50)




# Inne przykłady 

summary(airquality)
airquality
str(airquality)


airquality%>%
  filter(Month==5)%>%
  mutate(temp.C=(Temp-32)/2)


airquality%>%
  mutate(temp.C=(Temp-32)/2)%>%
  select(Ozone,Solar.R,Temp, temp.C)%>%
  filter(Month==5)


airquality%>%
  group_by(Month)%>%
  summarise(
    liczba.obserwacji=n(),
    temp.min=min(Temp),
    ozon.sredni=mean(Ozone, na.rm=T)
  )


airquality%>%
  mutate(temp.C=(Temp-32)/2)%>% 
  group_by(Month)%>%
  summarise(
    liczba.obserwacji=n(),
    temp.min=min(Temp),
    temp.min.C=min(temp.C),
    temp.max.C=max(temp.C),
    ozon.sredni=mean(Ozone, na.rm=T),
    ozon.sd=sd(Ozone, na.rm=T)
  )
airquality%>%
  group_by(Month)%>%
  select(Ozone)




# Przykład dla pipe

sum(filter(l, origin=="JFK")$distance)

#albo lepiej 
loty%>%
  filter(origin=="JFK")%>%
  summarise(
    liczba_wylotow = n(),
    suma_odleglosci = sum(distance)
  )


# Przykład Rossman

library(rio)

ros <- import("data/rossmann.xlsx")

summary(ros)

# Funkcja glimpse jest odpowiednikiem str

ros%>%
  glimpse()
ros.f <- ros %>% 
  mutate(otwarty= as_factor(czy_otwarty),
         promocja = as_factor(czy_promocja),
         typ = as_factor(sklep_typ),
         asort = as_factor(sklep_asort)) %>% 
  select(sklep_id,dzien_tyg,sprzedaz,liczba_klientow,otwarty,promocja,typ,asort,sklep_konkurencja)

summary(ros.f)

which(ros.f$sprzedaz==0)


ros.f %>% 
  group_by(sklep_id) %>% 
  summarize(sum_sprzedaz = sum(sprzedaz)) %>% 
  ggplot(aes(y = sum_sprzedaz, x = sklep_id)) +
  geom_point()


ros.f %>% 
  group_by(sklep_id) %>% 
  summarize(sum_sprzedaz = sum(sprzedaz)) %>% 
  ggplot(aes(y = sum_sprzedaz, x = sklep_id)) +
  geom_boxplot()


boxplot.stats(ros.f$sprzedaz)
boxplot<-ggplot(ros.f)+
  aes( y=sprzedaz )+
  ggtitle("Rossman") +
  geom_boxplot()
boxplot



