
wria2 <- "02"
wria <- paste0(wria2,"_2009")
wria
drive <- "J"
eCogWS <- paste0(drive,":\\wria",wria,"\\eCognition\\wria",wria)
eCogWS

expAttributes <- paste(drive,":\\wria",wria,"\\Segments\\EXPORT_ATTRIBUTES", sep="")

library(foreign)
super <- read.dbf(paste0(drive,":\\wria",wria,"\\Segments\\AnalysisObjectStatistics.dbf"))
subSum <- read.dbf(paste0(eCogWS, "\\results\\wria",wria,"subSummaries.dbf"))
#vegProp <- read.dbf(paste(expAttributes, "\\veg09Proportions.dbf", sep=""))
#topoSum <- read.dbf(paste(expAttributes, "\\demOut.dbf", sep="") )


# dim(super)
# dim(subSum)
# dim(vegProp)
# dim(topoSum)

gSub <- match(super$stitchID,subSum$PolyID)
# summary(gSub)
# gVeg <- match(super$stitchID,vegProp$PolyID)
# gTopo <- match(super$stitchID,topoSum$POLYID)

# summary(gSub)
# summary(gVeg)
# summary(gTopo)

# vegCollapse <- data.frame(vegProp[,c(1:5,11,12)],tree = apply(vegProp[,8:10],1,sum),built=vegProp[,7]+vegProp[,6])


datamat <- data.frame(super,subSum[gSub,])#,vegCollapse[gVeg,],topoSum[gTopo,])

# cor(datamat$stitchID,datamat$PolyID)
# cor(datamat$stitchID,datamat$POLYID)
# cor(datamat$stitchID,datamat$PolyID.1)



summary(datamat)

qCheck <- cbind(datamat$stitchID,datamat$PolyID)

qCheck2 <- na.omit(qCheck)
cor(qCheck2)



library(XML)
lowc <- xmlToDataFrame(paste(drive,":\\WRIA",wria,"\\MODELS\\Round1Low\\output\\aadata.xml",sep=""))
#highc <- xmlToDataFrame(paste(drive,":\\WRIA",wria,"\\MODELS\\Round1High\\output\\aadata.xml",sep=""))
 
#samplesTraining <- lowc
samplesTraining <- rbind(lowc)


dim(lowc)
dim(highc)
temp1 <- data.frame(PolyID=as.numeric(as.vector(samplesTraining$PolyID)),ChangeClass=as.numeric(as.vector(samplesTraining$ChangeClass)))
summary(temp1)
table(temp1$ChangeClass)

searched <- read.csv("J:\\wria02_2009\\Models\\Round1Search\\wria2_Changes_ManualSelection.txt")
searchDF <- data.frame(searched, ChangeClass = 1)

samplesTraining <- rbind(temp1,searchDF)
table(samplesTraining$ChangeClass)

cbind(names(lowc),seq(along=(names(lowc))))
library(randomForest)


getAtts <- match(as.numeric(as.vector(samplesTraining$PolyID)), datamat$stitchID)

samplesData2 <- datamat[getAtts,]
#rfChange <- randomForest(x=samplesData2[,c(-1,-match("PolyID",names(samplesData2)))], y=as.factor(samplesTraining$ChangeClass), ntree=500, na.action=na.omit)

binaryClass <- as.numeric(as.vector(samplesTraining$ChangeClass))
binaryClass[binaryClass < 4] <- 0
binaryClass[binaryClass > 3] <- 1

cbind(names(datamat),seq(along=(names(datamat))))
rfChange <- randomForest(x=samplesData2[,c(8:48,50:59)], y=as.factor(binaryClass), ntree=2500, na.action=na.omit, cutoff=c(0.25,0.75))

print(rfChange)
#yDummy <- sample(seq(1,10), size = length(samplesTraining$ChangeClass), replace=TRUE)
#rfChange <- randomForest(x=samplesData2, y=as.factor(yDummy), ntree=500, na.action=na.omit)

#14 minutes run for 2000 trees with 3659 rows and 68 predictors

importance(rfChange)
varImpPlot(rfChange, sort=TRUE)
savePlot(paste(drive,":\\WRIA",wria,"\\segments\\wria", wria,"RandForestPlotSamples.pdf", sep=""), type=c("pdf"))

datamatNA <- datamat[!is.na(datamat$PolyID),]


changeProbabilities1<-predict(rfChange, datamatNA[1:dim(datamatNA)[1],], type="prob")
#changeProbabilities2<-predict(rfChange, datamat[100001:200000,], type="prob")
#changeProbabilities3<-predict(rfChange, datamat[200001:300000,], type="prob")
#changeProbabilities4<-predict(rfChange, datamat[300001:400000,], type="prob")
#changeProbabilities5<-predict(rfChange, datamat[400001:dim(datamat)[1],], type="prob")

#changeProbabilities <- rbind(changeProbabilities1, changeProbabilities2,changeProbabilities3,changeProbabilities4, changeProbabilities5)

changePredictions1<-predict(rfChange, datamatNA[1:dim(datamatNA)[1],])
#changePredictions2<-predict(rfChange, datamat[100001:200000,])
#changePredictions3<-predict(rfChange, datamat[200001:300000,])
#changePredictions4<-predict(rfChange, datamat[300001:400000,])
#changePredictions5<-predict(rfChange, datamat[400001:dim(datamat)[1],])
 
#changePredictions <- c(changePredictions1, changePredictions2,changePredictions3,changePredictions4,changePredictions5)


changeOut <- data.frame(PolyID = datamatNA$stitchID, Pred = changePredictions1,  changeProbabilities1)

table(changeOut$Pred)

#CSV join terribly in ARC, use DBF for joins
write.dbf(changeOut, paste(drive,":\\WRIA",wria,"\\segments\\wria", wria,"predictionsRound1", sep=""))


