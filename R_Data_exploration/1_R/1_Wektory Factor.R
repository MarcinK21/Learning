# WEKTORY ------------------------------------------------------------
# sample() -----------------------------------------------------------------
# działanie funkcji sample -> generowanie wektorów losowych

sample(500, 30) 
x1=sample(2:10, 4) 
x1
x2=sample(1:20, 25, rep=TRUE)
x2 

# set.seed ----------------------------------------------------------------
# działanie funkcji set.seed -> umozliwia losowanie tych samych wartości

set.seed(24)
sample(500,30)
set.seed(24)
sample(500,30)

# funkcje sample mozna wykorzystywać róWnież do losowania obiektów, które
# nie są liczbami
# PRZYKŁAD z wybieraniem kolorowych cukierków z pudełka
# funckcja c -> łączy argumenty

candy =c("blue", "green", "red")
sample(candy, 20, replace = TRUE) # replace = TRUE, pozwala na powtarzanie się wyników

# Można również przy losowaniu wykorzystać rozkład prawdopodobieństwa 
sample(candy, 20, replace = T, prob = c(0.7, 0.2, 0.1))
# tutaj 70% szans na "blue", 20% na "green" i 10% na "red"


# rnorm() ----------------------------------------------------------------
# funkcja rnorm(n) generuje n niecałkowitych liczb

rnorm(5)


# Operacje na wektorach ------------------------------------------------

v1 = c(3,8,200)
v2= 101
t = 1:90
v1 %in% t
v2 %in% t


# Indeksy wektora ------------------------------------------------------------
# Dostęp do elementów wektora odbywa się przy użyciu operatora indesku []

x = (1:5) ^ 2
x
x[1]
x[2:3]
x[c(2, 4)]
x[c(2, 4, 4)]

# Wektor o indeksach ujemnych oznacza wartości do wykluczenia

x[-1]
x[-(2:3)]
x[c(-1,2)] #error
x[0] 
x[-(1:4)]<- 100

# Do indeksowania elementów wektora mozna wykorzystać nazwy

x = c(
  first = 1,
  second = 2,
  third = 3,
  fourth = 4,
  fifth = 5
)
x["second"]


# lub

p<-3:8
names(p)<- c("first", "second", "third", "fourth", "fifth")
p

# Indeks może być również wyrażeniem logicznym, w którym to przypadku
# zwracane są elementy, dla których wyrażenie ma wartość TRUE

x<- c(22,-5,5,90,-3,-4,4,17)
x[x>0]
x[x %% 2 == 0 & x>4]
z<-x[(x<-4) | (x>=22)]


# which() --------------------------------------------------------
# Funkcja which() zwraca indeksy, dla których warunek ma wartość TRUE

which(x>10)

#which.min i which.max pozwalają wyszukać indeksy minimum lub maksimum.

which.min(x)
which.max(x)

# paste()
# funkcja paste() przyjmuje dowolną liczbę argumentów i łączy je
# jeden po drugim w jeden ciąg znaków

char.vec = paste(c("a", "b"), 1:10, sep = "")
char.vec

# Wektor liter

char.vec.2 <- letters[1:26]
char.vec.3 <- LETTERS[1:26]

char.vec.2
char.vec.3


# WPISYWANIE MAŁYCH ZBIORÓW DANYCH ----------------------------

Wingcrd <- c(59, 55, 53.5, 55, 52.5, 57.5, 53, 55)
Wingcrd
Tarsus <- c(22.3, 19.7, 20.8, 20.3, 20.8, 21.5, 20.6, 21.5)
Tarsus
Wt <- c(9.5, 13.8, 14.8, 15.2, 15.5, 15.6, 15.6, 15.7)
Wt

# Zadanie

Head <- c(31.2, 30.4, 30.6, 30.3, 30.3, 30.8, 32.5, NA)
Head


# Funckje statystyczne sum mean max min median var sd ---------

# Suma długości skrzydeł
S.win <- sum(Wingcrd)
S.win

sum(Head)
# nie działa, bo w zbiorze jest wartość NA i program nie wie jak to zsumować
# Wystarczy wpisać parametr na.rm = TRUE i program już sobie poradzi

sum(Head, na.rm = TRUE)


# MACIERZE ------------------------------------------------
# cbind() ------------------------------------------------
# Tworzymy z tych danych macierz

Z <- cbind(Wingcrd, Tarsus, Head, Wt)
Z

# Poruszanie się po macierzy, dostęp do określonych części macierzy

Z[, 1]
Z[1 : 8, 1]
Z[2, ]
Z[2, 1:4]

Z[1, 1]
Z[, 2 : 3]
X <- Z[4, 4]
Y <- Z[, 4]
W <- Z[, -3]
D <- Z[, c(1, 3, 4)]
E <- Z[, c(-1, -3)]

# Sprawdzam rozmiar Z

dim(Z)

Z[, 1]
# Domyślnie R zawsze próbuje możliwie uprościć obiekty do najmniejszej
# liczby możliwych wymiarów. Zatem, gdy używamy nawiasów do wyodrębnienia
# pojedyńczą kolumnę lub wiersz, R zwróci jako wektor, uproszczając wymiar
# Jak sobie z tym poradzić? parametr drop

Z[, 1, drop = FALSE]


# Zamiast funkcji cbind()(column) można użyć rbind()(row)


Z2 <- rbind(Wingcrd, Tarsus, Head, Wt)
Z2



# FACTOR ------------------------------------------------------------

# Faktor - czynniki
# Typ factor - to typ wektorowy przeznaczony głownie do przechowywania
# danych jakościowych. Zawiera dodatkową informację o różnych 
# klasach(przypisanych nazwach) danych oraz częstości ich występowania

# Do przkeształcania wektora do typu factor służy funkcja factor()

# factor() ----------------------------------------------------------

(wzrost <- rep(c("niski", "średni", "wysoki"), c(4, 3, 5)))

(factor_wzrost<-factor(wzrost))

# Zasady przekształcania na typ factor
  # 1.wyznaczanie zbioru wartości - levels - (podział na klasy);
  # 2.przyporządkowanie kolejnych wartości naturalnych każdej klasie;
  # 3.przekododowanie wektor, tak aby zawierał informacje o numerach poziomów a nie o nazwach.

# Factors, to wektory liczb całkowitych z ustawionym atrybutem levels

# Często wykorzystywane funckje
  # 1. levels - do nadawania/odczytu różnych klas z danych
  # 2. table, summary - do odczytu częstości.

levels(factor_wzrost)
table(factor_wzrost)
summary(factor_wzrost)


# funckja odwrotna do funkcji factor() jest as.vector()

# as.vector() ----------------------------------------------------

as.vector(factor_wzrost)
as.integer(factor_wzrost)


faktor <- factor(c(2,3,4), levels=1:5)
print(faktor)
levels(faktor)<-c("zły","może być","przeciętny","dobry","idealny")
print(faktor)
as.numeric(faktor)


# Na typie faktor ZABRONIONE są działania arytmetyczne

faktor2 <- factor(c(2,3,2,2,3,4), level = 1:5)
print(faktor2)
x<- faktor2+2   # BŁĄD ! DZIAŁANIE ARYTMETYCZNE

# Próba podstawienia pod zmienną, ze zdefiniowanymi kategoriami, elementu 
# niezdefiniowanego w atrybucie levels kończy się błędem, a wartość 
# tego elementu będzie nieokreślona NA

faktor[3] <- "nijaki"


# cut() ------------------------------------------------------

# Funkcja cut() używając typu factor można dokonać podziału wektora.
# Służy do tego funkcja cut, która tworzy factor z podanego wektora,
# dzieląc go na przedziały

wiek <- sample(1:100, 16, replace = TRUE)
wiek
cut(wiek, c(0, 18, 26, 100))
kat_wiekowe <-cut(wiek, c(0, 18, 26, 100))
table(kat_wiekowe)

cut(wiek,7)




# Factor - konwersja na wartości ------------------------

x<-factor(c(3.33,4.44,5.55,3.33,3.33,3.33))
as.numeric(x)
as.vector.factor(x)
as.numeric(levels(x))[x]
levels(x)[x]
levels(x)[c(10,1,1,1)]

# Do konwersji mozna wykorzystać pakiet varhandle

install.packages("varhandle")
library(varhandle)
y = unfactor(x)
y
