myFiles <- dir("N:\\Parcels_Veg_Project\\stats")

#get dbf files
gPick <- grep("dbf$",myFiles)
dbfFiles <- myFiles[gPick]

#create set of names without .dbf suffix
prefixDBF <- gsub('.dbf','',dbfFiles)

#get the files locations matching group 
gPick <- grep("group.*dbf$",dbfFiles)
#get just the names with no group
singles <- dbfFiles[-gPick]
#get the ones with group
groups <- dbfFiles[gPick]

colsCount <- c()

for(i in 1:length(dbfFiles)){
fName <- dbfFiles[i]
test <- read.dbf(paste("N:\\Parcels_Veg_Project\\stats\\", fName, sep=''))
assign(gsub('.dbf','',dbfFiles[i]), test)
dbfFiles[i]
head(test)
colsCount <- c(colsCount, dim(test)[2])
}


