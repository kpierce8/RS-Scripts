library(foreign)
newNames<-c("max4","propNV","edgeCon4","edgeCon2", "Con4", "Con2", "AreaEx", "DistNV", "EdgeLength", "DistLeft","DistTop", "innerX", "innerY")
badNames <- c("Max..pixel.value.Layer.4", "Rel..border.to.Non.Veg", "Edge.Contrast.of.neighbor.pixels..Prototype..Layer.4..3."
  , "Edge.Contrast.of.neighbor.pixels..Prototype..Layer.2..3.", "Contrast.to.neighbor.pixels.Layer.4..3."
  , "Contrast.to.neighbor.pixels.Layer.2..3.", "Area..excluding.inner.polygons...Pxl.","Distance.to.Non.Veg..Pxl.", "Border.length..Pxl.",
  "X.distance.to.scene.left.border..Pxl.","Y.distance.to.scene.top.border..Pxl.", "inner_x", "inner_y")

#memory.limit(size=3500)
#ATTRIBUTES IMPORT
wria <- "01"
drive <- "K"

allAtt <- read.csv(paste(drive,":\\WRIA",wria,"\\segments\\EXPORT_ATTRIBUTES\\gt1000wria01stats.csv", sep=""), header=T, sep=";")

dim(allAtt)


#POLYGON IMPORT

allSegTemp <- read.dbf(paste(drive,":\\WRIA",wria,"\\segments\\RDATA\\wria01segments.dbf", sep=""))

dim(allSegTemp)
allSeg <- allSegTemp
rm(allSegTemp)


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
write.dbf(allOut, paste(drive,":\\wria",wria,"\\segments\\allOutWRIA",wria,".dbf",sep=""))

dGreen <- sort(allOut$MeanLayer5)
g90 <- round(0.9 * length(dGreen))
dGreen[g90]
hist(dGreen, main="")
title(paste("dGreen histogram wria ", wria, sep=""))
abline(v=dGreen[g90])

savePlot(paste(drive,":\\wria",wria,"\\segments\\RDATA\\dGreen",wria,".pdf",sep=""), type=c("pdf"))
 