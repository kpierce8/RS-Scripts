library(foreign)
wria <- 10
#One of the weirdest R constructs ever [PASTE WINDOWS PATH AFTER
target <-scan(what="character",allowEscapes=F) 
J:\wria10_2009\Output\wria10Segments_AAFinal.dbf

#blank line ends interactive input so to speak
print(target)
pieces <- strsplit(target,"\\\\")
endIndex <- length(pieces[[1]])-1
outputPath <- paste0(pieces[[1]][1:endIndex],collapse="/")
outputPath

#dataseg <- read.dbf(paste0(outputPath,"\\wria",wria,"_2011modelData.dbf"))

datamat <- read.dbf(target)
datamat$bin <- cut(datamat$CProb,  breaks=seq(0,1,.05))
obsData <- datamat[datamat$AAClass < 100 & datamat$AAClass > 0,]
changeData <- datamat[datamat$AAClass < 4 & datamat$AAClass > 0,]
table(datamat$AAClass)

#Total area
tAcres <- sum(datamat$AcresI)
tAcres
#Observed
oAcres <- sum(obsData$AcresI)
oAcres
#Observation %
oAcres/tAcres





hist(datamat$AcresI,xlim=c(0,50),breaks=seq(0,200,.25),xlab="Acres",main="Counts of datamat segments < 100 ac.", )
hist(obsData$AcresI,xlim=c(0,10),ylim=c(0,8000),breaks=seq(0,200,.25),xlab="Acres",main="Counts of obsData segments < 10 ac.", )

dim(datamat[datamat$AcresI < 10,])
sum(datamat[datamat$AcresI < 10,"AcresI"])

dim(datamat[datamat$Acres > 10,])
sum(datamat[datamat$AcresI > 10,"AcresI"])

dim(obsData[obsData$AcresI > 10,])
sum(obsData[obsData$AcresI > 10,"AcresI"])

found <- hist(obsData$CProb[obsData$AAClass < 4],breaks=seq(0,1,.05), plot=F)
looked <- hist(obsData$CProb, breaks=seq(0,1,.05), plot=F)
skipped <- hist(datamat$CProb[datamat$AAClass == 0], breaks=seq(0,1,.05),plot=F)



plot(found$mids,found$counts/looked$counts, pch="", ylab="Proportion Changed",xlim=c(1,0) ,xlab="Modeled Probability of Change", main=paste("Wria ",wria," CPUE", sep=""))
text(found$mids,found$counts/looked$counts, looked$counts, cex=.8)
maxOmission <- max(obsData[obsData$Model == "Omission","CProb"])
abline(v=maxOmission,col="green")

outFile <- paste(outputPath,"/","CPUE_WRIA",wria,".pdf",sep="")
savePlot(filename=outFile,type="pdf")


plot(found$mids,1 -(found$counts/looked$counts), pch=20, ylab="Commission Error",xlim=c(1,0) ,type="l", xlab="Modeled Probability of Change", main=paste("Wria ",wria," CPUE", sep=""))
abline(v=maxOmission,col="green")
outFile <- paste(outputPath,"/","CommissionCount_WRIA",wria,".pdf",sep="")
savePlot(filename=outFile,type="pdf")

skipped$counts

found$counts

#Attempts to calculate omission in other ways, by numbers, by numbers in bins, etc
sum(found$counts/looked$counts*skipped$counts)
sum(found$counts)
#Mapped by polygon number
sum(foundA$counts)/sum(foundA$counts/lookedA$counts*allBins$counts)

head(datamat)

meanAcres <- tapply(datamat$Acres,datamat$bin,mean)
sum(found$counts/looked$counts*skipped$counts*meanAcres)
meanObsAcres <- tapply(obsData$Acres,obsData$bin,mean)
meanChangeAcres <- tapply(changeData$Acres,changeData$bin,mean)
meanChangeAcres/meanObsAcres

sumAllAcres <- tapply(datamat$Acres,datamat$bin,sum)
sumAllAcres

sumBinAcres <- tapply(obsData$Acres,obsData$bin,sum)
sumBinAcres
sumChangeAcres <- tapply(changeData$Acres,changeData$bin,sum)
sumChangeAcres

commissionArea <- 1 -sumChangeAcres/sumBinAcres
seq(0.05,1,.05)

binMax <- seq(0.025,.975,.05)
plot(binMax,commissionArea, pch='', xlab="Change Probability", ylab="Commission Error by Area")
abline(v=0.25)
abline(v=0.5)
text(binMax,commissionArea, round(sumBinAcres), cex=.8, col=c(1,"gray50"))
text(0.75,0.8,"Plotted values are acres observed")
text(0.765,0.75,"by 5% bin. Colors are for readability.")
title("Commission rate calculated by area for different probability bins")
outFile <- paste(outputPath,"/","CommissionArea_WRIA",wria,".pdf",sep="")
savePlot(filename=outFile,type="pdf")
sumChangeAcres

commissionAcres <- sumBinAcres-sumChangeAcres
commissionAcres

plot(binMax,commissionAcres, pch=20, ylim = c(0,1000), xlab="Change Probability", ylab="Commission Error by Area")
abline(h=0)
abline(h=100, col="gray75")
abline(h=50, col="gray75")
abline(v=0.25, col="gray75")
abline(v=0.5, col="gray75")
text(.23,1000,"First bin value omitted at 6,678 acres")
title("Observed Commission Acres")
outFile <- paste(outputPath,"/","ObservedCommissionArea_WRIA",wria,".pdf",sep="")
savePlot(filename=outFile,type="pdf")
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

#Change bin tables
cngBins <- data.frame(Midprob =binMax, Acres =round(sumAllAcres), ObsAcres =round(sumBinAcres), CngAcres = round(sumChangeAcres), CngPolys = found$counts,ObsPolys =looked$counts, NonObsPolys = skipped$counts, ComPoly =looked$counts-found$counts, ComAcres = round(sumBinAcres -sumChangeAcres ))
cngBins

write.table(cngBins, paste0(outputPath,"/","ChangeTable_WRIA",wria,".csv"))


