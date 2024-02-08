# Częstość przedmiotów(produktów) ------------------------------------

# Częstość występowania produktów -
    # Funkcja itemFrequency()

# Najczęstsze produkty dla data.csv

itemFrequency(dane.tr1.read.v2, type = "absolute")

najczestsze.produkty = as.data.frame(sort(itemFrequency(dane.tr1.read.v2, type = "absolute")
                                          , decreasing = TRUE)) # liczność produktów
#najczestsze.produkty

names(najczestsze.produkty) = c("licznosc")
najczestsze.produkty.proc = as.data.frame(sort(itemFrequency(dane.tr1.read.v2, type = "relative")
                                               , decreasing = TRUE)) # dane procentowe

# Wykresy 

itemFrequencyPlot(dane.tr1.read.v2,
                  topN = 30,
                  type = "absolute")

itemFrequencyPlot(dane.tr1.read.v2,
                  topN = 30)

itemFrequencyPlot(
  dane.tr1.read.v2,
  topN = 30,
  support = 0.03,
  col = rainbow(18),
  horiz = T
)

itemFrequencyPlot(dane.tr1.read.v2,
                  topN = 20, 
                  horiz = T)



# Generowanie zbiorów algorytmem apriori() ---------------

# Zbiory częste

parameters = list(
  support = 0.01,
  minlen = 2,
  maxlen = 10,
  target =  "frequent itemsets"
)


# użycie funkcji apriori do generowania zbiorów częstych target = "frequent itemsets"

freq.items <- apriori(dane.tr1.read.v2,
                      parameter = parameters)

summary(freq.items)


zbiory.czeste.df <- data.frame(zbiory = labels(freq.items),
                               wskaźniki = freq.items@quality)


banany<-subset(zbiory.czeste.df,
               grepl("Banana",zbiory,fixed = TRUE))


# Algorytm Eclat - pozwala znalezć zbiory często występujące
    # ta funkcja robi dokładnie to samo 

zbiory.eclat<- eclat(dane.tr1.read.v2, 
                     parameter=list(support=0.02, minlen=2))

inspect(sort(zbiory.eclat, 
             by="support")[1:5])

summary(zbiory.eclat)



