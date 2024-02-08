# Reguły negatywne ------------------------------------------------------------------------------------------------

# W niektórych zastosowaniach, związek między brakiem przedmiotu a obecnością innego w koszyku zakupowym może być bardzo ważny.
# Tego typu reguły nazywamy regułami negatywnymi.

  # klient, który kupił herbatę nie kupuje kawy
  # klienci kupujący sok nie kupują wody butelkowanej


# Aby wygenerować reguły negatywne, należy użyć funkcji addComplement(). Ta funkcja dodaje dla podanych elementów ich 
    #   negacje(uzupełnienia). Następnie dodaje negacje do każdej transakcji, któranie zawiera oryginalnego przedmiotu



negacje <- c("Organic Whole Milk","Cucumber Kirby")

neg.transactions <- addComplement(dane.tr1.read.v2, labels = negacje)

reguly.negatywne <- apriori(neg.transactions , parameter = list(supp = 0.05, conf = 0.6, minlen=2))


summary(reguly.negatywne)
inspect(reguly.negatywne)


# przykład ICU

negacje.ICU <- c("hrtrate=(38.8,77.2]","systolic=(35.8,91]")

neg.transactions <- addComplement( ICU_tr, labels = negacje.ICU)

neg.transactions@itemInfo

reguly.negatywne.ICU <- apriori(neg.transactions , parameter = list(supp = 0.8, conf = 0.95, minlen=2))


summary(reguly.negatywne.ICU)
inspect(reguly.negatywne.ICU)

