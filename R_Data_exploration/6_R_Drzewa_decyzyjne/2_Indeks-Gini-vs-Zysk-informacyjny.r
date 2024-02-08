#Indeks Gini vs Zysk informacyjny

#Przykład 1

train <- data.frame(id= c(1,2,3,4,5,6,7),
                    wiek = c(22, 33,22,33,21,21,30),
                    aktyw = factor(c("aktywny", "super", "super", "brak", "super","brak","super"),
                                   levels=c("brak ruchu", "brak", "aktywny", "super")),
                    przyjety = c(TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE))
train

install.packages("rpart")
library(rpart) 
mytree <- rpart(przyjety ~ wiek+aktyw, data = train, method = "class",
                parms = list(split = 'information'), minsplit = 2,minbucket = 1)
mytree


install.packages("rattle")
library(rattle)

par(mfrow=c(2,1))
fancyRpartPlot(mytree,main = "inf")

mytree2 <- rpart(przyjety ~ wiek+aktyw, data = train, method = "class",
                 parms = list(split = 'gini'),minsplit = 2, minbucket = 1)
mytree2
fancyRpartPlot(mytree2,main = "gini")


#Przykład 2

#NewsPop<-read.csv("news.csv",header=TRUE)
NewsPop<- read.csv("http://imul.math.uni.lodz.pl/~bartkiew/med/dane/news.csv")
library(dplyr)
news.pop<- select(NewsPop,channel,n_tokens_title, n_unique_tokens, n_non_stop_unique_tokens,
                  num_hrefs, num_self_hrefs, num_imgs, average_token_length, num_keywords,
                  self_reference_avg_sharess)
par(mfrow=c(1,1))
gini_model<-rpart(channel~.,data = news.pop, 
                  parms = list(split = "gini"),
                  control = list(minsplit=100))

fancyRpartPlot(gini_model,main = "gini")

info_model<-rpart(channel~.,data = news.pop,
                  parms = list(split = "information"), # Zysk informacyjny - czyli entropia
                  control = list(minsplit=100))

fancyRpartPlot(info_model,main="info")



#Przykład sklep komputerowy

k<-read.csv("http://imul.math.uni.lodz.pl/~bartkiew/med/dane/komputerowy.csv")

dk1 <- rpart(kupi_komputer~., data = k[-1], method = "class",parms = list(split = 'information'),minsplit = 2, minbucket = 1)
dk1
fancyRpartPlot(dk1)
dk1g <- rpart(kupi_komputer~., data = k[-1], method = "class",parms = list(split = 'gini'),minsplit = 2, minbucket = 1)
dk1g
fancyRpartPlot(dk1g)

#inne drzewo

dk2 <- rpart(kupi_komputer~., data = k[-1], method = "class",parms = list(split = 'information'),minsplit = 3, minbucket = 1)
dk2
fancyRpartPlot(dk2,main="info")
dk2g <- rpart(kupi_komputer~., data = k[-1], method = "class",parms = list(split = 'gini'),minsplit = 3, minbucket = 1)
dk2g
fancyRpartPlot(dk2g,main = "gini")