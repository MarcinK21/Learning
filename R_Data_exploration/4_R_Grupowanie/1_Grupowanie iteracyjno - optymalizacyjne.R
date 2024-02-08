# Grupowanie iteracyjno - optymalizacyjne ------------------------------------------------------------------------

# W każdej metodzie grupowania oczekujemy, że powstaną klastry maksymalnie zwarte i maksylanie rozłączne


# ALGORYTM K-ŚREDNICH   (k-means)

# Przykład

# Aby zbudować model k-średnich w R używamy funkcji:
    # kmeans()

# prosta ramka danych

df=data.frame(punkt=letters[1:8],
              x=c(1,3,4,5,1,4,1,2),
              y=c(3,3,3,3,2,2,1,1))

plot(df$x,df$y,pch=15,col="skyblue",cex=4)


install.packages("cluster")
library(cluster)

km <- kmeans(df[-1], 3)

col = c("blue", "darkgreen", "darkred")

plot(df$x,df$y, pch=20, col=col[km$cluster],cex=4, main = "grupowanie")


km$centers   # współrzędne środków

points(km$centers, pch=8, cex=3, col="black", lwd=3)



km$betweenss #Suma kwadratów odległości między klastrami,
km$totss #Całkowita suma kwadratów odległości
km$tot.withinss #Całkowita suma kwadratów odległości wewnątrz klastra (inaczej nazywane odchyleniem wewnątrzklastrowym WCSS)
km$withinss #Wektor sumy kwadratów wewnątrz klastra, jeden składnik na klaster.
km$size #liczba obserwacji w klastrze



# Zbiór Swiss ---------------------------------------------------------------------------------

df1 <- swiss

summary(df1)

df.scaled <- scale(df1)


# Liczba klastrów - metoda łokcia ------------------------------------------------------------
# Metoda łokcia - basic

# type = b punkty połączone liniami

k.max <- 15 

wss <- sapply(1:k.max, function(k){kmeans(df.scaled , k, nstart = 50)$tot.withinss})

plot(1:k.max, wss, type = "b", pch = 19, 
     xlab = "liczba klastrów - k", 
     ylab = "Suma kwadratóW odległości wewnątrz klastra")



# metoda łokcia pakiet factoextra ------------------------------------------------------------

install.packages("factoextra")
library(factoextra)

fviz_nbclust(df.scaled , kmeans, method = "wss") +
  geom_vline(xintercept = 4, linetype = 2)+
  labs(subtitle = "Łokieć")



# Metoda sylwetki --------------------------------------------------------------------------------

# Metoda sylwetki (sillhouette), to metoda która dla każdej obserwacji wskazuje na ile blisko znajduję się obserwacja w grupie
  # w stosunku do wszystkich pozostałych z innej, najbliższej grupy
# Miara sylwetki porównuje średnią odległość do elementów w tym samym klastrze ze średnią odległością do elementów w innym klastrze.
# Im wyższa wartość tego parametru tym lepsza klastryfikacja. Indeks sylwetki dobrze się sprawdza m.in. w metodzie k-średnich.
  # gdzie znajduje zastosowanie do określania optymalnej liczby klastrów oraz oceny klastryfikacji


# Każdej obserwacji x przyporządkowywana jest liczba -> wzór na stronie  ( s = b(x) - a(x) ) / max{a(x),b(x)}

# gdzie a(x) to średnia odległość między x, a wszystkimi innymi punktami w klastrze
# b(x) to minimum średnich odległości między x a punktami w innych klastrach

# Jeżeli wartość dla obserwacji jest bliska 1, oznacza to że obserwacja została dobrze przypisana do grupy, w której jest
# Jeżeli wartość jest bliska -1, to znaczy że obserwacja pasuje do sąsiedniej grupy. 
# Wartości w okolicach 0 informują że obserwacja leży na granicy dwóch klastrów

# Przy wyznaczaniu liczby klastrów szukamy maksimum

fviz_nbclust(df.scaled, kmeans, method = "silhouette")+
  labs(subtitle = "Metoda sylwetki zbiór skalowany")



# Metoda "gap statistics" ------------------------------------------------------------------------------------------------

fviz_nbclust(df1, kmeans, nstart = 25, method = "gap_stat", nboot = 50)+
  labs(subtitle = "Gap")

# Funkcja NbClust

install.packages("NbClust")
library(NbClust)

#min.nc, max.nc - minimalna i maksymalna liczba klastrów
liczba<- NbClust(df.scaled, distance="euclidean", min.nc=2, max.nc=10,
                 method="kmeans", index="all")

liczba$Best.nc
liczba$Best.partition

liczba2<- NbClust(df, distance="euclidean", min.nc=2, max.nc=10,
                  method="kmeans", index="all")


# Heatmap ----------------------------------------------------------------------------------------------------------------

# Mapa ciepła jest techniką wizualizacji danych, która pokazuje wielkość zjawiska jako kolor w dwóch wymiarach
# Istnieją dwie zasadniczo różne kategorie map ciepła:
    # Klastrowa mapa ciepła
    # Przestrzenna mapa ciepła
# W klastrowej mapie ciepła, wielkości są ułożone w matrycy o stałej wielkości komórek, których wiersze i kolumny są dyskretnymi
  # zjawiskami i kategoriami, sortowanie wierszy i kolumn jest celowe i nieco arbitralne, w celu sugerowania klastórw lub
  # przedstawiania ich jako odkrytych poprzez analizę

fviz_dist(dist(df.scaled))

fviz_dist(dist(df))



# Algorytm k-średnich w R ------------------------------------------------------------------------------------------

# W funkcji kmeans() określamy nstart = 25  Oznacza to, że R będzie próbował 25 różnych losowych wartości początkowych dla 
  # środków, a następnie wybierze najlepszy wynik odpowiadający temu, który ma najmniejsze zróżnicowanie wewnątrz klastra

# Domyślna wartością jest nstart =  1   Zaleca się wyznaczanie grup k-means z duża wartością nstart, np. 25 lub 50 
  # aby uzsykać stabilne wyniki


set.seed(123) 

grupy.km <- kmeans(df.scaled, centers = 3, nstart=25)

grupy.km$cluster
grupy.km$centers
grupy.km$size
grupy.km$withinss # pokazuje jak blisko są obiekty w klastrach


# Uzyskane grupy

swiss2<-cbind(swiss,grupy.km$cluster)
aggregate(swiss2, by=list(cluster = grupy.km$cluster), mean)

# lub 

library(dplyr)

swiss%>%
  mutate(klastry=grupy.km$cluster)%>%
  group_by(klastry)%>%
  summarise_all("mean")



# Kilka wykresów
    # Pakiet cluster

clusplot(df.scaled, grupy.km$cluster, color=TRUE, shade=TRUE,
         labels=2, lines=0)


    # Pakiet factoextra

fviz_cluster(grupy.km, data = df.scaled,geom = c("point", "text"), main = "Klastry w Swiss1")


fviz_cluster(grupy.km, data = df.scaled,geom = c("point", "text"),repel = TRUE, ellipse.type = "confidence", 
             ellipse.level = 0.95, main = "Klastry w Swiss2")


fviz_cluster(grupy.km, data = df.scaled, choose.vars = c("Fertility", "Catholic"), 
             main = "WYkres grupowania", 
             ggtheme = theme_classic())


fviz_cluster(grupy.km, data = df1, choose.vars = c("Fertility", "Catholic"), 
             stand = TRUE, geom = c("point", "text"), 
             repel = TRUE, ellipse.type = "confidence", 
             ellipse.level = 0.95, main = "WYkres grupowania", 
             ggtheme = theme_classic())



# Walidacja uzyskanych grup
# Po wykonaniu grupowania należy ocenić uzyskane grupy. Najczęściej używane metody uwzględniają odległości obiektów od środków
    # (lub centroidów) klastrów w stosunku do odległości pomiędzy klastrami. Można porównywać błędy SSE oraz 
    # odległości pomiędzy klastrami oraz miarę silhuuette



# Metoda sylwetki ------------------------------------------------------------------------------------------------------------

# z pakietu cluster

kms = silhouette(grupy.km$cluster,dist(df.scaled))

summary(kms)
plot(kms)


# Funkcja eclust

# Do walidacji wygodnie używać funkcji eclust(), umożliwaiającej stosowanie różnych algorytmów grupowania.

grupy.eclust<- eclust(df1, "kmeans", k = 3, stand = TRUE, nstart = 25, graph = FALSE)

grupy.eclust$cluster
grupy.eclust$centers
grupy.eclust$nbclust

#wykres dla klastrów

fviz_cluster(
  grupy.eclust,
  data = df.scaled,
  geom = c("point", "text"),
  repel = TRUE,
  ellipse.type = "confidence",
  ellipse.level = 0.95,
  main = "Walidacja grupowania eclust"
)


# Metoda sylwetki z eclust 

fviz_silhouette(grupy.eclust, palette = "jco", ggtheme = theme_classic())

fviz_silhouette(grupy.eclust)


# Obserwacje w złej grupie

silinfo <- grupy.eclust$silinfo

silinfo

sil <- grupy.eclust$silinfo$widths

ujemne <- which(sil$sil_width < 0)

sil[ujemne, , drop = FALSE] 

rn<-rownames(sil[ujemne, , drop = FALSE] )

swiss[rn,]

fviz_cluster(grupy.eclust, geom = "point", ellipse.type = "norm", ggtheme = theme_minimal())


library(dplyr)

swiss2 %>% 
  group_by(grupy.km$cluster) %>%
  summarise(
    liczba = n(),
    plodnosc=mean(Fertility),
    rolnictwo=mean(Agriculture),
    egzamin=mean(Examination),
    katolik=mean(Catholic),
    edukacja=mean(Education)
  )



# Algorytm PAM ( Partitioning Around Medoids) - algorytm k-medoidów w R

# Aby zbudowac model k-medoidów w R używamy standardowej funkcji języka pam()


fviz_nbclust(df.scaled , pam, method = "wss") +
  labs(subtitle = "łokieć pam")

fviz_nbclust(df.scaled, pam, method = "silhouette")+
  labs(subtitle = "metoda sylwetki pam")
fviz_nbclust(df.scaled, pam, method = "gap_stat")+ 
  labs(subtitle = "gap pam")


grupy.pam <- pam(df, 3,stand = TRUE) 
grupy.pam
grupy.pam$clusinfo
grupy.pam$medoids
grupy.pam$id.med #numery medoidów
grupy.pam$clustering #numery grup
swiss3<-cbind(swiss,grupy.pam$clustering)
aggregate(swiss3, by=list(cluster = grupy.pam$clustering), mean)

#wykres klastrów

fviz_cluster(grupy.pam, df1, stand = TRUE, geom = c("point", "text"), repel = TRUE, main = "Grupowanie PAM",
             ggtheme = theme_classic())

#walidacja klastrów

fviz_silhouette(grupy.pam, ggtheme = theme_classic())
silinfo.pam <- grupy.pam$silinfo
silinfo.pam
swiss3["Vevey",]












