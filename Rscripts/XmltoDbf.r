wria <- 13
drive <- "D"
class <- 1

library(XML)
highc <- xmlToDataFrame(paste(drive,":\\WRIA",wria,"\\MODELS\\last452\\output\\aadata.xml",sep=""))
library(foreign)
write.dbf(highc, paste(drive,":\\WRIA",wria,"\\MODELS\\last452\\outputPredChangeClassLAST452.dbf",sep=""))