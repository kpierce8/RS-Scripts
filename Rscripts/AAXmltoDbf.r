wria <- "15_2011"
drive <- "F"
model <- "AA_COMMISSION"

library(foreign)
library(XML)
highc <- xmlToDataFrame(paste(drive,":\\WRIA",wria,"\\MODELS\\",model,"\\output\\aadata.xml",sep=""))
library(foreign)
highc$PolyID <- as.numeric(as.vector(highc$PolyID))
highc$ChangeClass <- as.numeric(as.vector(highc$ChangeClass))
highc$data1 <- as.numeric(as.vector(highc$data1))



write.dbf(highc, paste(drive,":\\WRIA",wria,"\\MODELS\\",model,"\\",model,wria,".dbf",sep=""))

summary(highc)

with(highc, tapply(data1,ChangeClass,sum))

changed <- with(highc, sum(highc[ChangeClass < 4, "data1"]))
changed
nonchanged <- with(highc, sum(highc[ChangeClass > 3, "data1"]))

changed/nonchanged