#Check for all tiles finished
library(foreign)

newNames<-c("innerX", "innerY", "levName", "className", "levID","Brightness", 
            "maxDiff", "mlayer1", "mlayer2","mlayer3","mlayer4","mlayer5","mlayer6","mlayer7","mlayer8","mlayer9","mlayer10",
            "dNeighL1","dNeighL4","dkNeighL1", "dkNeighL4",
            "AreaPxl","Compactness", "RadLgElpse","RadSmElpse","ShapeInd", "EntCngNDVI",
            "className00","stDev1", "stDev2","stDev3","stDev4","stDev5","stDev6","stDev7","stDev8","stDev9","stDev10",
            "skew5", "skew1", "skew4", "skew6", "skew10", "Xcenter", "Ycenter", "GLCMEnt1", "GLCMEnt10", "GLCMEnt5",
            "GLCMEnt6", "GLCMHom5", "GLCMHom10", "tile")


badNames <- c("inner_x","inner_y","level_name",
              "class_name","object_id_LevAnalysis","Brightness",
              "Max..diff.","Mean.Layer.1","Mean.Layer.2",
              "Mean.Layer.3","Mean.Layer.4","Mean.Layer.5",
              "Mean.Layer.6","Mean.Layer.7","Mean.Layer.8",
              "Mean.Layer.9","Mean.Layer.10","Mean.Diff..to.neighbors.Layer.1..0.",
              "Mean.Diff..to.neighbors.Layer.4..0.","Mean.diff..to.darker.neighbors.Layer.1","Mean.diff..to.darker.neighbors.Layer.4",
              "Area..Pxl.","Compactness","Radius.of.largest.enclosed.ellipse",
              "Radius.of.smallest.enclosing.ellipse","Shape.index","EntropyChangeNDVI",
              "Class.name.0.0.","Standard.deviation.Layer.1","Standard.deviation.Layer.2",
              "Standard.deviation.Layer.3","Standard.deviation.Layer.4","Standard.deviation.Layer.5",
              "Standard.deviation.Layer.6","Standard.deviation.Layer.7","Standard.deviation.Layer.8",
              "Standard.deviation.Layer.9","Standard.deviation.Layer.10","Skewness.Layer.5",
              "Skewness.Layer.1","Skewness.Layer.4","Skewness.Layer.6",
              "Skewness.Layer.10","X.Center","Y.Center",
              "GLCM.Entropy..quick.8.11..Layer.1..all.dir..","GLCM.Entropy..quick.8.11..Layer.10..all.dir..","GLCM.Entropy..quick.8.11..Layer.5..all.dir..",
              "GLCM.Entropy..quick.8.11..Layer.6..all.dir..","GLCM.Homogeneity..quick.8.11..Layer.5..all.dir..","GLCM.Homogeneity..quick.8.11..Layer.10..all.dir..",
              "tile")

newNamesAll<-c("innerX", "innerY", "levName", "className", "levID","Brightness", 
            "maxDiff", "mlayer1", "mlayer2","mlayer3","mlayer4","mlayer5","mlayer6","mlayer7","mlayer8","mlayer9","mlayer10",
            "dNeighL1","dNeighL4","dkNeighL1", "dkNeighL4",
            "AreaPxl","Compactness", "RadLgElpse","RadSmElpse","ShapeInd", "EntCngNDVI",
            "className00","stDev1", "stDev2","stDev3","stDev4","stDev5","stDev6","stDev7","stDev8","stDev9","stDev10",
            "skew5", "skew1", "skew4", "skew6", "skew10", "Xcenter", "Ycenter", "GLCMEnt1", "GLCMEnt10", "GLCMEnt5",
            "GLCMEnt6", "GLCMHom5", "GLCMHom10", "NDVIDIFF", "NDVILOSS")


badNamesAll <- c("inner_x","inner_y","level_name",
              "class_name","object_id_LevAnalysis","Brightness",
              "Max..diff.","Mean.Layer.1","Mean.Layer.2",
              "Mean.Layer.3","Mean.Layer.4","Mean.Layer.5",
              "Mean.Layer.6","Mean.Layer.7","Mean.Layer.8",
              "Mean.Layer.9","Mean.Layer.10","Mean.Diff..to.neighbors.Layer.1..0.",
              "Mean.Diff..to.neighbors.Layer.4..0.","Mean.diff..to.darker.neighbors.Layer.1","Mean.diff..to.darker.neighbors.Layer.4",
              "Area..Pxl.","Compactness","Radius.of.largest.enclosed.ellipse",
              "Radius.of.smallest.enclosing.ellipse","Shape.index","EntropyChangeNDVI",
              "Class.name.0.0.","Standard.deviation.Layer.1","Standard.deviation.Layer.2",
              "Standard.deviation.Layer.3","Standard.deviation.Layer.4","Standard.deviation.Layer.5",
              "Standard.deviation.Layer.6","Standard.deviation.Layer.7","Standard.deviation.Layer.8",
              "Standard.deviation.Layer.9","Standard.deviation.Layer.10","Skewness.Layer.5",
              "Skewness.Layer.1","Skewness.Layer.4","Skewness.Layer.6",
              "Skewness.Layer.10","X.Center","Y.Center",
              "GLCM.Entropy..quick.8.11..Layer.1..all.dir..","GLCM.Entropy..quick.8.11..Layer.10..all.dir..","GLCM.Entropy..quick.8.11..Layer.5..all.dir..",
              "GLCM.Entropy..quick.8.11..Layer.6..all.dir..","GLCM.Homogeneity..quick.8.11..Layer.5..all.dir..","GLCM.Homogeneity..quick.8.11..Layer.10..all.dir..",
              "tile")



eCogWS <- "E:\\wria15_2011\\eCognition\\wria15_09_11"

projDir <- dir(paste(eCogWS, "\\dpr", sep=""))

l50csvDir <- dir(paste(eCogWS, "\\lev50attributes", sep=""))
l50csvDir <- l50csvDir[grep("csv$", l50csvDir)]
dir.create(paste(eCogWS, "\\lev50attributes","\\l50dbf", sep=""))


AnalysiscsvDir <- dir(paste(eCogWS, "\\Analysis", sep=""))
AnalysiscsvDir <-AnalysiscsvDir[grep("csv$", AnalysiscsvDir)]
dir.create(paste(eCogWS, "\\Analysis","\\Analysisdbf", sep=""))

l50ShapeDir <- dir(paste(eCogWS, "\\lev50shape", sep=""))
AnalysisShapeDir <- dir(paste(eCogWS, "\\AnalysisShape", sep=""))


#Get tile count and make tile vector
# split the directory listings into a vector of name parts split on .
nProjB <- projDir[grep("tiles", projDir) ]
nProjA <- strsplit(nProjB,'[.]')




nParts <- strsplit(l50csvDir[1],'[.]')
projName <- nParts[[1]][1]
# make a data.frame out of the split list
Projpaths <- data.frame(t(matrix(unlist(nProjA),5,length(nProjA))))
# convert the "tile000" column into just numbers, make numeric and find max
tileCount <- max(as.numeric(gsub('tile', '', Projpaths[,3])))
tileNumbers <- seq(0,tileCount)

#pathList <- AnalysiscsvDir




getAttributesList <- function(pathList){
nPartsA <- strsplit(pathList,'[.]')
newPaths <- data.frame(t(matrix(unlist(nPartsA),4,length(nPartsA))))
addCount <- data.frame(newPaths, segments = 0)
return(addCount)  
}

findUndone <-function(newPaths){
l50pathsDone <- as.numeric(gsub('tile', '', newPaths[,3]))
donePaths <- setdiff(tileNumbers, l50pathsDone)
return(donePaths)
}

l50List <- getAttributesList(l50csvDir)


length(findUndone(l50List))

AnaList <- getAttributesList(AnalysiscsvDir)
length(findUndone(AnaList))



for( tile in 1:length(l50List[,1])) {
 # for( tile in 103:103) { #USE TO RUN ONE
csvTable <- read.csv(paste(eCogWS, "\\lev50attributes\\",l50csvDir[tile], sep=""), sep=";")
csvTable2 <- data.frame(csvTable, "tile"=l50List[tile,3])
dim(csvTable)
l50List[tile,"segments"] = dim(csvTable)[1]
write.dbf(csvTable2, paste(eCogWS, "\\lev50attributes\\l50dbf\\",l50List[tile,1],"_",l50List[tile,3], ".dbf", sep=""))
}

for( tile in 1:length(AnaList[,1])) {
#  for( tile in 103:103) { #USE TO RUN ONE
  csvTable3 <- read.csv(paste(eCogWS, "\\Analysis\\",AnalysiscsvDir[tile], sep=""), sep=";")
  csvTable4 <- data.frame(csvTable3, "tile"=l50List[tile,3])
  dim(csvTable3)
  AnaList[tile,"segments"] = dim(csvTable3)[1]
  names(csvTable4) <- newNames
  write.dbf(csvTable4, paste(eCogWS, "\\Analysis\\Analysisdbf\\",AnaList[tile,1],"_",AnaList[tile,3], ".dbf", sep=""))
}



#Make giant dbf file
csvTable3 <- read.csv(paste(eCogWS, "\\Analysis\\",AnalysiscsvDir[tile], sep=""), sep=";")
csvTable4 <- data.frame(csvTable3, "tile"=l50List[tile,3])
names(csvTable4) <- newNames
outAnalysisTable <- csvTable4


for( tile in 2:length(AnaList[,1])) {
  csvTable3 <- read.csv(paste(eCogWS, "\\Analysis\\",AnalysiscsvDir[tile], sep=""), sep=";")
  csvTable4 <- data.frame(csvTable3, "tile"=l50List[tile,3])
  names(csvTable4) <- newNames
outAnalysisTable <- rbind(outAnalysisTable, csvTable4)  
}

stitchData <- read.dbf("E:/wria15_2011/Segments/EXPORT_ATTRIBUTES/stitched15b.dbf")
#Get stitched datatable

stitchSort <- stitchData[order(stitchData$LevAnalysi,round(stitchData$X_Center,2),round(stitchData$Y_Center,2)),c("LevAnalysi", "X_Center","Y_Center","PolyID")]
analysisSort <- outt[order(outt$levID,round(outt$Xcenter,2),round(outt$Ycenter,2)),c("levID","Xcenter","Ycenter")]

head(stitchSort)
head(analysisSort)
mAX <- 2
sum(round(stitchSort$X_Center[1:mAX],2) - round(analysisSort$Xcenter[1:mAX],2))
sum(stitchSort$X_Center[mAX:340000] - analysisSort$Xcenter[mAX:340000])

stitchFix <- stitchSort[-2,]

sum(stitchFix$X_Center - analysisSort$Xcenter)
sum(stitchFix$Y_Center - analysisSort$Ycenter)
sum(stitchFix$LevAnalysi - analysisSort$levID)


write.dbf(outAnalysisTable, paste(eCogWS, "\\Analysis\\allSegmentAttributes.dbf", sep=""))

ssGE2 <- stitchSort[stitchSort[,1] > 2,]
aaGE2 <- analysisSort[analysisSort[,1]> 2,]

sum(round(ssGE2$X_Center - aaGE2$Xcenter,2))
sum(round(ssGE2$Y_Center - aaGE2$Ycenter,2))
sum(ssGE2[,1] - aaGE2$levID)

ssLE2 <- stitchSort[stitchSort[,1] <= 2,]
aaLE2 <- analysisSort[analysisSort[,1] <= 2,]

aaLE2B <- data.frame(aaLE2,deq=seq_along(aaLE2[,1]))
head(aaLE2B)

ssLE2B <- ssLE2[c(-2,-296),]
aaLE2C <- aaLE2B[-273,]
#aaLE2C <- aaLE2B

checker <- data.frame(ssLE2B,aaLE2C, euc=round(sqrt((aaLE2C[,2]-ssLE2B[,2])^2 + (aaLE2C[,3]-ssLE2B[,3])^2),1))
checker


round(sqrt((aaLE2[,2]-ssLE2B[,2])^2 + (aaLE2[,3]-ssLE2B[,3])^2),1)

round(cbind(ssLE2[-2,2],aaLE2[,2],round(ssLE2[-2,2]-aaLE2[,2])),1)

allStats <- read.csv("E:\\wria15_2011\\eCognition\\wria15_09_11\\Analysis\\wria15_2009_5bandhm5.csv", sep=";")
dim(allStats)
