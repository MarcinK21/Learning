# Dostrajanie lasu losowego

# Pakiet caret

library(caret)
ctrl <- trainControl(method = "cv",number = 10)
grid_rf <- expand.grid(.mtry = c( 4,5,6))
m_rf <- train(credit_risk~.,data=gc.Train, method = "rf",
              metric = "Kappa", trControl = ctrl,
              tuneGrid = grid_rf)
m_rf

# ctrl <- trainControl(method = "repeatedcv",number = 10, repeats = 10)



# Funkcja z pakietu randomForest

bestmtry <- tuneRF(x=gc.Train[-21], y=gc.Train$credit_risk, stepFactor=1.5, improve=1e-5, ntree=500)
bestmtry