# PRZYKŁAD czyszczenia danych 

# import danych ---------------------------------------------------

install.packages("rio")
library(rio)

cd=import("http://imul.math.uni.lodz.pl/~bartkiew/med/dane/custdata2.tsv")
summary(cd)

str(cd)

cd %>%
  glimpse()

# analiza wstepna ---------------------------------------------------------

# czy dane są zduplikowane

is.duplic <- duplicated(cd)
TRUE %in% is.duplic

# poprawiamy typy danych
cd%>%
  glimpse()

cd.f <- cd %>% 
  mutate(sex = as_factor(sex),
         marital.stat = as_factor(marital.stat),
         housing.type = as_factor(housing.type),
         state.of.res = as_factor(state.of.res))

summary(cd.f)

cd.f %>%
  glimpse()


# missing values ----------------------------------------------------------

# badamy, w których zmiennych brakuje danych

table(complete.cases(cd.f))

install.packages("mice")
library(mice)

md.pattern(cd.f)

# korelacja braków

cd.missing<-cd.f %>%
  select(housing.type, recent.move, num.vehicles, is.employed )

install.packages("corrplot")
library(corrplot)

mv<- attr(na.omit(t(cd.missing)), "na.action")

k <- cor(is.na(cd.missing[mv]), use="pairwise", method="pearson")

corrplot(k)

title(main="Macierz korelacji brakujących danych w cd")

cor(k)


#uzupełniamy braki danych

install.packages("missForest")
library(missForest)

temp <- missForest(cd.f[-1])   # NIE DZIAŁA ! trzeba zmienić typ danych !
cd.f.u<-temp$ximp
summary(cd.f.u)

# wracamy do poprawy zbioru zmiennych
cd.f <- cd %>% 
  mutate(sex= as_factor(sex),
         marital.stat = as_factor(marital.stat),
         housing.type = as_factor(housing.type),
         state.of.res = as_factor(state.of.res),
         is.employed = as_factor(as.integer(is.employed)),
         health.ins = as_factor(as.integer(health.ins)),
         recent.move = as_factor(as.integer(recent.move))
  )

summary(cd.f)

# Jeszcze raz uzupełniamy braki danych w tym zbiorze
temp <- missForest(cd.f[-1])
cd.f.u<-temp$ximp
summary(cd.f.u)



# problem ze zmienną num.vehicles
plot(cd.f.u$num.vehicles)
plot(cd.f.u$is.employed)
plot(cd.f.u$recent.move)

# ponownie poprawiamy zbiór
cd.f2 <- cd %>% 
  mutate(sex= as_factor(sex),
         marital.stat = as_factor(marital.stat),
         housing.type = as_factor(housing.type),
         state.of.res = as_factor(state.of.res),
         num.vehicles = as_factor(num.vehicles),
         is.employed = as_factor(as.integer(is.employed)),
         health.ins = as_factor(as.integer(health.ins)),
         recent.move = as_factor(as.integer(recent.move))
  )

summary(cd.f2)

# Uzupełnianie -> usuwanie braków danych lasem losowym
temp <- missForest(cd.f2[-1])
cd.f.u2<-temp$ximp
summary(cd.f.u2)


plot(cd.f.u2$num.vehicles, main = "missf")


## drugi sposób uzupełnienia braków -------------------------------------------

temp.m <- mice(cd.f2 , m=1, maxit = 50, method = 'pmm', seed = 500)
cd.f.u.mice<-complete(temp.m,1)
summary(cd.f.u.mice)

# punkty oddalone ---------------------------------------------------------
boxplot(cd$income)
boxplot(cd$num.vehicles)
boxplot(cd$age)

install.packages("rstatix")
library(rstatix)

cd %>%
  identify_outliers(income)

# rezultat umieszczamy w oddzielnej ramce
res=cd %>%
  identify_outliers(income)

summary(res)

res2=cd.f.u2%>%
  identify_outliers(income)

summary(res2)

res2=cd.f.u2%>%
  identify_outliers(income)%>%
  filter(is.extreme==TRUE)

summary(res2)

cd %>%
  identify_outliers(num.vehicles)

