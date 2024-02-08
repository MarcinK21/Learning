# Wczytywanie danych ---------

# Dane zapisane w postaci pliku tekstowego importuje się za pomocą
  #   funkcji z rodziny read.

# Zasadnicze parametry:

    # nazwa pliku - jezeli jest w katalogu roboczym (sprawdzamy setwd())
      # wystarczy podać nazwę pliku wraz z rozszerzeniem. 
    
    # Jeśli dane znajdują się poza kat. roboczym, należy podać pełną 
      # ścieżkę do katalogu pliku lub adres url.
    
    # Separator kolumn - np.sep="," , lub  sep=";"  lub  sep="\t".

    # Nagłówek - gdy plik ma nagłówek, wówczas piszemy
      # header= TRUE, w przeciwnym razie header = FALSE



t1<-  read.table("titanic.csv", header = TRUE, sep = ",")

t2<- read.csv("titanic.csv", header = TRUE, sep = ",", quote = "\"",
              dec = ".", fill = TRUE, comment.char = "")

t3<-read.csv("titanic.csv")


# Wczytane zbiory można wykorzystywać do analizy:

sum(t1[, "Survived"])


# pliki można też pobierać z internetu

ds <- read.csv("http://rattle.togaware.com/weather.csv")

ds2 <- read.csv("https://raw.githubusercontent.com/aronlindberg/latent_growth_classes/master/LGC_data.csv")

write.csv(ds2,"a.csv")

t4<-read.csv("http://imul.math.uni.lodz.pl/~bartkiew/med/dane/titanic.csv")

sum(t4$Survived)



library(readr)
ds2.2= read_csv("https://raw.githubusercontent.com/aronlindberg/latent_growth_classes/master/LGC_data.csv")
#spec(ds2.2)
str(ds2)
str(ds2.2)




# Pakiet rio ------------
# https://cran.r-project.org/web/packages/rio/readme/README.html

install.packages("rio")
library(rio)


ds2.3=import("https://raw.githubusercontent.com/aronlindberg/latent_growth_classes/master/LGC_data.csv")
str(ds2.3)

ros <- import("rossmann.xlsx")
summary(ros)

m=import("movies2.csv")
summary(m)

l=import("dl.txt")
summary(l)




