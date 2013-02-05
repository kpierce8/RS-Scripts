#wria <- "62_2011"
drive <- "G"
model <- "mv_Change_Sample"
#model <- "AA_PredictedChange"

library(foreign)
library(XML)
highc <- xmlToDataFrame(paste(drive,":\\MetroVanWDFW\\MODELS\\",model,"\\output\\aadata.xml",sep=""))
library(foreign)
highc$PolyID <- as.numeric(as.vector(highc$PolyID))
highc$ChangeClass <- as.numeric(as.vector(highc$ChangeClass))
highc$data1 <- as.numeric(as.vector(highc$data1))

summary(highc)
table(highc$ChangeClass)
write.dbf(highc, paste(drive,":\\MetroVanWDFW\\MODELS\\",model,"\\",model,"2.dbf",sep=""))



with(highc, tapply(data1,ChangeClass,sum))

changed <- with(highc, sum(highc[ChangeClass < 4, "data1"]))
changed
nonchanged <- with(highc, sum(highc[ChangeClass > 3, "data1"]))

changed/nonchanged