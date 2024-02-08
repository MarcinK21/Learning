# Grupowanie hierarchiczne zbioru College ----------------------------------------------------------------

install.packages("ISLR")
library(ISLR)
library(cluster) 
library(dplyr)
library(factoextra)

szkola<-College

dane=szkola%>%
  mutate(name= row.names(szkola),
         accept_rate = szkola$Accept/szkola$Apps,
         isElite = cut(szkola$Top10perc,
                       breaks = c(0, 50, 100),
                       labels = c("Not Elite", "Elite")))%>%
  select(name, accept_rate, Outstate, Enroll, Grad.Rate, Private, isElite)

rownames(dane)<-1:nrow(szkola)

?daisy

gower_dist <- daisy(dane[, -1],metric = "gower")
summary(gower_dist)



#Znajdźmy najbardziej podobne i najbardziej niepodobne obserwacje 
gower_mat <- as.matrix(gower_dist)

# Najbardziej podobne
dane[ which(gower_mat == min(gower_mat[gower_mat != min(gower_mat)]), arr.ind = TRUE)[1, ], ]

# Najmniej podobne 
dane[which(gower_mat == max(gower_mat[gower_mat != max(gower_mat)]), arr.ind = TRUE)[1, ], ]




drzewo.szkola <- hclust(gower_dist)

dist.coph <- cophenetic(drzewo.szkola)
cor(gower_dist, dist.coph )

fviz_dend(drzewo.szkola, cex = 0.5 , main = "Drzewo zbioru szkola ")

grupy.szkola <- cutree(drzewo.szkola, 3)



# Opis grup ---------------------------------------------------------------------------

dane.pogrupowane=cbind(dane, grupy.szkola)

dane.pogrupowane %>% 
  group_by(grupy.szkola) %>%
  summarise(
    liczba = n(),
    średni.prog.przyjęcia=mean(accept_rate),
    średnia.liczba.zapisów=mean(Enroll)
  )


dane.pogrupowane.f = dane.pogrupowane 
levels(dane.pogrupowane.f$isElite)=c(0,1)

dane.pogrupowane.f$isElite=as.numeric(levels(dane.pogrupowane.f$isElite))[dane.pogrupowane.f$isElite]
levels(dane.pogrupowane.f$Private)=c(0,1)
dane.pogrupowane.f$Private=as.numeric(levels(dane.pogrupowane.f$Private))[dane.pogrupowane.f$Private]


dane.pogrupowane.f %>% 
  group_by(grupy.szkola) %>%
  summarise(
    liczba = n(),
    średni.prog.przyjęcia=mean(accept_rate),
    średnia.liczba.zapisów=mean(Enroll),
    szkoly.elitarne=sum(isElite),
    szkoly.prywatne=sum(Private)
  )


dane.pogrupowane.f %>% 
  group_by(grupy.szkola) %>%
  summarise(
    liczba = n(),
    średni.prog.przyjęcia=mean(accept_rate),
    max.prog.przyjecia=max(accept_rate),
    szkoly.elitarne=sum(isElite),
    szkoly.prywatne=sum(Private),
    szkoly.panstwowe=n()-szkoly.prywatne
  )

#summary(dane.pogrupowane.f)



grupy.szkola4 <- cutree(drzewo.szkola, 4)
dane.pogrupowane4 = cbind(dane, grupy.szkola4)


dane.pogrupowane.f4 = dane.pogrupowane4 
levels(dane.pogrupowane.f4$isElite)=c(0,1)
dane.pogrupowane.f4$isElite=as.numeric(levels(dane.pogrupowane.f4$isElite))[dane.pogrupowane.f4$isElite]
levels(dane.pogrupowane.f4$Private)=c(0,1)
dane.pogrupowane.f4$Private=as.numeric(levels(dane.pogrupowane.f4$Private))[dane.pogrupowane.f4$Private]


dane.pogrupowane.f4 %>% 
  group_by(grupy.szkola4) %>%
  summarise(
    liczba = n(),
    średni.prog.przyjęcia=mean(accept_rate),
    max.prog.przyjecia=max(accept_rate),
    szkoly.elitarne=sum(isElite),
    szkoly.prywatne=sum(Private),
    szkoly.panstwowe=n()-szkoly.prywatne
  )

# Walidacja klastrów ------------------------------------------------------------
library(factoextra)

grupy.eclust.hcl<- eclust(gower_mat, "hclust", k = 3, stand = TRUE, nstart = 25, graph = FALSE)
grupy.eclust.hcl$cluster
fviz_cluster(grupy.eclust.hcl, gower_mat, geom = "point", repel = TRUE, 
             ggtheme = theme_classic())
fviz_cluster(grupy.eclust.hcl, gower_mat, geom = c("point","text"), repel = TRUE, 
             ggtheme = theme_classic()) # Zielony cluster - widać że lepiej by było podzielić na 4 w funkcji hclust


fviz_silhouette(grupy.eclust.hcl, palette = "jco", ggtheme = theme_classic()) # Silhouette - mówi o konieczności podziału
# Widać że są obserwacje ujemne czyli trafiły nie do swojej grupy

# Obserwacje w złej grupie
silinfo <- grupy.eclust.hcl$silinfo
silinfo


sil <- grupy.eclust.hcl$silinfo$widths
ujemne <- which(sil$sil_width < 0)
sil[ujemne, , drop = FALSE]


rn<-rownames(sil[ujemne, , drop = FALSE] ) # Wylistowanie uniwersytetow(obserwacje), ktore trafiły nie do swojej grupy
dane[rn,]




# Robimy to jeszcze raz ale wpiszemy teraz 4 klastry, POPRAWIAMY   ----> k = 4

grupy.eclust.hcl<- eclust(gower_mat, "hclust", k = 4, stand = TRUE, nstart = 25, graph = FALSE)
grupy.eclust.hcl$cluster
fviz_cluster(grupy.eclust.hcl, gower_mat, geom = "point", repel = TRUE, 
             ggtheme = theme_classic())

fviz_cluster(grupy.eclust.hcl, gower_mat, geom = c("point","text"), repel = TRUE, 
             ggtheme = theme_classic()) 

fviz_silhouette(grupy.eclust.hcl, palette = "jco", ggtheme = theme_classic()) # Widać, że wciąż jakaś ze szkół nie trafila do odpowiedniej grupy
# Więc sprawdzamy, ktora:
silinfo <- grupy.eclust.hcl$silinfo
silinfo


sil <- grupy.eclust.hcl$silinfo$widths
ujemne <- which(sil$sil_width < 0)
sil[ujemne, , drop = FALSE]


rn<-rownames(sil[ujemne, , drop = FALSE] ) # Wylistowanie uniwersytetow(obserwacje), ktore trafiły nie do swojej grupy
dane[rn,]


# Zapis do pdf  ------------------------------------------------------------

pdf("dendrogram.pdf", width=30, height=15) # otwieramy pdf
p <- fviz_dend(drzewo.szkola, k = 4, cex = 1, k_colors = "jco" ) # rysujemy w pliku
print(p)
dev.off()




