library(foreign)
wria <- 22
#One of the weirdest R constructs ever [PASTE WINDOWS PATH AFTER
target <-scan(what="character",allowEscapes=F) 
N:\HRCD_Geodatabases\2011\wria22_2011HRCD\wria22_2011segmentData.dbf

#blank line ends interactive input so to speak
print(target)
pieces <- strsplit(target,"\\\\")
endIndex <- length(pieces[[1]])-1
outputPath <- paste0(pieces[[1]][1:endIndex],collapse="/")
outputPath

modelData <- read.dbf(paste0(outputPath,"\\wria",wria,"_2011modelData.dbf"))

segData <- read.dbf(target)
segData$bin <- cut(segData$CProb,  breaks=seq(0,1,.05))
obsData <- segData[segData$AAClass < 100 & segData$AAClass > 0,]
changeData <- segData[segData$AAClass < 4 & segData$AAClass > 0,]
table(segData$AAClass)

#Total area
tAcres <- sum(segData$Acres)
tAcres
#Observed
oAcres <- sum(obsData$Acres)
oAcres
#Observation %
oAcres/tAcres





hist(segData$Acres,xlim=c(0,50),breaks=seq(0,200,.25),xlab="Acres",main="Counts of segData segments < 100 ac.", )
hist(obsData$Acres,xlim=c(0,10),ylim=c(0,8000),breaks=seq(0,200,.25),xlab="Acres",main="Counts of obsData segments < 10 ac.", )

dim(segData[segData$Acres < 10,])
sum(segData[segData$Acres < 10,"Acres"])

dim(segData[segData$Acres > 10,])
sum(segData[segData$Acres > 10,"Acres"])

dim(obsData[obsData$Acres > 10,])
sum(obsData[obsData$Acres > 10,"Acres"])

found <- hist(obsData$CProb[obsData$AAClass < 4],breaks=seq(0,1,.05), plot=F)
looked <- hist(obsData$CProb, breaks=seq(0,1,.05), plot=F)
skipped <- hist(segData$CProb[segData$AAClass == 0], breaks=seq(0,1,.05),plot=F)



plot(found$mids,found$counts/looked$counts, pch="", ylab="Proportion Changed", xlab="Modeled Probability of Change", main=paste("Wria ",wria," CPUE", sep=""))
text(found$mids,found$counts/looked$counts, looked$counts, cex=.8)
maxOmission <- max(obsData[obsData$Model == "Omission","CProb"])
abline(v=maxOmission,col="green")

outFile <- paste(outputPath,"/","CPUE",wria,".jpg",sep="")
savePlot(filename=outFile,type="jpg")

skipped$counts

found$counts

#Attempts to calculate omission in other ways, by numbers, by numbers in bins, etc
sum(found$counts/looked$counts*skipped$counts)
sum(found$counts)
#Mapped by polygon number
sum(foundA$counts)/sum(foundA$counts/lookedA$counts*allBins$counts)



meanAcres <- tapply(segData$Acres,segData$bin,mean)
sum(found$counts/looked$counts*skipped$counts*meanAcres)
meanObsAcres <- tapply(obsData$Acres,obsData$bin,mean)
meanChangeAcres <- tapply(changeData$Acres,changeData$bin,mean)
meanChangeAcres/meanObsAcres

#simple area method
omission <- sum(changeData[changeData$CProb < 0.25,"Acres"])
omissionChecked <- sum(obsData[obsData$CProb < 0.25,"Acres"])
#error rate
omission/omissionChecked
#area omitted
omitAcres <- omission/omissionChecked*(tAcres-oAcres)
mappedChange <- sum(changeData[changeData$CProb > 0.25,"Acres"])
mappedChange
#mapped Percentage
mappedChange/(mappedChange + omitAcres)