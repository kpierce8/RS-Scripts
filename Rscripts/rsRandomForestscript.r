memory.limit(size=3500)
library(RODBC)
exConn1 <- odbcConnectExcel2007( "D:\\WRIA8\\models\\highChange.xlsx")
exConn2 <- odbcConnectExcel2007( "D:\\WRIA8\\models\\lowChange.xlsx")
#
highc <- sqlFetch(exConn1, "Sheet1")
lowc <- sqlFetch(exConn2, "Sheet1")
#
samples <- rbind(lowc, highc)

samplesData <- read.csv("D:\\WRIA8\\models\\samplePolyData.csv")
ni(samplesData)

getAtts <- match(samples$PolyID, samplesData$PolyID)
#
#samplesData <- samplesData[getAtts,]
#
#rm(wria7ModelData)
#

samples$Binary <- ifelse(samples$ChangeClass == 1,samples$ChangeClass,0)

library(randomForest)
#rfChange <- randomForest(samplesData[,7:40], as.factor(samples$ChangeClass), ntree=2500, na.action=na.omit)

rfChangeB <- randomForest(samplesData[,7:40], as.factor(samples$Binary), ntree=2500, na.action=na.omit)
#14 minutes run for 2000 trees with 3659 rows and 68 predictors
print(rfChange)
importance(rfChange)
varImpPlot(rfChange, sort=TRUE)

wria7ModelData <- read.csv("C:\\wria8\\eCognition\\allPolyData.csv")
wria7MD <- na.omit(wria7ModelData)


changeProbabilities1<-predict(rfChange, wria7MD[1:100000,], type="prob")
changeProbabilities2<-predict(rfChange, wria7MD[100001:200000,], type="prob")
changeProbabilities3<-predict(rfChange, wria7MD[200001:300000,], type="prob")
changeProbabilities4<-predict(rfChange, wria7MD[300001:400000,], type="prob")
changeProbabilities5<-predict(rfChange, wria7MD[400001:dim(wria7MD)[1],], type="prob")

changeProbabilities <- rbind(changeProbabilities1, changeProbabilities2, changeProbabilities3, changeProbabilities4,changeProbabilities5)

changePredictions1<-predict(rfChange, wria7MD[1:100000,])
changePredictions2<-predict(rfChange, wria7MD[100001:200000,])
changePredictions3<-predict(rfChange, wria7MD[200001:300000,])
changePredictions4<-predict(rfChange, wria7MD[300001:400000,])
changePredictions5<-predict(rfChange, wria7MD[400001:dim(wria7MD)[1],])
 
changePredictions <- c(changePredictions1, changePredictions2, changePredictions3, changePredictions4,changePredictions5)


changeOut <- data.frame(PolyID = wria7MD$PolyID, Pred = changePredictions,  changeProbabilities)

write.csv(changeOut, "C:\\wria8\\eCognition\\predictionData.csv", row.names=T)
