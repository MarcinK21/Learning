# GRUPOWANIE HIERARCHICZNE

#Metody hierarchiczne pozwalają na obserwację algorytmu grupowania, ponieważ przedstawiają strukturę klasteryzacji w 
  # postaci drzewa (dendrogramu). 

#W dendrogramie każdy liść odpowiada jednemu obiektowi. W miarę przesuwania się w górę drzewa, obiekty,
  # które są do siebie podobne, łączone są w gałęzie, które same są łączone na wyższej wysokości. 
  # Wysokość łączenia  podana na osi pionowej, wskazuje na (nie)podobieństwo/odległość pomiędzy 
  # dwoma obiektami/klastrami. Im wyższa wysokość łączenia, tym mniejsze podobieństwo obiektów.

#Wysokość ta jest znana jako odległość kopenetyczna(cophenetic) pomiędzy dwoma obiektami.


# Zbiór Swiss ------------------------------------------------------------------------------------

library(cluster)
library(factoextra)

df <- swiss
df.scaled <- scale(df)
m.odleglosci <- dist(df.scaled) 



# Pierwsze drzewo
drzewo.swiss<-hclust(m.odleglosci, method="complete")  # metoda complete -> to wartość domyślna

fviz_dend(drzewo.swiss, cex = 0.5 , main = "Drzewo zbioru swiss - complete")
fviz_dend(drzewo.swiss, k=3, cex = 0.5 , main = "Drzewo zbioru swiss - complete") # wartość k -> koloruje drzewo liczbą grup



# Drugie drzewo - metryką ward, wyznacza wirtualny środek(?)
drzewo.swiss2<-hclust(m.odleglosci, method="ward.D2")

fviz_dend(drzewo.swiss2, cex = 0.5 , main = "Drzewo zbioru swiss - ward")
fviz_dend(drzewo.swiss2, k=3, cex = 0.5 , main = "Drzewo zbioru swiss - ward") # z podziałem na 3 grupy
fviz_dend(drzewo.swiss2, k=4, cex = 0.5 , main = "Drzewo zbioru swiss - ward")  # z podziałem na 4 grupy



# Trzecie dzewo, 
drzewo.swiss3<-hclust(m.odleglosci, method="single")

fviz_dend(drzewo.swiss3, cex = 0.5 , main = "Drzewo zbioru swiss - single")



# Czwarte drzewo
drzewo.swiss4<-hclust(m.odleglosci, method="average")

fviz_dend(drzewo.swiss4, cex = 0.5 ,k=3, main = "Drzewo zbioru swiss - average")



# Jak wybrać drzewo? Wspieramy się dodatkową metryką:

  #Po połączeniu obiektów w zbiorze danych w hierarchiczne drzewo klastrów, możemy ocenić, czy odległości (tj. wysokości) w drzewie odzwierciedlają oryginalne odległości w zbiorze.
    #Korelacja pomiędzy odległościami cophenetic i oryginalnymi danymi jest jednym ze sposobów pomiaru poprawności grupowania.

  #Jeśli klastrowanie jest poprawne, łączenie obiektów w drzewie klastrów powinno mieć silną korelację z odległościami pomiędzy obiektami w oryginalnej macierzy odległości.
    #Im wartość współczynnika korelacji jest bliższa 1, tym dokładniej rozwiązanie klastrowania odzwierciedla dane. Wartości powyżej 0,75 są uważane za dobre.

  #Funkcja bazowa R cophenetic() może być użyta do obliczenia odległości kopenetycznej dla grupowania hierarchicznego.


dist.coph <- cophenetic(drzewo.swiss)
dist.coph[1:25]
cor(m.odleglosci, dist.coph )


dist.coph <- cophenetic(drzewo.swiss)
dist.coph[1:25]
cor(m.odleglosci, dist.coph )


dist.coph <- cophenetic(drzewo.swiss2)
cor(m.odleglosci, dist.coph )


dist.coph <- cophenetic(drzewo.swiss3)
cor(m.odleglosci, dist.coph )


dist.coph <- cophenetic(drzewo.swiss4)
cor(m.odleglosci, dist.coph )


# Grupowanie

grupy.swiss<-cutree(drzewo.swiss4,3)
table(grupy.swiss)

grupy.swiss<-cutree(drzewo.swiss4,4)
fviz_dend(drzewo.swiss4, cex = 0.5, k=4, main = "Drzewo zbioru swiss - average")
table(grupy.swiss)

swiss4<-cbind(swiss,grupy.swiss)
aggregate(swiss4, by=list(cluster = grupy.swiss), mean)

library(dplyr)

swiss4%>%
  filter(grupy.swiss==3)

fviz_cluster(list(data = df.scaled, cluster = grupy.swiss),
             ellipse.type = "convex",
             repel = TRUE,
             main = "Klastry w Swiss4",
             show.clust.cent = FALSE, ggtheme = theme_minimal())



# WIZUALIZACJE DENDOGRAMU --------------------------------------------------------------------------------

fviz_dend(drzewo.swiss4, cex = 0.5, horiz = TRUE, k=4, main = "Drzewo zbioru swiss - average")


fviz_dend(drzewo.swiss4, cex = 0.5, k = 4,
          type = "circular")


require("igraph")
fviz_dend(drzewo.swiss4, k = 4, k_colors = "jco",
          type = "phylogenic", repel = TRUE)


require("igraph")
fviz_dend(drzewo.swiss4, k = 4, 
          k_colors = "jco",
          type = "phylogenic", repel = TRUE,
          phylo_layout = "layout.gem")


plot(drzewo.swiss4)

#Ddendextend 
  #Pakiet dendextend dostarcza funkcji do łatwej zmiany wyglądu dendrogramu oraz do porównywania dendrogramów.

install.packages("dendextend")
library(dendextend)

dend <- swiss %>% 
  scale %>% 
  dist %>% 
  hclust(method = "average") %>% 
  as.dendrogram 

plot(dend)

