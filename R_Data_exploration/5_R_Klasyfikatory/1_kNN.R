# SCHEMAT
  # 1. Przygotowanie danych
  # 2. Podział zb. test
  # 3. Model
  # 4. Predykcja   -> zazwyczaj będzie to funckja predict()
  # 5. Testy



# kNN ------------------------------------------------

# Tworzymy ramkę danych
skladniki <- c("jablko", "szynka", "banan", "marchewka", "seler", "mielonka")
slodycz <- c(9, 1, 10, 6, 3, 1)
chrupkosc <- c(9, 4, 1, 10, 10, 1)
typ <- c("owoce", "wedlina", "owoce", "warzywa", "warzywa", "wedlina")
artykuly <- data.frame(skladniki, slodycz, chrupkosc, typ, stringsAsFactors = FALSE)
artykuly


rysunek <- function(){
  plot(artykuly$slodycz, artykuly$chrupkosc,
       xlab="slodycz", ylab = "chrupkosc",
       xlim=c(0,12),ylim=c(0,12),
       col=as.numeric(as.factor(artykuly$typ))+1,pch=15)
  text(artykuly$slodycz, artykuly$chrupkosc, labels=artykuly$skladniki, cex= 1.2, pos=3,col=as.numeric(as.factor(artykuly$typ))+2)
}


rysunek()

artykuly[7,1]<-"pomidor" # dopisujemy pomidora
artykuly[7,2]<-6 # ustawiamy jego słodkość na 6
artykuly[7,3]<-3 # ustawiamy jego chrupkość na 3
artykuly[7,4]<-""  # pomidor nie ma typu 
artykuly$dist.pomidor <- sqrt((6-artykuly$slodycz)^2 + (3-artykuly$chrupkosc)^2)   # odległość euklidesowa, odległość produktów od pomidorka
artykuly 

rysunek()


# należy podac typ dla pomidora
m<-min(artykuly$dist.pomidor[-7])
knn<-artykuly[which(m==artykuly$dist.pomidor),]
artykuly[7,4]<-knn$typ
artykuly
# Pomidor był najbliżej banana -> który jest owocem zatem pomidor został owocem
# A co wspólnego ma pomidor z bananem? No nic ale w ten sposób został zaklasyfikowany jako owoc 
# To jest właśnie idea kNN'u

rysunek()




# Algorytm kNN w R

# Dane dotyczące raka piersi obejmują 569 obserwacji, zawierających dane z biopsji raka. Każda obserwacja
  # zawiera 32 zmienne. Jedną z cech jest numer identyfikacyjny, kolejna to diagnoza raka, 
  # natomiast 30pozostałych, to liczbowe wyniki laboratoryjne. 
  # Diagnoza jest kodowana jako
    # "M" - malignant - oznacza złośliwy lub
    # "B" - benign - oznacza łagodny. 
  # Pozostałe 30 pomiarów numerycznych zawiera średnią(mean),
  # błąd standardowy(se) i worst - średnia z 3 "najgorszych" pomiarów. Mamy:

# 1.Promień
# 2.Tekstura
# 3.Obwód
# 4.Powierzchnia
# 5.Gładkość
# 6.Zwartość
# 7.Wklęsłość
# 8.Punkty wklęsłe
# 9.Symetria
# 10.Wymiar



# Przygotowujemy zbiór

#wbcd <- read.csv("wisc_bc_data.csv", stringsAsFactors = T)
wbcd <- read.csv("http://imul.math.uni.lodz.pl/~bartkiew/med/dane/wisc_bc_data.csv", stringsAsFactors = T)
str(wbcd)
summary(wbcd)


install.packages("visdat")
library(visdat)
#wizualizacja zbioru
vis_dat(wbcd)


wbcd <- wbcd[-1]

levels(wbcd$diagnosis)
levels(wbcd$diagnosis)<- c("łagodny", "złośliwy")


normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

normalize(c(1, 2, 3, 4, 5, 6))


wbcd_n <- as.data.frame(lapply(wbcd[-1], normalize))
wbcd_n = cbind(wbcd[1],wbcd_n)

# Wydzielamy zbiór treningowy i testowy

set.seed(14)
Train_Test <- sample(c("train","test"),nrow(wbcd),replace =TRUE, prob = c(0.7,0.3))
Train_Test


wbcd_train=subset(wbcd_n,Train_Test=="train")
wbcd_test=wbcd_n[Train_Test=="test",]


round(prop.table(table(wbcd_n$diagnosis)) * 100, digits = 1)
round(prop.table(table(wbcd_train$diagnosis)) * 100, digits = 1)
round(prop.table(table(wbcd_test$diagnosis)) * 100, digits = 1)


# Funkcja knn() z pakietu class odpowiada za działanie algorytmu kNN.

# p<-knn(train,test,class,k)     ------------> To chyba zostało pominięte na zajęciach?

# Gdzie:
  # train - data.frame z danymi treningowymi
  # test - data.frame z danymi testowymi
  # class - wektor(factor) z klasą decyzyjną
  # k - liczba sąsiadów

install.packages("class")
library(class)
wbcd_test_pred <- knn(train = wbcd_train[-1], test = wbcd_test[-1],
                      cl = wbcd_train$diagnosis, k = 21)

wbcd_test_pred 

# Rezultatem działania funkcji knn jest wektor, w którym zostały zwrócone wyniki klasyfikacji.



# Ewaluacja modelu

table(wbcd_test$diagnosis,wbcd_test_pred)

acc<-sum(wbcd_test$diagnosis==wbcd_test_pred)/nrow(wbcd_test)
acc          # acc - accuracy

# Wybór k

k <- c(2:15,seq(21,50,4))
n<-nrow(wbcd_test)
knn_acc <- NULL
for(i in 1:length(k)){
  knn_test <- knn(train = wbcd_train[-1], test = wbcd_test[-1],
                  cl = wbcd_train$diagnosis, k=k[i])
  knn_acc <- c(knn_acc,sum(wbcd_test$diagnosis==knn_test)/n)
}

knn_acc    
df=data.frame(k,knn_acc)
m=max(knn_acc)

library(dplyr)
filter(df,df$knn_acc==m)
plot(k,df$knn_acc, type = "b")


# Model optymalny

wbcd_test_pred_opty <- knn(train = wbcd_train[-1], test = wbcd_test[-1],
                           cl = wbcd_train$diagnosis, k = 6)


table(wbcd_test$diagnosis,wbcd_test_pred_opty)


acc<-sum(wbcd_test$diagnosis==wbcd_test_pred_opty)/nrow(wbcd_test)
acc


# Normalizacja rescaler
library(reshape)
wbcd_nn<- rescaler(wbcd[-1], "range")
summary(wbcd_nn )



# II sposób skalowania - standaryzacja
wbcd_z <- scale(wbcd[-1])
summary(wbcd_z)














