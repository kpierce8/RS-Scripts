library(foreign)
#One of the weirdest R constructs ever [PASTE WINDOWS PATH AFTER
inputPath <-scan(what="character",allowEscapes=F) 
J:\wria10_2009\Models\landSamples2006\wria10_landSamples2006_final.dbf

#blank line ends interactive input so to speak
print(inputPath)
datamat <- read.dbf(inputPath)

library(lattice)

datamat <- datamat[datamat$AAClass < 10,]

datamat5500 <- datamat[datamat$Elevation < 5500,]

plotColors <- c("red","black","steelblue","sienna4","yellowgreen","green","gray50","white","forestgreen")

histogram(~AAClass | MajNoRain, data=datamat, col=plotColors, breaks=seq(0,9))

histogram(~AAClass | MajNoRain, data=datamat5500, col=plotColors, breaks=seq(0,9), main="Classes W10 2006")
table(datamat$AAClass)
table(datamat$MajNoRain)