memory.limit(size=3500)

exConn1 <- odbcConnectExcel2007( "F:\\WRIA7\\model\\highChange.xlsx")
exConn2 <- odbcConnectExcel2007( "F:\\WRIA7\\model\\lowChange.xlsx")
#
highc <- sqlFetch(exConn1, "Sheet1")
lowc <- sqlFetch(exConn2, "Sheet1")
#
samples <- rbind(lowc, highc)

samplesData <- read.csv("F:\\WRIA7\\attributes\\shadow2009\\samplePolyData.csv")


#getAtts <- match(samples$PolyID, wria7ModelData$PolyID)
#
#samplesData <- wria7ModelData[getAtts,]
#
#rm(wria7ModelData)
#
library(randomForest)
rfChange <- randomForest(samplesData[,-2], as.factor(samples$ChangeClass), ntree=2500, na.action=na.omit)
#14 minutes run for 2000 trees with 3659 rows and 68 predictors
print(rfChange)
importance(rfChange)
varImpPlot(rfChange, sort=TRUE)

wria7ModelData <- read.csv("F:\\WRIA7\\attributes\\shadow2009\\allPolyData.csv")

changeProbabilities1<-predict(rfChange, wria7ModelData[1:100000,], type="prob")
changeProbabilities2<-predict(rfChange, wria7ModelData[100001:200000,], type="prob")
changeProbabilities3<-predict(rfChange, wria7ModelData[200001:300000,], type="prob")
changeProbabilities4<-predict(rfChange, wria7ModelData[300001:400000,], type="prob")
changeProbabilities5<-predict(rfChange, wria7ModelData[400001:dim(wria7ModelData)[1],], type="prob")

changeProbabilities <- rbind(changeProbabilities1, changeProbabilities2, changeProbabilities3, changeProbabilities4,changeProbabilities5)

changePredictions1<-predict(rfChange, wria7ModelData[1:100000,])
changePredictions2<-predict(rfChange, wria7ModelData[100001:200000,])
changePredictions3<-predict(rfChange, wria7ModelData[200001:300000,])
changePredictions4<-predict(rfChange, wria7ModelData[300001:400000,])
changePredictions5<-predict(rfChange, wria7ModelData[400001:dim(wria7ModelData)[1],])
 
changePredictions <- c(changePredictions1, changePredictions2, changePredictions3, changePredictions4,changePredictions5)


changeOut <- data.frame(PolyID = wria7ModelData$PolyID, Pred = changePredictions,  changeProbabilities)

write.csv(changeOut, "F:\\WRIA7\\attributes\\shadow2009\\predictionData.csv", row.names=T)
