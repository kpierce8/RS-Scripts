
wria2 <- "17"
wria <- paste0(wria2,"_2009")
wria
drive <- "J"
eCogWS <- paste0(drive,":\\wria",wria,"\\eCognition\\wria",wria)
eCogWS


library(foreign)
super <- read.dbf(paste0(drive,":\\wria",wria,"\\Segments\\AnalysisObjectStatistics.dbf"))

sub <- read.csv(paste(eCogWS, "\\results\\wria",wria,"SubObjectAttributes.csv", sep=""), sep=",")






maxID <- 1000000

newNames<-c("innerX", "innerY", "levName", "className","subID", "superID","tileNumber", 
            "mlayer1", "mlayer2","mlayer3","mlayer4","mlayer5","mlayer6","mlayer7","mlayer8","mlayer9","mlayer10","mlayer11",
			"stDev1", "stDev2","stDev3","stDev4","stDev5","stDev6","stDev7","stDev8","stDev9","stDev10","stDev11",
            "ConNeigh1","ConNeigh4","ConNeigh9","SuperDiff1",
			"Value_R06", "Value_R09","Value_RDf","Satur_R06", "Satur_R09","Satur_RDf",
            "Rect.Fit","EdgeArea", "WidthMain",
            "Xcenter", "Ycenter", 
			"GLCMHom1", "GLCMHom4", "GLCMHom9","Class2")


length(newNames)			
 
 names(sub) <- newNames




sub$linkID <- sub$tileNumber * maxID + sub$superID
summary(sub$linkID)
super$linkID <- super$tileNumber * maxID + super$levelID
subCounts <- table(sub$linkID)
length(subCounts)
dim(super)
#transfer stitchedID
getStitched <- match( sub$linkID, super$linkID)
sub$stitchID <- super$stitchID[getStitched]

summary(getStitched)

write.csv(sub, paste(eCogWS, "\\results\\wria",wria,"allSubObjectsLinked.csv", sep=""))



#Count of subpolygons
subCount <- as.data.frame(table(sub$stitchID))
subCountDF <- data.frame(PolyID = as.numeric(as.vector(subCount$Var1)),Count = subCount$Freq)
summary(subCountDF)
#variance in saturation 
satVar06 <- as.vector(tapply(sub$Satur_R06,sub$stitchID,var))
satVar09 <- as.vector(tapply(sub$Satur_R09,sub$stitchID,var))
satDiff <- as.vector(satVar09-satVar06)
#variance in value (brightness)
valVar06 <- as.vector(tapply(sub$Value_R06,sub$stitchID,var))
valVar09 <- as.vector(tapply(sub$Value_R09,sub$stitchID,var))
valDiff <- as.vector(valVar09-valVar06)
#variances in individual attributes
eaVar <-  as.vector(tapply(sub$EdgeArea,sub$stitchID,var))
glcm1Var <-  as.vector(tapply(sub$GLCMHom1,sub$stitchID,var))
glcm4Var <-  as.vector(tapply(sub$GLCMHom4,sub$stitchID,var))

subObjectSummaries <- data.frame(subCountDF,satVar06,satVar09,satDiff,valVar06,valVar09,valDiff,eaVar,glcm1Var,glcm4Var)

subObjectSummaries[is.na(satVar06),-1] <- 0

dim(subObjectSummaries)
write.dbf(subObjectSummaries, paste(eCogWS, "\\results\\wria",wria,"subSummaries.dbf", sep=""))

#Below just shows row values are IDs
test09 <- tapply(sub$Satur_R09,sub$linkID,var)

