# ICU ------------------------------------------------------------------------------------------------

install.packages("vcdExtra")
library(vcdExtra)

data(ICU)
summary(ICU)

#opis atrybutów
  #service - rodzaj udzielonej pomocy
  #cancer, renal, infect, fracture - rak, nerki, infekcje, złamania
  #cpr - resuscytacja krążeniowo-oddechowa
  #systolic, heartrate - ciśnienie
  #previcu, admit - czy już przebywał wcześniej i z jakiej przyczyny
  #po2, ph, pco, bic, creatin - badania krwi
  #coma, uncons - śpiączka, nieprzytomny
  
#Aby plik przekształcić do postaci macierzy transakcyjnej, wszystkie atrybuty muszą być typu factor.
#Poprawiamy dane, zamieniając zmienne numeryczne na factor. Ponadto usuwamy atrybut race, ponieważ się powtarza z white.

str(ICU)
ICU2 <- ICU[-4]
ICU2$age <- cut(ICU2$age, breaks = 4)
ICU2$systolic <- cut(ICU2$systolic, breaks = 4)
ICU2$hrtrate <- cut(ICU2$hrtrate, breaks = 4)

#inny podział można wykonać korzystając z funkcji discretize().

install.packages("arules")

library(arules)

agerec <- discretize(ICU$age, method="frequency",categories=4)

#generujemy macierz

ICU_tr <- as(ICU2, "transactions")
str(ICU_tr)
ICU_tr@data
ICU_tr@itemInfo

#wykonujemy analizę

itemFrequencyPlot(ICU_tr)
itemFrequencyPlot(ICU_tr,horiz=T, support=0.5)
reguly_zdrowie <- apriori (ICU_tr,parameter = list(support = 0.85, confidence = 0.95))
inspect(reguly_zdrowie)

#Reguły z ustaloną stroną reguły


rulesDeath <- apriori(ICU_tr,
                      parameter = list(confidence = 0.3,support=0.1),
                      appearance = list(rhs = c("died=Yes"), default="lhs"))
inspect(rulesDeath)
rulesDeath2 <- apriori(ICU_tr,
                       parameter = list(confidence = 0.3,support=0.1),
                       appearance = list(lhs = c("died=Yes"), default="rhs"))
inspect(rulesDeath2)
rulesDeath.df <- as(rulesDeath,"data.frame")
rulesDeath.df.sorted <-rulesDeath.df[order(rulesDeath.df$lift,decreasing = T),]
head(rulesDeath.df.sorted)

#Inny sposób wybierania reguł

rulesComa <-subset(reguly_zdrowie, subset = rhs %in% "coma=None")
inspect(rulesComa)
plot(rulesComa ,method="graph", interactive=TRUE)
rulesComa2 <-subset(reguly_zdrowie, subset = lhs %in% "coma=None")
inspect(rulesComa2)
rulesCancer <-subset(reguly_zdrowie, subset = lhs %in% "cancer=No")
summary(rulesCancer)
inspect(rulesCancer)
