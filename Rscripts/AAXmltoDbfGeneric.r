#One of the weirdest R constructs ever [PASTE WINDOWS PATH AFTER
target <-scan(what="character",allowEscapes=F) 
J:\wria09_2009\Models\AAChange\output\AAData.xml

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

write.dbf(highc, paste(outputPath,"/",outName,"AA.dbf",sep=""))

#New Summary Code
table(highc$ChangeClass)
table(highc$EndClass)
table(highc$percentChange)
table(highc$ChangeClass,highc$EndClass)

changes <- highc[highc$EndClass > 0,]
dim(changes)
table(changes$ChangeClass,changes$EndClass,changes$percentChange)
changes[changes$percentChange == 0,"PolyID"]