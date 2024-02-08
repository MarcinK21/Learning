# Rambka tibble - są to ramki danych ---------

# tibble() konstruuje ramkę danych. Podobne użytkowanie do data.frame()

# Zwrócona ramka danych ma klasę tbl_df, oprócz data.frame

# Różnice:
#   tibble() ma wygodną funkcję print()
#   tibble() jest bardziej elastyczne pod względem przekształcania 
#            danych wejściowych użytkowanika. Wektory znaków nie są
#            przekształcane na factor
#   W kolumnach mogą znalezć się listy, macierze, inne tibble itp.
#     Nazwy kolumn nie są modyfikowane.


# Tibble, jest częścią pakietu   tidyverse

# Pakiet tidyverse ------------


install.packages("tidyverse")
library(tibble)

# Tworzenie tibble ------------

imie=c("ala","ola","ela")
data <- data.frame(a = sample(10,3),
                   b = letters[1:3],
                   c = Sys.Date() - 1:3,
                   i=imie)
data
as_tibble(data)


#ramka tibble utworzona bezpośrednio

dt=tibble(a = sample(10,3),
          b = letters[1:3],
          c = Sys.Date() - 1:3,
          i=imie)

dt


#Tibble - macierze ------------

# Tibble może wykorzystywać macierze
tibble(
  a = 1:4,
  b = diag(4),
  c = cov(iris[1:4])
)
iris


# Funkcja print ----------------
install.packages("nycflights13")  

loty=nycflights13::flights
str(loty)
summary(loty)


loty
print(loty, n = 20, width = Inf)
print(loty,n=15)


# Tibble - Trible ------------

#tibble::trible funkcja do tworzenia ramki danych wiersz po wierszu

trib=tribble(
  ~x, ~y, ~z,
  "a", 2, 1:5,
  "b", 1, 6:10
)

trib$z
trib$z[2]
trib$z[[2]]


# Odwołania do składowych

loty[,4:9]
loty[200,]
table(loty$dest)

