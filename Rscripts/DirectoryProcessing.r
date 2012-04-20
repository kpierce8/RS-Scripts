memory.limit(3200)
myFiles <- dir("F:\\Parcels_Veg_Project\\stats")
library(foreign)
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
test <- read.dbf(paste("F:\\Parcels_Veg_Project\\stats\\", fName, sep=''))
assign(gsub('.dbf','',dbfFiles[i]), test)
dbfFiles[i]
head(test)

if(fName == "wria13veg.dbf"){
wria13veg$VALUE_5 <- wria13veg$VALUE_5 + wria13veg$VALUE_6
wria13veg <- wria13veg[,-8]
test <- wria13veg[,-8]
}

colsCount <- c(colsCount, dim(test)[2])
}


wria1veg <- rbind(wria1group1veg, wria1group2veg)
wria7veg <- rbind(wria7group1veg, wria7group2veg)
wria8veg <- rbind(wria8group1veg, wria8group2veg, wria8group3veg, wria8group5veg)
wria9veg <- rbind(wria9group1veg, wria9group2veg, wria9group3veg, wria9group4veg)
wria10veg <- rbind(wria10group1veg, wria10group2veg)
wria12veg <- rbind(wria12group1veg, wria12group2veg)
wria15veg <- rbind(wria15group1veg, wria15group2veg)

wria1veg <- wria1veg[order(wria1veg$FID_),]
wria7veg <- wria7veg[order(wria7veg$POLYIDINT),]
wria8veg <- wria8veg[order(wria8veg$FID_),]
wria9veg <- wria9veg[order(wria9veg$FID_),]
wria10veg <- wria10veg[order(wria10veg$FID_),]
wria12veg <- wria12veg[order(wria12veg$FID_),]
wria15veg <- wria15veg[order(wria15veg$FID_),]

wria1ID <- read.dbf("F:\\Parcels_Veg_Project\\wria1.dbf")
wria1veg2 <- data.frame(wria1veg, total = apply(wria1veg[,-1],1,sum))
wria1vegA <- data.frame(wria1veg2, wria1ID[wria1veg$FID_ + 1,])
tail(wria1vegA)
wria8ID <- read.dbf("F:\\Parcels_Veg_Project\\wria8.dbf")
wria8veg2 <- data.frame(wria8veg, total = apply(wria8veg[,-1],1,sum)/10.76)
wria8vegA <- data.frame(wria8veg2, wria8ID[wria8veg$FID_ + 1,])
wria9ID <- read.dbf("F:\\Parcels_Veg_Project\\wria9.dbf")
wria9veg2 <- data.frame(wria9veg, total = apply(wria9veg[,-1],1,sum))
wria9vegA <- data.frame(wria9veg2, wria9ID[wria9veg$FID_ + 1,])
tail(wria9vegA)
wria10ID <- read.dbf("F:\\Parcels_Veg_Project\\wria10.dbf")
wria10veg2 <- data.frame(wria10veg, total = apply(wria10veg[,-1],1,sum))
wria10vegA <- data.frame(wria10veg2, wria10ID[wria10veg$FID_ + 1,])
tail(wria10vegA)
wria12ID <- read.dbf("F:\\Parcels_Veg_Project\\wria12.dbf")
wria12veg2 <- data.frame(wria12veg, total = apply(wria12veg[,-1],1,sum))
wria12vegA <- data.frame(wria12veg2, wria12ID[wria12veg$FID_ + 1,])
tail(wria12vegA)

wria19veg <- read.dbf("F:\\Parcels_Veg_Project\\stats\\wria19veg.dbf")
wria19ID <- read.dbf("F:\\Parcels_Veg_Project\\wria19.dbf")
wria19veg2 <- data.frame(wria19veg, total = apply(wria19veg[,-1],1,sum))
wria19vegA <- data.frame(wria19veg2, wria19ID[wria19veg$FID_ + 1 ,])
tail(wria19vegA)



wria1veg <- wria1vegA[,c(24,2:7)]
wria8veg <- wria8vegA[,c(24,2:7)]
wria9veg <- wria9vegA[,c(24,2:7)]
wria10veg <- wria10vegA[,c(24,2:7)]
wria12veg <- wria12vegA[,c(24,2:7)]
wria19veg <- wria19vegA[,c(24,2:7)]

names(wria1veg)[1] <- "POLYIDINT"
names(wria19veg)[1] <- "POLYIDINT"
names(wria8veg)[1] <- "POLYIDINT"
names(wria9veg)[1] <- "POLYIDINT"
names(wria10veg)[1] <- "POLYIDINT"
names(wria12veg)[1] <- "POLYIDINT"

allVeg <- rbind(wria1veg,
wria2veg,
wria4veg,
wria5veg,
wria6veg,
wria8veg,
wria9veg,
wria10veg,
wria11veg,
wria12veg,
wria13veg,
wria16veg,
wria17veg,
wria18veg,
wria19veg
)

dim(allVeg)

allvegSort <- allVeg[sort(allVeg[,1]),]
head(allvegSort)
rm(allVeg)
allVegProp <- t(t(data.frame(allvegSort[3:7])/apply(allvegSort[,3:7],1,sum)))

allVegPropEx <- data.frame(allvegSort, allVegProp)
head(allVegProp)

write.dbf(allVegPropEx, "F:\\Parcels_Veg_Project\\stats\\allVegPropEx.dbf")
