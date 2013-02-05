#wria <- "62_2011"
#drive <- "G"
#model <- "mv_Change_Sample"
#model <- "AA_PredictedChange"

#One of the weirdest R constructs ever [PASTE WINDOWS PATH AFTER
target <-scan(what="character",allowEscapes=F) 
J:\wria10_2009\Models\landSamples2009\output\AAData.xml

#blank line ends interactive input so to speak
print(target)


pieces <- strsplit(target,"\\\\")
outName <- pieces[[1]][length(pieces[[1]])-2]
endIndex <- length(pieces[[1]])-2
outputPath <- paste0(pieces[[1]][1:endIndex],collapse="/")



library(foreign)
library(XML)
highc <- xmlToDataFrame(target)
library(foreign)
highc$PolyID <- as.numeric(as.vector(highc$PolyID))
highc$ChangeClass <- as.numeric(as.vector(highc$ChangeClass))
highc$data1 <- as.numeric(as.vector(highc$data1))

summary(highc)
table(highc$ChangeClass)
write.dbf(highc, paste(outputPath,"/",outName,"AA.dbf",sep=""))



with(highc, tapply(data1,ChangeClass,sum))

changed <- with(highc, sum(highc[ChangeClass < 4, "data1"]))
changed
nonchanged <- with(highc, sum(highc[ChangeClass > 3, "data1"]))

changed/nonchanged