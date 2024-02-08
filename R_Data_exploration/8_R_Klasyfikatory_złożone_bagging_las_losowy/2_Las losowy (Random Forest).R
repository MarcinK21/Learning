# Las losowy (Random Forest)

# Częstość powtórzeń w próbkach
  # Generujemy dwa zestawy wylosowanych ze zwracaniem liczb (bootstrap)
  # Ile może być powtrzających się liczb, wylosowanych w obu zestawach?

N <- seq(1e3,1e4,1e3)
N
pr.wspolnych <- NULL
index <- 1

for(i in N){
  print(i)
  temp_prob <- NULL
  for(j in 1:100){
    s1 <- sample(i,size=i,replace=TRUE)
    s2 <- sample(i,size=i,replace=TRUE)
    temp_prob <- c(temp_prob,length(intersect(s1,s2))/i)
  }
  pr.wspolnych[index] <- mean(temp_prob)
  index <- index + 1
}

pr.wspolnych

# P-stwo bootstrapowe wyraznie pokazuje, że około 40% oberswacji będzie wspólne dla 
  # dowolnych dwóch drzew. W związku z tym drzewa te będą skorelowane


# Las losowy
  # Las losowy używa dwóch parametrów ntree(liczba drzew) i mtree(liczba atrybutów)
    # liczba atrybutów - używanych do znalezienia najlepszego podziału, podczas gdy
    # bagging wykorzystuje tylko ntree jako parametr. Dlatego jeśli ustawimy mtree równe
    # liczbnie atrybutów, to las losowy jest równy bagging

# Zalecane wartości podziału, to dla p-zmiennych w zbiorze, to (√p) (klasyfikacja) lub p3 (regresja).

#install.packages("randomForest")
library(randomForest)
set.seed(2022)
gc.rf.1 <- randomForest(credit_risk~.,data=gc.Train,ntree=500)
gc.pred.1<- predict(gc.rf.1,newdata = gc.Test,type="class")
table(gc.pred.1,gc.Test$credit_risk)
acc.rf=acc(gc.pred.1,gc.Test$credit_risk)
acc.rf
roc.function(gc.pred.1,gc.Test$credit_risk)


# Analiza modelu lasu losowego

# Wykres błędu średnio kwadratowego OOB w rf

gc.rf.1$err.rate
plot(gc.rf.1)
gc.rf.1.legend <- colnames(gc.rf.1$err.rate)
legend(x=300,y=0.5,legend = gc.rf.1.legend,lty=c(1,2,3),
       col=c(1,2,3))

min.err <- min(gc.rf.1$err.rate[,"OOB"])
min.err
min.err.idx <- which(gc.rf.1$err.rate[,"OOB"]== min.err)
min.err.idx
gc.rf.1$err.rate[min.err.idx,]


# Im bliżej siebie linie na wykresie, tym lepszy model. Wykres narysowany jest na podstawie tablicy błędów. Informacje o błędzie są przechowywane w komponencie err.rate

head(gc.rf.1$err.rate)

# Widzimy, że obliczony błąd OOB spada szybko, a następnie spadek wartości jest niewielki (spłaszcza się). Można znaleźć najmniejszą wartość wraz z listą indeksów, w których występuje każda wartość minimalna.



# Ważność zmiennych

# Parametr importance przechowuje informacje o miarach ważności zmiennych:

gc.rf.1$importance
varImpPlot(gc.rf.1,main="Wykres istotności zmiennych\n Las losowy")

# Na ważność zmiennej wpływa jej położenie w drzewie oraz wpływ na wykonywane podziały.



# Zastosowania lasu losowego

# 1 Analiza ważności zmiennych

# Stosując funkcję min_depth_distribution możemy uzyskać rozkład głębokości zmiennych. Używając plot_min_depth_distribution, otrzymujemy wtedy wykres rozkładu minimalnej głębokości:


#install.packages("randomForestExplainer")
library(randomForestExplainer)
gc.rf.min <- min_depth_distribution(gc.rf.1)
head(gc.rf.min, n=40)
plot_min_depth_distribution(gc.rf.min,k=nrow(gc.Test))


# Niezależnie od dokładnych parametrów użytych w plot_min_depth_distribution, spojrzenie na cały rozkład minimalnej głębokości drzew, daje dużo większą możliwość odkrywania roli, jaką predyktor odgrywa w lesie.

# Funkcja measure_importance dostarcza wielu informacji o średniej minimalnej głębokości, liczbie węzłów w 500 drzewach, w których zmienna pojawia się jako węzeł, średnim spadku dokładności, spadku Giniego i tak dalej.

# Aby ją stosować należy uruchomić ponownie model lasu losowego z parametrem localImp=TRUE

gc.rf.2<- randomForest(credit_risk~.,data=gc.Train,ntree=500,localImp=TRUE)
gc.rf.2.vim <- measure_importance(gc.rf.2)
?measure_importance
gc.rf.2.vim

# W kolumnach mamy miary ważności zmiennej xj. 


# Miary accuracy_decrease i gini_decrease są obliczane przez pakiet randomForest, więc muszą być wyodrębnione z obiektu rf tylko wtedy, gdy do wzrostu lasu użyto opcji localImp = TRUE. Są oparte na zmianach w czystości węzłów po podziałach na zmienną . Kolumny 2, 3, 6 i 7 są oparte na strukturze lasu.

# Na podstawie wyników widać, że jeśli średnia minimalna głębokość jest wyższa, związana z nią wartość p jest również wyższa, a zatem zmienna jest nieistotna. Podobnie niższe wartości gini_decrease są również związane z wyższymi wartościami p, co wskazuje na nieistotność zmiennych.


# Przykładowe wykresy zależności

plot_multi_way_importance(gc.rf.2.vim, size_measure = "no_of_nodes")
plot_multi_way_importance(gc.rf.2.vim, size_measure = "mean_min_depth")
plot_multi_way_importance(gc.rf.2.vim, size_measure = "no_of_nodes",
                          x_measure="mean_min_depth",
                          y_measure = "no_of_trees")
plot_multi_way_importance(gc.rf.2.vim, size_measure = "no_of_nodes",
                          x_measure="mean_min_depth",
                          y_measure = "gini_decrease")


# Wykres relacji pomiędzy różnymi miarami ważności oraz rankingami

plot_importance_ggpairs(gc.rf.2.vim)
#Porównanie różnych rankingów
plot_importance_rankings(gc.rf.2.vim)

# Widzimy, że wszystkie przedstawione miary są silnie skorelowane.



# Predykcja lasu losowego na siatce

# Aby dokładniej zbadać interakcje pomiędzy zmiennymi można użyć funkcji plot_predict_interaction do wykreślenia predykcji naszego lasu na siatce wartości dla składowych każdej interakcji. Funkcja wymaga podania lasu, danych treningowych, zmiennej do użycia odpowiednio na osiach x i y. 

plot_predict_interaction(gc.rf.2, gc.Train, "age", "duration")
plot_predict_interaction(gc.rf.2, gc.Train, "age", "number_credits")
plot_predict_interaction(gc.rf.2, gc.Train, "number_credits", "duration")


# Podsumowanie analizy

explain_forest(gc.rf, interactions = TRUE, data = gc.Train)


# 2. Brakujące dane
  # 1.Omijanie braków danych
  # 2.na.action

a=airquality
summary(a)
a$Ozone=cut(a$Ozone,3)
levels(a$Ozone)=c("niski", "średni", "wysoki")
ozone.rf <- randomForest(Ozone ~ ., data=a, na.action=na.omit,mtry=3)
ozone.rf
ozone.rf$importance
varImpPlot(ozone.rf,main="Wykres istotności zmiennych\n Las losowy")
library(mice)
md.pattern(a)


# 3. Grupowanie

# Proximity (bliskość) między dwoma obserwacjami jest funkcją bliskości między odpowiadającymi im atrybutami dwóch obserwacjami. Miary bliskości odnoszą się do miar podobieństwa i niepodobieństwa. Parametr oob.prox liczy bliskość na OOB.

gc.rf.3 <- randomForest(x=gc, y=NULL,ntree=1000, proximity=TRUE,oob.prox = FALSE)
gc.rf.3
gc.rf.3$proximity[1:10,1:10]
dst.mx=1-gc.rf.3$proximity
mat <- as.matrix(dst.mx)
# Najbardziej podobne
gc[ which(mat == min(mat[mat != min(mat)]), arr.ind = TRUE)[1, ], ]
# Najbardziej niepodobne
gc[which(mat == max(mat[mat != max(mat)]), arr.ind = TRUE)[1, ], ]
mat[606,744]
mat[1,16]



library(cluster)
rf.hclust <- hclust(as.dist(gc.rf.3$proximity),method="ward.D2")
plot(rf.hclust)
rf.clust <- cutree(rf.hclust,k=5)
table(rf.clust,gc$credit_risk)
