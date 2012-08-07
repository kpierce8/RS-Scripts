wria <- "15_2011"
drive <- "F"
model <- "AA_COMMISSION"


library(XML)
highc <- xmlToDataFrame(paste(drive,":\\WRIA",wria,"\\MODELS\\",model,"\\output\\aadata.xml",sep=""))
library(foreign)
highc$PolyID <- as.numeric(highc$PolyID)
highc$ChangeClass <- as.numeric(highc$ChangeClass)

write.dbf(highc, paste(drive,":\\WRIA",wria,"\\MODELS\\",model,"\\",model,wria,".dbf",sep=""))