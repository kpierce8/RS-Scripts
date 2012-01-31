#ATTRIBUTES IMPORT
wria <- 13
drive <- "D"
class <- 1


library(XML)
lowc <- xmlToDataFrame(paste(drive,":\\WRIA",wria,"\\MODELS\\LOW_SAMPLE\\output\\aadata.xml",sep=""))
highc <- xmlToDataFrame(paste(drive,":\\WRIA",wria,"\\MODELS\\HIGH_SAMPLE\\output\\aadata.xml",sep=""))
samplesTraining <- rbind(lowc, highc)

#sampleLow <- read.dbf(paste(drive,":\\WRIA",wria,"\\MODELS\\LOW_SAMPLE\\wria",wria,"lowSample.dbf", sep=""))
#sampleHigh <- read.dbf(paste(drive,":\\WRIA",wria,"\\MODELS\\HIGH_SAMPLE\\wria",wria,"highSample.dbf", sep=""))

#samplesData <- rbind(sampleLow, sampleHigh)

wriaModelData <- read.csv(paste(drive,":\\WRIA",wria,"\\segments\\RDATA\\wria", wria,"allPolyData.csv", sep=""))


getAtts <- match(samplesTraining$PolyID, wriaModelData$PolyID)

samplesData2 <- wriaModelData[getAtts,]
#
#rm(wria7ModelData)
#
library(randomForest)

#rfChange <- randomForest(x=samplesData2[,c(-1,-match("PolyID",names(samplesData2)))], y=as.factor(samplesTraining$ChangeClass), ntree=500, na.action=na.omit)

rfChange <- randomForest(x=samplesData2, y=as.factor(samplesTraining$ChangeClass), ntree=2500, na.action=na.omit)
print(rfChange)
#yDummy <- sample(seq(1,10), size = length(samplesTraining$ChangeClass), replace=TRUE)
#rfChange <- randomForest(x=samplesData2, y=as.factor(yDummy), ntree=500, na.action=na.omit)

#14 minutes run for 2000 trees with 3659 rows and 68 predictors

importance(rfChange)
varImpPlot(rfChange, sort=TRUE)
savePlot(paste(drive,":\\WRIA",wria,"\\segments\\RDATA\\wria", wria,"RandForestPlot.pdf", sep=""), type=c("pdf"))
wria7ModelData <- read.csv("F:\\WRIA7\\attributes\\shadow2009\\allPolyData.csv")

changeProbabilities1<-predict(rfChange, wriaModelData[1:100000,], type="prob")
changeProbabilities2<-predict(rfChange, wriaModelData[100001:200000,], type="prob")
changeProbabilities3<-predict(rfChange, wriaModelData[200001:300000,], type="prob")
changeProbabilities4<-predict(rfChange, wriaModelData[300001:400000,], type="prob")
changeProbabilities5<-predict(rfChange, wriaModelData[400001:dim(wriaModelData)[1],], type="prob")

changeProbabilities <- rbind(changeProbabilities1, changeProbabilities2, changeProbabilities3, changeProbabilities4,changeProbabilities5)

changePredictions1<-predict(rfChange, wriaModelData[1:100000,])
changePredictions2<-predict(rfChange, wriaModelData[100001:200000,])
changePredictions3<-predict(rfChange, wriaModelData[200001:300000,])
changePredictions4<-predict(rfChange, wriaModelData[300001:400000,])
changePredictions5<-predict(rfChange, wriaModelData[400001:dim(wriaModelData)[1],])
 
changePredictions <- c(changePredictions1, changePredictions2, changePredictions3, changePredictions4,changePredictions5)


changeOut <- data.frame(PolyID = wriaModelData$PolyID, Pred = changePredictions,  changeProbabilities)

#CSV join terribly in ARC, use DBF for joins
write.dbf(changeOut, paste(drive,":\\WRIA",wria,"\\segments\\RDATA\\wria", wria,"predictionData2", sep=""), row.names=T)
