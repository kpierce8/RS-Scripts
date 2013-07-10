#Check for all tiles finished
library(foreign)

newNames<-c("innerX", "innerY", "levName", "className", "subTableID","superID","tileNumber", 
            "mlayer1", "mlayer2","mlayer3","mlayer4","mlayer5","mlayer6","mlayer7","mlayer8","mlayer9","mlayer10","mlayer11",
			"stDev1", "stDev2","stDev3","stDev4","stDev5","stDev6","stDev7","stDev8","stDev9","stDev10","stDev11",
            "ConNeigh1","ConNeigh4","ConNeigh9","DifSuper1",
			"Value_R06", "Value_R09","Value_RDf","Satur_R06", "Satur_R09","Satur_RDf",
            "Rect.Fit","EdgeArea", "WidthMain",
            "Xcenter", "Ycenter", 
			"GLCMHom1", "GLCMHom4", "GLCMHom9","class2")



eCogWS <- "J:\\wria17_2009\\eCognition"
wria <- "17"

projDir <- dir(paste(eCogWS, "\\results", sep=""))

l50csvDir <- dir(paste(eCogWS, "\\results\\subObjectStatistics", sep=""))
l50csvDir <- l50csvDir[grep("csv$", l50csvDir)]
dir.create(paste(eCogWS, "\\results\\subObjectStatistics","\\SOStatsdbf", sep=""))


# AnalysiscsvDir <- dir(paste(eCogWS, "\\results", sep=""))
# AnalysiscsvDir <-AnalysiscsvDir[grep("csv$", AnalysiscsvDir)]
# dir.create(paste(eCogWS, "\\results","\\Analysisdbf", sep=""))

l50ShapeDir <- dir(paste(eCogWS, "\\lev50shape", sep=""))
#AnalysisShapeDir <- dir(paste(eCogWS, "\\AnalysisShape", sep=""))


#Get tile count and make tile vector
# split the directory listings into a vector of name parts split on .
nProjB <- projDir[grep("tiles", projDir) ]
nProjA <- strsplit(nProjB,'[.]')

nProjB <- l50csvDir[grep("tiles", l50csvDir) ]
nProjA <- strsplit(nProjB,'[.]')


nParts <- strsplit(l50csvDir[1],'[.]')
projName <- nParts[[1]][1]
# make a data.frame out of the split list
Projpaths <- data.frame(t(matrix(unlist(nProjA),4,length(nProjA))))
# convert the "tile000" column into just numbers, make numeric and find max
tileCount <- max(as.numeric(gsub('tile', '', Projpaths[,3])))
tileNumbers <- seq(0,tileCount)
tileNumbers

#pathList <- AnalysiscsvDir




getAttributesList <- function(pathList){
nPartsA <- strsplit(pathList,'[.]')
newPaths <- data.frame(t(matrix(unlist(nPartsA),4,length(nPartsA))))
addCount <- data.frame(newPaths, segments = 0)
return(addCount)  
}

findUndone <-function(newPaths){
l50pathsDone <- as.numeric(gsub('tile', '', newPaths[,3]))
donePaths <- setdiff(tileNumbers, l50pathsDone)
return(donePaths)
}

l50List <- getAttributesList(l50csvDir)
l50List

length(findUndone(l50List))

#AnaList <- getAttributesList(AnalysiscsvDir)
#length(findUndone(AnaList))


####REWRITEN to use single folder solution (previously each table was in its own folder)
for( tile in 1:length(l50csvDir)) {
 # for( tile in 103:103) { #USE TO RUN ONE
csvTable <- read.csv(paste(eCogWS, "\\results\\subObjectStatistics\\",l50csvDir[tile], sep=""), sep=",")
csvTable2 <- data.frame(csvTable)
dim(csvTable)
names(csvTable2) <- newNames
l50List[tile,"segments"] = dim(csvTable)[1]
write.dbf(csvTable2, paste(eCogWS, "\\results\\subObjectStatistics\\SOStatsdbf\\",l50List[tile,1],"_",l50List[tile,3], ".dbf", sep=""))
}


##########Above used to convert csv to dbf, BELOW loop concatenates dbfs, USE PYTHON SCRIPT INSTEAD
#Make lev 50 huge dbf file may have to run in 2-3 big parts and cbind together due to poor memory usage with for loops 
#Make giant dbf file 
tile <- 1
csvTable3 <- read.dbf(paste(eCogWS, "\\results\\subObjectStatistics\\SOStatsdbf\\",l50List[tile,1],"_",l50List[tile,3], ".dbf", sep=""))
csvTable4 <- data.frame(csvTable3, "tile"=l50List[tile,3])
print(c(tile, dim(csvTable4)[2]))
subTableTable <- csvTable4
dim(subTableTable)



for( tile in 2:20) {
  csvTable3 <- read.dbf(paste(eCogWS, "\\results\\subObjectStatistics\\SOStatsdbf\\",l50List[tile,1],"_",l50List[tile,3], ".dbf", sep=""))
  csvTable4 <- data.frame(csvTable3, "tile"=l50List[tile,3])
  print(c(tile, dim(csvTable4)[2]))
  subTableTable <- rbind(subTableTable, csvTable4)  
}

subTableTwo <- data.frame()
for( tile in 21:length(l50List[,1])) {
  csvTable3 <- read.dbf(paste(eCogWS, "\\results\\subObjectStatistics\\SOStatsdbf\\",l50List[tile,1],"_",l50List[tile,3], ".dbf", sep=""))
  csvTable4 <- data.frame(csvTable3, "tile"=l50List[tile,3])
  print(c(tile, dim(csvTable4)))
  subTableTwo <- rbind(subTableTwo, csvTable4)  
}

dim(subTableTable)



write.csv(subTableTable, paste(eCogWS, "\\results\\subObjectStatistics\\SOStatsdbf\\wria",wria,"subTableTable1.csv", sep=""), sep=",")

#If multiple runs need to be combined
write.csv(allTable, paste(eCogWS, "\\results\\subObjectStatistics\\SOStatsdbf\\wria",wria,"allTable.csv", sep=""), sep=",")

