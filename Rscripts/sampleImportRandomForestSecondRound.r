#ATTRIBUTES IMPORT
wria <- 13
drive <- "D"
class <- 1

#Get original sample data
library(XML)
lowc <- xmlToDataFrame(paste(drive,":\\WRIA",wria,"\\MODELS\\LOW_SAMPLE\\output\\aadata.xml",sep=""))
highc <- xmlToDataFrame(paste(drive,":\\WRIA",wria,"\\MODELS\\HIGH_SAMPLE\\output\\aadata.xml",sep=""))



#Add round 1 checked samples
checkedPred <-xmlToDataFrame(paste(drive,":\\WRIA",wria,"\\MODELS\\PREDICTED_CHANGE\\output\\aadata.xml",sep=""))
checkedNonPred<- xmlToDataFrame(paste(drive,":\\WRIA",wria,"\\MODELS\\PREDICTED_NONCHANGE\\output\\aadata.xml",sep=""))
head(checkedPred)
head(checkedNonPred)

#extract singles from dissolved data (may use others later)
checkedDissolved <- read.dbf(paste(drive,":\\WRIA",wria,"\\MODELS\\PREDICTED_CHANGE\\wria",wria,"dissolveChanged.dbf", sep=""))
singleDissolved <- checkedDissolved[checkedDissolved$COUNT_Poly == 1,]

getSingles <- match(singleDissolved$FID_wria13, as.numeric(as.vector(checkedPred$PolyID)))
singleCheckedPred <- checkedPred[getSingles,]
class(singleDissolved$FID_wria13)
class(as.numeric(as.vector(singleCheckedPred$PolyID)))

head(singleDissolved$FID_wria13)
head(as.numeric(as.vector(singleCheckedPred$PolyID)))

min(singleDissolved$FID_wria13)
min(as.numeric(as.vector(singleCheckedPred$PolyID)))
max(singleDissolved$FID_wria13)
max(as.numeric(as.vector(singleCheckedPred$PolyID)))

getSingles[1:10]
cor(as.numeric(as.vector(singleCheckedPred$PolyID)), singleDissolved$FID_wria13)
singleCheckedPred$PolyID <- singleDissolved$FIRST_Poly



#Combine into full new dataset
class(lowc$PolyID)
lowc$PolyID <- as.numeric(as.vector(lowc$PolyID))
highc$PolyID <- as.numeric(as.vector(highc$PolyID))
checkedNonPred$PolyID <- as.numeric(as.vector(checkedNonPred$PolyID))

combinedRawSamples <- rbind(cbind(lowc, mod=1), cbind(highc, mod=2), cbind(checkedNonPred, mod=3), cbind(singleCheckedPred, mod=4))
ChangeClassAdj <- as.numeric(as.vector(combinedRawSamples$ChangeClass))
ChangeClassAdj[ChangeClassAdj <4] <- 1
ChangeClassAdj[ChangeClassAdj > 3] <- 5
combinedRawSamples <- data.frame(combinedRawSamples, ChangeClassAdj)
table(combinedRawSamples$ChangeClassAdj)


#Find and retain only single checked data (ie eliminate duplicates from original verification) 
checkUnique <- unique(combinedRawSamples$PolyID)
length(checkUnique)
tCheck <- as.data.frame(table(combinedRawSamples$PolyID))
max(as.numeric(as.vector(tCheck$Var1)))
tCheckPos <- tCheck[tCheck$Freq == 1,]
dim(tCheckPos)
#Convert PolyIDs in tCheckPos Var1 column from levels to values and match/extract from combinedRawSamples
getUniqueSamples <- match(as.numeric(as.vector(tCheckPos$Var1)), combinedRawSamples$PolyID)

samplesTrainingDataFinal2 <- combinedRawSamples[getUniqueSamples,]
dim(samplesTrainingDataFinal2)
summary(samplesTrainingDataFinal2$ChangeClassAdj)
samplesTrainingDataFinal2 <- na.omit(samplesTrainingDataFinal2)
dim(samplesTrainingDataFinal2)
summary(samplesTrainingDataFinal2$ChangeClassAdj)
table(samplesTrainingDataFinal2$mod)

##UNCOMMENT BELOW ON FIRST RUN
#wriaModelData <- read.csv(paste(drive,":\\WRIA",wria,"\\segments\\RDATA\\wria", wria,"allPolyData.csv", sep=""))


getAtts <- match(samplesTrainingDataFinal2$PolyID, wriaModelData$PolyID)

samplesData3 <- wriaModelData[getAtts,]


checkData <- data.frame(ChangeClass = samplesTrainingDataFinal2$ChangeClassAdj, samplesData3)
write.dbf(checkData, paste(drive,":\\WRIA",wria,"\\segments\\RDATA\\wria", wria,"checkData.dbf", sep=""))
library(randomForest)

rfChange <- randomForest(x=samplesData3, y=as.factor(samplesTrainingDataFinal2$ChangeClassAdj), ntree=2500, na.action=na.omit)
print(rfChange)

#Original Low Sample
lowTest <- samplesTrainingDataFinal2[samplesTrainingDataFinal2$mod ==4, ]
getAtts <- match(lowTest$PolyID, wriaModelData$PolyID)
samplesData3 <- wriaModelData[getAtts,]
dim(samplesData3)
table(lowTest$ChangeClassAdj)

response <- factor(lowTest$ChangeClassAdj)
levels(response)

rfChange <- randomForest(x=samplesData3, y=response, ntree=500, na.action=na.omit)
print(rfChange)
table(lowTest$ChangeClass)
attributes(rfChange)
?randomForest
testOut <- data.frame(lowTest, Pred = rfChange$predicted)
head(testOut)
write.dbf(testOut, paste(drive,":\\wria",wria,"\\testOut2.dbf",sep=""))

importance(rfChange)
varImpPlot(rfChange, sort=TRUE)
savePlot(paste(drive,":\\WRIA",wria,"\\segments\\RDATA\\wria", wria,"RandForestPlot.pdf", sep=""), type=c("pdf"))

####24 gb memory means do it all at once
changeProbabilities<-predict(rfChange, wriaModelData, type="prob")
#changeProbabilities2<-predict(rfChange, wriaModelData[100001:200000,], type="prob")
#changeProbabilities3<-predict(rfChange, wriaModelData[200001:300000,], type="prob")
#changeProbabilities4<-predict(rfChange, wriaModelData[300001:400000,], type="prob")
#changeProbabilities5<-predict(rfChange, wriaModelData[400001:dim(wriaModelData)[1],], type="prob")

#changeProbabilities <- rbind(changeProbabilities1, changeProbabilities2, changeProbabilities3, changeProbabilities4,changeProbabilities5)

changePredictions<-predict(rfChange, wriaModelData)
#changePredictions2<-predict(rfChange, wriaModelData[100001:200000,])
#changePredictions3<-predict(rfChange, wriaModelData[200001:300000,])
#changePredictions4<-predict(rfChange, wriaModelData[300001:400000,])
#changePredictions5<-predict(rfChange, wriaModelData[400001:dim(wriaModelData)[1],])
 
#changePredictions <- c(changePredictions1, changePredictions2, changePredictions3, changePredictions4,changePredictions5)


changeOut <- data.frame(PolyID = wriaModelData$PolyID, Pred = changePredictions,  changeProbabilities)

#CSV join terribly in ARC, use DBF for joins
library(foreign)
write.dbf(changeOut, paste(drive,":\\WRIA",wria,"\\segments\\RDATA\\wria", wria,"predictionData5", sep=""))
