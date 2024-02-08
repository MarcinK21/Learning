# Przykład do metryki Gowera ------------------------------------------------------------------------------------------------
library(cluster)

df2=data.frame(wiek=c(18,65,24,80), 
               plec=factor(c("M","K","K","M")),
               wzrost=factor(c("wysoki","wysoki","niski","sredni")),
               wspolczynnik=c(0.23,0.78,0.12,0.5))
df2


daisy(df2,metric = "gower")

#Odległość pomiędzy 1 a 2 obserwacją
w1=(65-18)/(80-18) #abs wartości dzielimy przez zakres
w2=1               #różne = 1
w3=0               # takie same =0
w4=(0.78-0.23)/(0.78-0.12)

(w1+w2+w3+w4)/4 #dzielimy przez liczbę zmiennych







