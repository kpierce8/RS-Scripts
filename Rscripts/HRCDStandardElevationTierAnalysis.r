#Elevation and Prediction Tier analysis

library(foreign)
#One of the weirdest R constructs ever [PASTE WINDOWS PATH AFTER
target <-scan(what="character",allowEscapes=F) 
J:\wria10_2009\Output\wria10_2009ChangeIntersects.dbf

#blank line ends interactive input so to speak
print(target)
datamatB <- read.dbf(target)

pieces <- strsplit(target,"\\\\")
endIndex <- length(pieces[[1]])-1
outputPath <- paste0(pieces[[1]][1:endIndex],collapse="/")




datamatB$Elev10 <- 10 * round(datamatB$Elevation/10)

datamat <- na.omit(datamatB)
datamat <- datamatB #no NA Problems


#datamat <- datamatNA[datamatNA$AAClass < 4,]


dim(datamat)
head(datamat)

#ANALYSIS 1 MAPPED CHANGE BY PROBABILITY SEGMENT
maxE <- max(datamat$Elevation)
maxC <- sum(datamat$AcresI)

MinCheck <- 0.25

tier1 <- datamat[datamat$CProb >= 0.5,]
tier1 <- tier1[order(tier1$Elevation),]
sum(tier1$AcresI)
plot(tier1$Elevation,cumsum(tier1$AcresI), xlim=c(0,maxE), ylim=c(0,maxC), pch=20, xlab="Elevation (m)", ylab="Cumulative Mapped Change (acres)")

tier2 <- datamat[datamat$CProb >= MinCheck & datamat$CProb < 0.5,]
tier2 <- tier2[order(tier2$Elevation),]
sum(tier2$AcresI)
points(tier2$Elevation,cumsum(tier2$AcresI) , pch=20, col=3)


tier3 <- datamat[datamat$datamat$CProb < MinCheck,]
tier3 <- tier3[order(tier3$Elevation),]
sum(tier3$AcresI)


abline(v=1000, col=13, lwd=2)
abline(v=5000, col=6, lwd=2)
title(paste0("Mapped Change by Probability Segment ", pieces[[1]][2]))
savePlot(paste0(outputPath,"/", pieces[[1]][2], "TieredChangeCDF.pdf"),type="pdf") 


boxplot(datamat$AcresI ~ datamat$Prediction)

boxplot(datamat$AcresI ~ datamat$AAClass)

table(datamat$AAClass)
tapply(datamat$AcresI, datamat$AAClass, sum)

rug(tier2$Elevation, col=3)
rug(tier1$Elevation, side=3)
rug(cumsum(tier1$AcresI), side=2)
rug(cumsum(tier2$AcresI), side=4, col=3)

hist(tier1$AcresI)
hist(tier2$AcresI)
hist(tier3$AcresI)
hist(datamat$AcresI, breaks=seq(0,200), xlim=c(0,10))
dim(datamat[datamat$AcresI > 50,])


#Convert to elevation bins
elevBins <- seq(0,maxE,10)

tier1Bins <- tapply(tier1$AcresI, tier1$Elev10, sum)
tier2Bins <- tapply(tier2$AcresI, tier2$Elev10, sum)

acres1Bins <- tapply(tier1$AcresI, tier1$Elev10, mean)
acres2Bins <- tapply(tier2$AcresI, tier2$Elev10, mean)

acresBET <- data.frame(Elevation =elevBins, tier1 = tier1Bins[match(elevBins,row.names(tier1Bins))], tier2 =tier2Bins[match(elevBins,row.names(tier2Bins))])
acresBET$tier1[is.na(acresBET$tier1)] <- 0 
acresBET$tier2[is.na(acresBET$tier2)] <- 0 
acresBET$Sum <- acresBET$tier1 + acresBET$tier2
acresBET$tier1CS <- cumsum(acresBET$tier1)
acresBET$tier2CS <- cumsum(acresBET$tier2)
acresBET$SumCS <- cumsum(acresBET$Sum) 
plot(acresBET$Elevation,acresBET$SumCS, xlim=c(0,maxE), ylim=c(0,maxC), pch=20, xlab="Elevation (m)", ylab="Cumulative Mapped Change (acres)")
with(acresBET, polygon(c(Elevation,max(Elevation)), c(SumCS,0), col="slategray1"))
points(acresBET$Elevation,cumsum(acresBET$tier1),pch=20)
with(acresBET, polygon(c(Elevation,max(Elevation)), c(tier1CS,0), col="palegoldenrod"))
abline(v=1000, col=13, lwd=2)
abline(v=5000, col=6, lwd=2)

title(paste0("Stacked Mapped Change by Probability Segment ", pieces[[1]][2]))
savePlot(paste0(outputPath,"/", pieces[[1]][2], "StackedTieredChangeCDF.pdf"),type="pdf") 


#Not Liking this yet
library(ggplot2)
qplot(x=Elevation,y=SumCS,data = acresBET, geom="line")  +geom_ribbon(data=acresBET, aes(ymax=SumCS),ymin=0, fill="red") +geom_ribbon(data=acresBET, aes(ymax=tier1CS),ymin=0, fill="blue")
abline(v=1000, col=3, lwd=2)
 

## MAPPED CHANGE BY TYPES

type2 <- datamat[datamat$AAClass == 2,]
type2 <- type2[order(type2$Elevation),]
sum(type2$AcresI)
plot(type2$Elevation,cumsum(type2$AcresI), xlim=c(0,maxE),col=10, pch=20, xlab="Elevation (m)", ylab="Cumulative Mapped Change (acres)" )

type1 <- datamat[datamat$AAClass == 1,]
type1 <- type1[order(type1$Elevation),]
sum(type1$AcresI)
points(type1$Elevation,cumsum(type1$AcresI), pch=20, col=13)


type3 <- datamat[datamat$AAClass == 3,]
type3 <- type3[order(type3$Elevation),]
sum(type3$AcresI)
points(type3$Elevation,cumsum(type3$AcresI), pch=20, col=3)

abline(v=1000, col=13, lwd=2)
abline(v=5000, col=6, lwd=2)
title(paste0("Mapped Change by Type ", pieces[[1]][2]))
savePlot(paste0(outputPath,"/", pieces[[1]][2], "TypedChangeCDF.pdf"),type="pdf") 


#Tier diagram for just type 1 change

#MAPPED CHANGE BY PROBABILITY SEGMENT
maxE <- max(type1$Elevation)
maxC <- sum(type1$AcresI)

tier1 <- type1[type1$Prediction == 1,]
tier1 <- tier1[order(tier1t1$Elevation),]
sum(tier1$AcresI)
plot(tier1$Elevation,cumsum(tier1$AcresI), xlim=c(0,maxE), ylim=c(0,maxC), pch=20, xlab="Elevation (m)", ylab="Cumulative Mapped Change (acres)")

tier2 <- type1[type1$Prediction == 2,]
tier2 <- tier2[order(tier2$Elevation),]
sum(tier2$AcresI)
points(tier2$Elevation,cumsum(tier2$AcresI) , pch=20, col=3)


tier3 <- type1[type1$Prediction == 3,]
tier3 <- tier3[order(tier3$Elevation),]
sum(tier3$AcresI)
title("Mapped Development Change by Probability Segment")

abline(v=1000, col=13, lwd=2)
abline(v=5000, col=6, lwd=2)
savePlot(paste0(outputPath,"/", pieces[[1]][2], "TieredDevChangeCDF.pdf"),type="pdf") 


elevBins <- seq(0,maxE,10)

tier1Bins <- tapply(tier1$AcresI, tier1$Elev10, sum)
tier2Bins <- tapply(tier2$AcresI, tier2$Elev10, sum)

acres1Bins <- tapply(tier1$AcresI, tier1$Elev10, mean)
acres2Bins <- tapply(tier2$AcresI, tier2$Elev10, mean)

acresBET <- data.frame(Elevation =elevBins, tier1 = tier1Bins[match(elevBins,row.names(tier1Bins))], tier2 =tier2Bins[match(elevBins,row.names(tier2Bins))])
acresBET$tier1[is.na(acresBET$tier1)] <- 0 
acresBET$tier2[is.na(acresBET$tier2)] <- 0 
acresBET$Sum <- acresBET$tier1 + acresBET$tier2
acresBET$tier1CS <- cumsum(acresBET$tier1)
acresBET$tier2CS <- cumsum(acresBET$tier2)
acresBET$SumCS <- cumsum(acresBET$Sum) 
plot(acresBET$Elevation,acresBET$SumCS, xlim=c(0,maxE), ylim=c(0,maxC), pch=20, xlab="Elevation (m)", ylab="Cumulative Mapped Change (acres)")
with(acresBET, polygon(c(Elevation,max(Elevation)), c(SumCS,0), col="slategray1"))
points(acresBET$Elevation,cumsum(acresBET$tier1),pch=20)
with(acresBET, polygon(c(Elevation,max(Elevation)), c(tier1CS,0), col="palegoldenrod"))
abline(v=1000, col=13, lwd=2)
abline(v=5000, col=6, lwd=2)

title(paste0("Stacked Developement Change by Probability Segment ", pieces[[1]][2]))
savePlot(paste0(outputPath,"/", pieces[[1]][2], "StackedTieredDevChangeCDF.pdf"),type="pdf") 


#Tier diagram for just type 2 change

#MAPPED CHANGE BY PROBABILITY SEGMENT
maxE <- max(type2$Elevation)
maxC <- sum(type2$AcresI)

tier1 <- type2[type2$Prediction == 1,]
tier1 <- tier1[order(tier1t1$Elevation),]
sum(tier1$AcresI)
plot(tier1$Elevation,cumsum(tier1$AcresI), xlim=c(0,maxE), ylim=c(0,maxC), pch=20, xlab="Elevation (m)", ylab="Cumulative Mapped Change (acres)")

tier2 <- type2[type2$Prediction == 2,]
tier2 <- tier2[order(tier2$Elevation),]
sum(tier2$AcresI)
points(tier2$Elevation,cumsum(tier2$AcresI) , pch=20, col=3)


tier3 <- type2[type2$Prediction == 3,]
tier3 <- tier3[order(tier3$Elevation),]
sum(tier3$AcresI)
title("Mapped Change by Probability Segment")

abline(v=1000, col=13, lwd=2)
abline(v=5000, col=6, lwd=2)

elevBins <- seq(0,maxE,10)

tier1Bins <- tapply(tier1$AcresI, tier1$Elev10, sum)
tier2Bins <- tapply(tier2$AcresI, tier2$Elev10, sum)

acres1Bins <- tapply(tier1$AcresI, tier1$Elev10, mean)
acres2Bins <- tapply(tier2$AcresI, tier2$Elev10, mean)

acresBET <- data.frame(Elevation =elevBins, tier1 = tier1Bins[match(elevBins,row.names(tier1Bins))], tier2 =tier2Bins[match(elevBins,row.names(tier2Bins))])
acresBET$tier1[is.na(acresBET$tier1)] <- 0 
acresBET$tier2[is.na(acresBET$tier2)] <- 0 
acresBET$Sum <- acresBET$tier1 + acresBET$tier2
acresBET$tier1CS <- cumsum(acresBET$tier1)
acresBET$tier2CS <- cumsum(acresBET$tier2)
acresBET$SumCS <- cumsum(acresBET$Sum) 
plot(acresBET$Elevation,acresBET$SumCS, xlim=c(0,maxE), ylim=c(0,maxC), pch=20, xlab="Elevation (m)", ylab="Cumulative Mapped Change (acres)")
with(acresBET, polygon(c(Elevation,max(Elevation)), c(SumCS,0), col="slategray1"))
points(acresBET$Elevation,cumsum(acresBET$tier1),pch=20)
with(acresBET, polygon(c(Elevation,max(Elevation)), c(tier1CS,0), col="palegoldenrod"))
abline(v=1000, col=13, lwd=2)
abline(v=5000, col=6, lwd=2)
title(paste0("Stacked Forestry/Undetermined Change by Probability Segment ", pieces[[1]][2]))
savePlot(paste0(outputPath,"/", pieces[[1]][2], "StackedTieredForestryChangeCDF.pdf"),type="pdf") 

#Tier diagram for just type 3 change

#MAPPED CHANGE BY PROBABILITY SEGMENT
maxE <- max(type3$Elevation)
maxC <- sum(type3$AcresI)

tier1 <- type3[type3$Prediction == 1,]
tier1 <- tier1[order(tier1t1$Elevation),]
sum(tier1$AcresI)
plot(tier1$Elevation,cumsum(tier1$AcresI), xlim=c(0,maxE), ylim=c(0,maxC), pch=20, xlab="Elevation (m)", ylab="Cumulative Mapped Change (acres)")

tier2 <- type3[type3$Prediction == 2,]
tier2 <- tier2[order(tier2$Elevation),]
sum(tier2$AcresI)
points(tier2$Elevation,cumsum(tier2$AcresI) , pch=20, col=3)


tier3 <- type3[type3$Prediction == 3,]
tier3 <- tier3[order(tier3$Elevation),]
sum(tier3$AcresI)
title("Mapped Change by Probability Segment")

abline(v=1000, col=13, lwd=2)
abline(v=5000, col=6, lwd=2)

elevBins <- seq(0,maxE,10)

tier1Bins <- tapply(tier1$AcresI, tier1$Elev10, sum)
tier2Bins <- tapply(tier2$AcresI, tier2$Elev10, sum)

acres1Bins <- tapply(tier1$AcresI, tier1$Elev10, mean)
acres2Bins <- tapply(tier2$AcresI, tier2$Elev10, mean)

acresBET <- data.frame(Elevation =elevBins, tier1 = tier1Bins[match(elevBins,row.names(tier1Bins))], tier2 =tier2Bins[match(elevBins,row.names(tier2Bins))])
acresBET$tier1[is.na(acresBET$tier1)] <- 0 
acresBET$tier2[is.na(acresBET$tier2)] <- 0 
acresBET$Sum <- acresBET$tier1 + acresBET$tier2
acresBET$tier1CS <- cumsum(acresBET$tier1)
acresBET$tier2CS <- cumsum(acresBET$tier2)
acresBET$SumCS <- cumsum(acresBET$Sum) 
plot(acresBET$Elevation,acresBET$SumCS, xlim=c(0,maxE), ylim=c(0,maxC), pch=20, xlab="Elevation (m)", ylab="Cumulative Mapped Change (acres)")
with(acresBET, polygon(c(Elevation,max(Elevation)), c(SumCS,0), col="slategray1"))
points(acresBET$Elevation,cumsum(acresBET$tier1),pch=20)
with(acresBET, polygon(c(Elevation,max(Elevation)), c(tier1CS,0), col="palegoldenrod"))
abline(v=1000, col=13, lwd=2)
abline(v=5000, col=6, lwd=2)
title(paste0("Stacked Natural Change by Probability Segment ", pieces[[1]][2]))
savePlot(paste0(outputPath,"/", pieces[[1]][2], "StackedTieredNaturalChangeCDF.pdf"),type="pdf") 

