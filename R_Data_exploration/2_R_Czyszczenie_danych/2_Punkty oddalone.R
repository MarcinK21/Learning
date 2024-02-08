# Punkty oddalone ---------------------------------------------------------------------------

  # Punkty oddalone (wartości odstające), to wartości oddalone o więcej niż 1.5-krotność rozstępu ćwiartkowego

# Wprowadzam przykładowe dane
dane<-c(5,7,5,6,0,4,8,7,8,6,5,4,5,12,4,5,7,7)
summary(dane)
boxplot(dane, col="green",pch=16)

#identyfikacja punktów

wynik<-boxplot(dane, col="red",pch=16)

po<-which(dane %in% wynik$out) 
po

(b1 <- boxplot.stats(dane))
boxplot.stats(dane)$out
plot(dane,pch=16,col=5,cex=1.5)   # pch - kształt, col - kolor, cex - font size (rozmiar znaczników)
hist(dane,pch=16,col=5,cex=1.5)
boxplot(dane,pch=16,col=5,cex=1.5)



# Boxplot ------------------------------------------------------------

# Import danych 
library(ggplot2)
house <- read.csv("http://imul.math.uni.lodz.pl/~bartkiew/med/dane/HousePrices.csv",stringsAsFactors = TRUE)
summary(house)

# bazowy boxplot
boxplot<-ggplot(house)+
  aes(x=Neighborhood, y=Price )+
  geom_boxplot()
boxplot


# zaznaczenie kolorem punktu oddalonego
boxplot+
  geom_boxplot(color="red", fill="orange",outlier.size=4, outlier.shape=18, outlier.color="blue")

boxplot+
  geom_boxplot(outlier.shape=NA)

boxplot+
  geom_boxplot(outlier.size=2, outlier.shape=18, outlier.color="red")+
  geom_jitter(position=position_jitter(0.2))


# cała zmienna Price
(b1 <- boxplot.stats(house$Price))
ggplot(house)+
  aes(y=Price )+
  geom_boxplot()


ggplot(house)+
  aes(y=Price )+
  geom_boxplot(outlier.shape=NA)


# wartość punktu oddalonego
boxplot.stats(house$Price)$out


# obserwacja z punktemm oddalonym
house[which(house$Price %in% boxplot.stats(house$Price)$out),]


# w podziale na dzielnice zbioru house
library(dplyr)

north<-house%>%
  filter(Neighborhood=="North")

boxplot<-ggplot(north)+
  aes(x=Neighborhood, y=Price )+
  geom_boxplot()

boxplot

house[which(house$Price %in% boxplot.stats(north$Price)$out),]



# Punkty oddalone - pakeit rststix  ------------------------------------------------------------

  # Pakiet rstatix - pakiet służący do podstawowych testów statystycznych 

install.packages("rstatix")
library(rstatix)


set.seed(123)
demo.data <- tibble(
  wiek = sample(20,20,rep=T),
  punkty = c(rnorm(19, mean = 5, sd = 2), 50),
  plec = rep(c("M", "K"), each = 10)
)

ggplot(demo.data)+
  aes(y=punkty )+
  geom_boxplot()

boxplot<-ggplot(demo.data)+
  aes(x=plec, y=punkty )+
  geom_boxplot()

boxplot


# identyfikacja punktów oddalonych w zmiennej punkty
demo.data %>%
  identify_outliers(punkty)   # identify_outliers -> funkcja z pakietu rstatix  -> 
      # Detect outliers using boxplot methods. Boxplots are a popular and an easy method for 
      # identifying outliers. There are two categories of outlier: (1) outliers and (2) extreme points.


# identyfikacja punktów oddalonych w podziale na płeć
demo.data %>%
  group_by(plec) %>%
  identify_outliers(punkty)


# Punkty oddalone - pakiet outlier ------------------------------------

install.packages("outliers")
library(outliers)

# Tworze przykładowe dane 
x<- c(1, 60, 2, 1, 4, 4, 1, 1, 6, -30, 70)

x[which(x %in% boxplot.stats(x)$out)]

plot(x,pch=16,col=5,cex=1.5)
hist(x,pch=16,col=5,cex=1.5)
boxplot(x,pch=16,col=5,cex=1.5)

y<-rm.outlier(x, fill = FALSE, median = FALSE, opposite = FALSE)

y

plot(y,pch=16,col=6,cex=1.5)