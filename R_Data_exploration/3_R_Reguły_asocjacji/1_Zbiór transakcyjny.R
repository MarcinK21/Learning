#Zbiór transakcyjny

# Zasadniczo mamy dwie metody na utworzenie macierzy transakcyjnej
  # funkja read.transaction()
  # funkcja as()

install.packages("arules")
library(arules)


# Przygotujmy przykładowy "mały zbiór"

orders <- data.frame(
  transactionID = sample(1:500, 1000, replace = T),
  item = sample(
    c(
      "mleko",
      "kawa",
      "czekolada",
      "herbata",
      "sernik",
      "makowiec",
      "szrlotka"
    ),
    1000,
    replace = T
  )
)


orders$transactionID <- sort(orders$transactionID)

duplicated(orders)

orders <- unique(orders)

# Stwórz ramke danych, posortuj, sprawdz czy są duplikaty i ewentualnie je usuń



# Korzystamy z funkcji as()

dane.tr1<- as(split(orders$item,orders$transactionID),"transactions") 
# ten split tworzy listę produktów w jednym wierszu
# "trasactions" jest parametrem funkcji as


dane.tr1@itemInfo
dane.tr1@data
# tam gdzie produkt jest kreseczka, tam gdzie kropeczka brak produktu
summary(dane.tr1)



# TO JEST ZROBIONE ŹLE !!!!!!

oo<-as(orders,"transactions")
# wrzucona rameczka bez splita
# Trzeba o tym splicie pamiętać, bo to częsty błąd
summary(oo)
oo@itemInfo





# Rodzaje zbiorów wejściowych ------------------------------------------

# Zbiór pierwszy 

r1<-read.csv("/2 Metody eksploracji danych [E]/ĆW/3 MED - REGUŁY ASOSJACJI/dane/data.csv")

dane.tr1.r1<- as(split(r1$product_id,r1$order_id),"transactions") 
# dane zrobiły psikusa i nie działają :( także próbujemy poradzić sobie inaczej

head(dane.tr1.r1@itemInfo) # nie zadziała bo dane.tr1.r1 nie działają

dane.tr1.read.v2<-read.transactions(file = "/2 Metody eksploracji danych [E]/ĆW/3 MED - REGUŁY ASOSJACJI/dane/data.csv",
                                    format = "single", 
                                    sep = ",", header = T,
                                    cols = c("order_id", "product_id"), 
                                    rm.duplicates = FALSE,
                                    quote = "", skip = 0,
                                    encoding = "unknown")

head(dane.tr1.read.v2@itemInfo)
dane.tr1.read.v2@data

summary(dane.tr1.read.v2)
# gęstość spadła do 0.0009 -> jest malutka
# najczęstsze są banany
# rozkład koszyków: 37 koszyków po 1 produkt i 1 koszyk z 92 produktami
# Średnio prawie 16 produktów w każdym koszyku



# Zbiór drugi

r2<-read.csv("/2 Metody eksploracji danych [E]/ĆW/3 MED - REGUŁY ASOSJACJI/dane/groceries.csv",
             header = F,
             stringsAsFactors = T)

# tutaj nie potrzebujemy splita bo plik jest juz w takiej postaci ze w 
# wierszu są już wszystkie produkty dla danego koszyka :)

dane.tr2.r2 <- as(r2, "transactions")
dane.tr2.r2@itemInfo
head(dane.tr2.r2@itemInfo)

dane.tr2.read <- read.transactions("/2 Metody eksploracji danych [E]/ĆW/3 MED - REGUŁY ASOSJACJI/dane/groceries.csv", sep = ",")
dane.tr2.read@itemInfo
head(dane.tr2.read@itemInfo)






