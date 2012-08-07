getPacks <-data.frame(installed.packages())
getPacks$Priority
is.na(getPacks$Priority)

getPacks[is.na(getPacks$Priority),"Package"]
reinstalls <- as.vector(getPacks[is.na(getPacks$Priority),"Package"])
reinstalls

instScript <- paste('install.packages("', reinstalls, '")', sep="")

write(instScript, "c:/data/rinstScript.txt")