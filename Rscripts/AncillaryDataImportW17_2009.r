## Lots of code eliminated due to Jeanne producing nice single files ###
library(foreign)

wria <- "17"
wriaYR <- paste0(wria,"_2009")
drive <- "J"


#Get zonal results

expAttributes <- paste(drive,":\\wria",wriaYR,"\\Segments\\EXPORT_ATTRIBUTES", sep="")

polys <- read.dbf(paste0(drive,":\\wria",wriaYR,"\\Segments\\PolygonObjectAttributes.dbf"))
veg09table <- read.dbf(paste0(expAttributes, "\\cover09_",wria,"_Segments_final.dbf"))
dem10Data<- read.dbf(paste0(expAttributes, "\\dem09_",wria,"_Segments_final.dbf"))
aspect10Data <- read.dbf(paste0(expAttributes, "\\aspect09_",wria,"_Segments_final.dbf"))
slope10Data <- read.dbf(paste0(expAttributes, "\\slope09_",wria,"_Segments_final.dbf"))

classes <- 10

### vNames needs to be actual export names so that columnmatching can occur to fix occasional missing columns
vNames <- c("PolyID",  "VALUE_0", "VALUE_1", "VALUE_2", "VALUE_3", "VALUE_4", "VALUE_5", "VALUE_6", "VALUE_7", "VALUE_8")

classNames09 <- c("PolyID", "NoClass", "Shadow", "Uncertain",  "BuiltGravel", "Ground", "VegShadow", "Grassherb", "Shrub", "Tree")




#Rewritten for one data file
veg09Data <- data.frame(matrix(0,dim(veg09table)[1],classes))
names(veg09Data) <- vNames
veg09Data[,match(names(veg09table),vNames)] <- veg09table


dim(veg09Data)
head(veg09Data)

names(veg09Data) <- classNames09
#write.dbf(veg09Data, paste(expAttributes, "\\veg09Out.dbf", sep=""))



#Make Proportions
veg09prop <- veg09Data[,2:classes]/apply(veg09Data[,2:classes],1,sum)

names(veg09prop) <- classNames09[-1]
veg09Out <- data.frame(PolyID = veg09Data$PolyID, veg09prop)
veg09Sum = apply(veg09Out[,-1],1,sum)
write.dbf(data.frame(veg09Out,sum=veg09Sum), paste(expAttributes, "\\veg09OutProp.dbf", sep=""))
getVeg09 <- match(polys$PolyID, veg09Out$PolyID)
summary(getVeg09)
length(getVeg09)
head(veg09Out)
summary(veg09Out)


getDEM <- match(polys$PolyID, dem10Data$PolyID)
summary(getDEM)
getASP <- match(polys$PolyID, aspect10Data$PolyID)
summary(getASP)
getSLO <- match(polys$PolyID, slope10Data$PolyID)
summary(getSLO)

demData <- data.frame(PolyID = polys$PolyID,DEM = dem10Data[getDEM,"MEAN"], ASP=aspect10Data[getASP,"MEAN"], SLO=slope10Data[getASP,"MEAN"])
demCheck <- demData[is.na(demData$DEM),]

noDEMpolys <- polys[is.na(getDEM),]
checkDEM <- match(noDEMpolys$PolyID, polys$PolyID)
summary(checkDEM)
sum(polys[checkDEM,"Acres"], na.rm=T)

noASPpolys <- polys[is.na(getASP),]
checkASP <- match(noASPpolys$PolyID, polys$PolyID)
summary(checkASP)
sum(polys[checkASP,"Acres"], na.rm=T)

noSLOpolys <- polys[is.na(getSLO),]
checkSLO <- match(noSLOpolys$PolyID, polys$PolyID)
summary(checkSLO)
sum(polys[checkSLO,"Acres"], na.rm=T)
max(polys[checkSLO,"Acres"], na.rm=T)



#write.dbf(noDEMpolys, paste(fixAttributes, "\\noDEMpolys.dbf", sep="") )


####Need to check for slope, dem and aspect stats 
demDataNAFix <- demData
dim(demData)
summary(demData)
demDataNAFix[is.na(demData$DEM),] <- 0
demDataNAFix[is.na(demData$ASP),] <- 0
demDataNAFix[is.na(demData$SLO),] <- 0

write.dbf(demDataNAFix, paste(expAttributes, "\\topoDataOutNAfixed.dbf", sep="") )



# vegDataNAFix <- data.frame(veg09Out[getVeg09,-1], veg11Out[getVeg11,-1])
# vegDataNAFix[is.na(getVeg09),] <- 0
# vegDataNAFix[is.na(getVeg11),] <- 0

# modelData <- data.frame(eCogModelData, vegDataNAFix, demDataNAFix[,-1])
# summary(modelData)


# write.dbf(modelData, paste(expAttributes, "\\modelDataOut.dbf", sep="") )


# modelDataNoNA <- na.omit(modelData)
# write.dbf(modelDataNoNA, paste(expAttributes, "\\modelDataOutNoNA.dbf", sep="") )

