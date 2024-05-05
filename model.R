library(randomForest)
library(caret)
#https://www.kaggle.com/datasets/prishasawhney/mushroom-dataset/data
mush <- read.csv('mushroom_cleaned.csv')


mush$cap.shape <- as.factor(mush$cap.shape)
mush$gill.attachment <- as.factor(mush$gill.attachment)
mush$gill.color <- as.factor(mush$gill.color)
mush$stem.color <- as.factor(mush$stem.color)


#describing the data
str(mush)

table(mush$cap.color)

#Train and test split
TrainingIndex <- createDataPartition(mush$class,
                                     p = .8,
                                     list = FALSE,
                                     times = 1)
train <- mush[ TrainingIndex,]
test  <- mush[-TrainingIndex,]


write.csv(train, "training.csv")
write.csv(test, "testing.csv")

# Convertir la variable 'class' a un factor
train$class <- as.factor(train$class)
test$class <- as.factor(test$class)

# Crear el modelo
model <- randomForest(class ~ ., data = train, ntree = 100, mtry = 3, importance = TRUE)

# Guardar el modelo
saveRDS(model, "model.rds")

# Prueba
#pred <- predict(model, test)
#confusionMatrix(pred, test$class)
