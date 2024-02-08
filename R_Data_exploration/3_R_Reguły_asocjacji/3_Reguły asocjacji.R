# Reguły asocjacji

# Do generowania reguł asocjacji sluży funkcja:
    # apriori()

reguly.zakupy <- apriori(dane.tr1.read.v2,
                         parameter = list(supp = 0.001, conf = 0.8, maxlen=3))

pomijane.produkty = c("Banana", "Bag of Organic Bananas")

reguly.zakupy.2 <- apriori(dane.tr1.read.v2,
                           parameter = list(supp = 0.001, conf = 0.8),
                           appearance = list(none = pomijane.produkty))


summary(reguly.zakupy)


#Następnie możemy wyświetlić reguły

reguly.zakupy.sort <- sort (reguly.zakupy, by="support", decreasing=TRUE)
inspect(reguly.zakupy.sort)
inspect(reguly.zakupy.sort[1:5])


#Utworzone reguły można zapisać do pliku

write(reguly.zakupy.sort, file = "reguly_1.csv", quote=TRUE, sep = ",", col.names = NA)





