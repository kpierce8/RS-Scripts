library(foreign)
newNames<-c("max4","propNV","edgeCon4","edgeCon2", "Con4", "Con2", "AreaEx", "DistNV", "EdgeLength", "DistLeft","DistTop", "innerX", "innerY")
badNames <- c("Max..pixel.value.Layer.4", "Rel..border.to.Non.Veg", "Edge.Contrast.of.neighbor.pixels..Prototype..Layer.4..3."
  , "Edge.Contrast.of.neighbor.pixels..Prototype..Layer.2..3.", "Contrast.to.neighbor.pixels.Layer.4..3."
  , "Contrast.to.neighbor.pixels.Layer.2..3.", "Area..excluding.inner.polygons...Pxl.","Distance.to.Non.Veg..Pxl.", "Border.length..Pxl.",
  "X.distance.to.scene.left.border..Pxl.","Y.distance.to.scene.top.border..Pxl.", "inner_x", "inner_y")

#memory.limit(size=3500)
#ATTRIBUTES IMPORT
wria <- 13
drive <- "D"
class <- 1
allAtt <- read.csv(paste(drive,":\\WRIA",wria,"\\segments\\EXPORT_ATTRIBUTES\\gt500wria13stats.csv", sep=""), header=T, sep=";")

dim(allAtt)


#POLYGON IMPORT

class <- 1
allSegTemp <- read.dbf(paste(drive,":\\WRIA",wria,"\\segments\\EXPORT_SEGMENTS\\segmentDataW13.dbf", sep=""))

dim(allSegTemp)
allSeg <- allSegTemp
rm(allSegTemp)


class <- 1
#shad06 <- read.table(paste(drive,":\\WRIA",wria,"\\segments\\RDATA\\wria", wria,"class",class,"_shadow_2006.csv", sep=""), header=T)
shad06 <- read.dbf(paste(drive,":\\WRIA",wria,"\\segments\\EXPORT_SEGMENTS\\wria",wria,"segments457_shad06_",class,".dbf", sep=""))
for(class in 2:6){
temp<- read.dbf(paste(drive,":\\WRIA",wria,"\\segments\\EXPORT_SEGMENTS\\wria",wria,"segments457_shad06_",class,".dbf", sep=""))
shad06 <- rbind(shad06, temp)
}

#SHADOW VEG IMPORT



names(shad06) <- c("polyid", "unc06", "shad06")
head(shad06)


class <- 1
#shad06 <- read.table(paste(drive,":\\WRIA",wria,"\\segments\\RDATA\\wria", wria,"class",class,"_shadow_2006.csv", sep=""), header=T)
shad09 <- read.dbf(paste(drive,":\\WRIA",wria,"\\segments\\EXPORT_SEGMENTS\\wria",wria,"segments457_shad09_",class,".dbf", sep=""))
for(class in 2:6){
temp<- read.dbf(paste(drive,":\\WRIA",wria,"\\segments\\EXPORT_SEGMENTS\\wria",wria,"segments457_shad09_",class,".dbf", sep=""))
shad09 <- rbind(shad09, temp)
}

#ADDED TO REMOVE EMPTY ROWID
#shad09 <- shad09[,-1]
names(shad09) <- c("polyid", "unc09", "shad09")
head(shad09)

class <- 1
#shad06 <- read.table(paste(drive,":\\WRIA",wria,"\\segments\\RDATA\\wria", wria,"class",class,"_shadow_2006.csv", sep=""), header=T)
irslice09 <- read.dbf(paste(drive,":\\WRIA",wria,"\\segments\\EXPORT_SEGMENTS\\wria",wria,"segments457_veg09_",class,".dbf", sep=""))
for(class in 2:6){
temp<- read.dbf(paste(drive,":\\WRIA",wria,"\\segments\\EXPORT_SEGMENTS\\wria",wria,"segments457_veg09_",class,".dbf", sep=""))
irslice09 <- rbind(irslice09, temp)
}




#ADDED TO REMOVE EMPTY ROWID
#irslice09 <- irslice09[,-1]
names(irslice09) <- c("polyid", "unc", "noveg", "lowveg", "medveg", "highveg", "shadtree", "waterShad")
head(irslice09)
#END IMPORT

#MATCH SEGEMNTS AND ATTRIBUTE DATA WITH POLYID
gNam <- match(badNames, names(allAtt))
firstAttN <- allAtt
names(firstAttN)[gNam] <- newNames
names(firstAttN) <- gsub("[.]+","",names(firstAttN))
firstAtt1 <- firstAttN[order(firstAttN$"DistLeft"),]
firstAtt2 <- firstAtt1[order(firstAtt1$"DistTop"),]

firstSeg1 <- allSeg[order(allSeg$"X_distance"),]
firstSeg2 <- firstSeg1[order(firstSeg1$"Y_distance"),]
cor(firstSeg2[,"X_distance"],firstAtt2[,"DistLeft"])
sum(firstSeg2[,"X_distance"]-firstAtt2[,"DistLeft"])


#allOut <- data.frame(firstAtt2, PolyID = as.numeric(firstSeg2[,3]), Elevation = firstSeg2$elevation)
allOut <- data.frame(firstAtt2, PolyID = as.numeric(firstSeg2$"PolyID"), RANDU = runif(dim(firstSeg2)[1]))
ni(allOut)
write.csv(allOut, paste(drive,":\\wria",wria,"\\segments\\allOutWRIA13.csv",sep="") row.names=T)

sampleHigh <- sort(sample(allOut[allOut$MeanLayer5 > 225, "PolyID"],2500));sampleHigh
sampleLow <- sort(sample(allOut[allOut$MeanLayer5 < 225, "PolyID"],2500));sampleLow
sampleHigh2 <- sort(sample(allOut[allOut$MeanLayer2 > 175, "PolyID"],2500));sampleHigh
sampleLow2 <- sort(sample(allOut[allOut$MeanLayer2 < 175, "PolyID"],2500));sampleLow
sampleAll <- c(sampleLow, sampleHigh)
sampleHigh2twin <- cbind(sampleHigh2, sampleHigh2)
sampleOut <- cbind(sampleAll, 1)
write.csv(sampleHigh2twin, paste(drive,":\\wria",wria,"\\segments\\sampleHigh2bPolyIDs.csv",sep=""), row.names=T)



##Create combined predictor data set
get09 <- match(shad06$polyid, shad09$polyid)

shad09m <- shad09[get09,]
dim(shad09m)
irslice09m <- irslice09[get09,]

shad06prop <- shad06[,2:3]/apply(shad06[,2:3],1,sum)
shad09prop <- shad09m[,2:3]/apply(shad09m[,2:3],1,sum)
irslice09prop <- irslice09m[,2:8]/apply(irslice09m[,2:8],1,sum)

head(irslice09prop)

segSummaries <- data.frame(PolyID=irslice09m[,1],irslice09prop, shad06prop, shad09prop)

cor(shad06$polyid, shad09m$polyid)
cor(shad06$polyid, irslice09m$polyid)

write.csv(segSummaries, paste(drive,":\\wria",wria,"\\segments\\rdata\\seg",wria,"Summaries.csv",sep=""), row.names=T)

segSumSort <- segSummaries[order(segSummaries$PolyID),]

allOutSort <- allOut[order(allOut$PolyID),]

getAll09 <- match(segSumSort$PolyID, allOutSort$PolyID)

rm(firstAtt, polyAtt1 , polyAtt2, polyAtt3, polyAtt4, lastAtt)
rm(firstSeg, class1Seg, class2Seg, class3Seg, class4Seg, lastSeg)
rm(allSeg)
rm(allOut)
#sum(segSumSort$PolyID-allOutSort$PolyID)

wriaModelData <- data.frame(allOutSort[getAll09,], segSumSort[,-1])
dim(wriaModelData)

write.csv(wriaModelData, paste(drive,":\\WRIA",wria,"\\segments\\RDATA\\wria", wria,"allPolyData.csv", sep=""), row.names=T)

hist(wriaModelData$MeanLayer5, main=paste("WRIA ",wria, " green Diff Histogram"))
savePlot(paste(drive,":\\WRIA",wria,"\\segments\\RDATA\\wria", wria,"_dGreenHistogram2TEST.jpg", sep=""), type="jpg")

highChange <- wriaModelData[wriaModelData$MeanLayer5 > 50,]
highSamplePolyID <- sample(highChange$PolyID, 1500)
getHighSample <- match(highSamplePolyID, highChange$PolyID)
highSample <- highChange[getHighSample,]
write.csv(highSample, paste(drive,":\\WRIA",wria,"\\MODELS\\HIGH_SAMPLE\\wria", wria,"high_sample",Sys.Date(),".csv", sep=""), row.names=T)


lowChange <- wriaModelData[wriaModelData$MeanLayer5 < 50,]
lowSamplePolyID <- sample(lowChange$PolyID, 3500)
getlowSample <- match(lowSamplePolyID, lowChange$PolyID)
lowSample <- lowChange[getlowSample,]
write.csv(lowSample, paste(drive,":\\WRIA",wria,"\\MODELS\\LOW_SAMPLE\\wria", wria,"low_sample",Sys.Date(),".csv", sep=""), row.names=T)


##Run below after classifying samples
library(RODBC)
exConn1 <- odbcConnectExcel2007( paste(drive,":\\WRIA",wria,"\\models\\highSample.xlsx",sep=""))


exConn2 <- odbcConnectExcel2007( paste(drive,":\\WRIA",wria,"\\models\\lowSample.xlsx",sep=""))

highc <- sqlFetch(exConn1, "Sheet1")
lowc <- sqlFetch(exConn2, "Sheet1")

samples <- rbind(lowc, highc)

wriaModelData <- read.csv(paste(drive,":\\wria",wria,"\\eCognition\\allPolyData.csv",sep=""))


getAtts <- match(samples$PolyID, wriaModelData$PolyID)

samplesData <- wriaModelData[getAtts,]

write.csv(samplesData, paste(drive,":\\WRIA",wria,"\\models\\samplePolyData.csv",sep="") row.names=T)
