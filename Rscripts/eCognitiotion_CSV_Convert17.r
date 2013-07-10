

wria2 <- "17"
wria <- paste0(wria2,"_2009")
wria
drive <- "J"
eCogWS <- paste0(drive,":\\wria",wria,"\\eCognition")
eCogWS



super <- read.csv(paste0(eCogWS,"\\results\\wria",wria2,"_2006_clp.csv"))
polys <- read.dbf(paste0(drive,":\\wria",wria,"\\Segments\\PolygonObjectAttributes.dbf"))

fixTiles <- match(super$stitchedID, polys$stitchedID)

summary(fixTiles)
super$tileNumber <- polys[fixTiles,"TileValue"]
summary(super$tileNumber)


print(target)

library(foreign)



cbind(names(super),seq(along=names(super)))

#----------
 
 
 
 
 ecogData <- super[,-46] #lose second class name
 
 newNames<-c("innerX", "innerY", "levName", "className", "stitchID","tileNumber","levelID", 
            "mlayer1", "mlayer2","mlayer3","mlayer4","mlayer5","mlayer6","mlayer7","mlayer8","mlayer9","mlayer10","mlayer11",
			"stDev1", "stDev2","stDev3","stDev4","stDev5","stDev6","stDev7","stDev8","stDev9","stDev10","stDev11",
            "ConNeigh1","ConNeigh4",
			"Value_R06", "Value_R09","Value_RDf","Satur_R06", "Satur_R09","Satur_RDf",
            "Rect.Fit","EdgeArea", "WidthMain",
            "Xcenter", "Ycenter", 
			"GLCMHom1", "GLCMHom4", "GLCMHom9","GLCMEnt1", "GLCMEnt4", "GLCMEnt9", "tileNumber")

dim(ecogData)
length(newNames)			

names(ecogData) <- newNames
cbind(names(ecogData),seq(along=names(ecogData)))

ecogData[,6] <- ecogData[,49]
ecogData <- ecogData[,-49]

 
wMain <- as.numeric(as.vector(ecogData$WidthMain))
summary(wMain)
wMain[is.na(wMain)] <- 1
ecogData$WidthMain <- wMain

summary(ecogData)


 
 library(foreign)
 write.dbf(ecogData, paste0(drive,":\\wria",wria,"\\Segments\\AnalysisObjectStatistics.dbf"))
 
 #initial sample check using R/G ratio differences

rg2006 <- ecogData$mlayer1 / (ecogData$mlayer2 + .01) 
rg2009 <- ecogData$mlayer4 / (ecogData$mlayer5 + .01)  
rg_change <- rg2006-rg2009 
hist(rg_change)
 
strataBreak <- quantile(rg_change, .1)

rgRatio <- data.frame(PolyID=ecogData$stitchID, rg2006, rg2009, rg_change)
write.dbf(rgRatio, "J:\\wria18_2009\\Segments\\rgRatioData.dbf")

ChangeStrata <- rgRatio[rgRatio$rg_change < strataBreak,] 
NoChangeStrata <- rgRatio[rgRatio$rg_change > strataBreak,] 
dim(ChangeStrata) 
dim(NoChangeStrata) 

CSSamples <- ChangeStrata[sample(seq(1,dim(ChangeStrata)[1]),500),]
dim(CSSamples)
NCSSamples <- NoChangeStrata[sample(seq(1,dim(NoChangeStrata)[1]),500),]
dim(NCSSamples)
rgSamples <- rbind(CSSamples,NCSSamples)
rgSamples <- rgSamples[order(rgSamples$PolyID),]


write.dbf(rgSamples, "J:\\wria18_2009\\Segments\\rgRatioSamples.dbf")

