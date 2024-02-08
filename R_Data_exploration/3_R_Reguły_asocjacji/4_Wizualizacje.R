# Wizaulizacje ----------------------------------------------------------

install.packages("arulesViz")
library(arulesViz)

reg = apriori(dane.tr1.read.v2,
              parameter = list(
                support = 0.001,
                confidence = 0.9 ,
                minlen = 3,
                maxlen = 4
              ))
summary(reg)
inspect(reg)

# Tutaj dopiero jest potrzebny arulesViz

plot(reg,method="graph", interactive=TRUE)
plot(reg,method="graph")
plot(reg,method = "grouped")



