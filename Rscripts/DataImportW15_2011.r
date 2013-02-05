library(foreign)

newNamesAll<-c("stitchedID", "innerX", "innerY", "levName", "className", "levID","Brightness", 
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
#forgot stitched index
allStatsInd <- read.csv("J:\\wria15_2011\\eCognition\\wria15_09_11\\Analysis\\Indexwria15_2009_5bandhm5.csv", sep=";")
allStats <- read.csv("J:\\wria15_2011\\eCognition\\wria15_09_11\\Analysis\\allwria15_2009_5bandhm5.csv", sep=";")

w15segStats <- data.frame(stitchedID = allStatsInd$stitched_ID, allStats)
head(w15segStats)



length(newNamesAll)
dim(w15segStats)

names(w15segStats) <- newNamesAll
write.dbf(w15segStats,"J:\\wria15_2011\\Segments\\stitchedStats.dbf" )

#Get zonal results

expAttributes <- "E:\\wria15_2011\\Segments\\EXPORT_ATTRIBUTES"

projDir <- dir(expAttributes)


dbfFiles <- projDir[grep("dbf$", projDir)]

veg09Tables <- dbfFiles[grep("veg09", dbfFiles)]
veg11Tables <- dbfFiles[grep("veg11", dbfFiles)]
dem10Tables <- dbfFiles[grep("dem10", dbfFiles)]



veg09Data <- data.frame()
for (fl in veg09Tables) {
dataIn <- read.dbf(paste(expAttributes,"\\",fl,sep=""))  
veg09Data <- rbind(veg09Data, dataIn)  
}
dim(veg09Data)

veg11Data <- data.frame()
for (fl in veg11Tables) {
  dataIn <- read.dbf(paste(expAttributes,"\\",fl,sep=""))  
  veg11Data <- rbind(veg11Data, dataIn)  
}
dim(veg11Data)


dem10Data <- data.frame()
for (fl in dem10Tables) {
  dataIn <- read.dbf(paste(expAttributes,"\\",fl,sep=""))  
  dem10Data <- rbind(dem10Data, dataIn)  
}
dim(dem10Data)
write.dbf(dem10Data, paste(expAttributes, "\\demOut.dbf", sep=""))



#Make Proportions
veg09prop <- veg09Data[,2:8]/apply(veg09Data[,2:8],1,sum)
veg11prop <- veg11Data[,2:8]/apply(veg11Data[,2:8],1,sum)


vegNames09 <- c("nodata09", "shadow09", "NoVeg09", "treeShad09", "HighVeg09", "MedVeg09", "LowVeg09")
vegNames11 <- c("nodata11", "shadow11", "NoVeg11", "treeShad11", "HighVeg11", "MedVeg11", "LowVeg11")

names(veg09prop) <- vegNames09
names(veg11prop) <- vegNames11

veg09Out <- data.frame(PolyID = veg09Data$POLYID, veg09prop)
veg11Out <- data.frame(PolyID = veg11Data$POLYID, veg11prop)

getVeg09 <- match(w15segStats$stitchedID, veg09Out$PolyID)
getVeg11 <- match(w15segStats$stitchedID, veg11Out$PolyID)

modelData <- data.frame(w15segStats, veg09Out[getVeg09,], veg11Out[getVeg11,])

write.dbf(modelData, paste(expAttributes, "\\modelDataOut.dbf", sep="") )
