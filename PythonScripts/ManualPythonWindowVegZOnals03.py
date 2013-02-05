drive = "J"
wria = "03"

rasterDict = {"veg09":"wria" + str(wria) + "_2009_vegFilters5x5.img",
              "veg11":"wria" + str(wria) + "_2011_vegFilters5x5.img"
              }

segments = drive + ":/wria" + str(wria) + "_2011/Segments/wria" + str(wria) + "_11Segments.gdb/wria" + str(wria) + "_11Segments"
dataOut = drive + ":/wria" + str(wria) + "_2011/Segments/EXPORT_ATTRIBUTES/"

# Set the output table name
batchSize = 80000
rasterField = "Value"
arcpy.MakeFeatureLayer_management(segments, 'features_Layer2')
featCount = arcpy.GetCount_management('features_Layer2')

rasters = ["veg09","veg11"]
myGroups = int(featCount.getOutput(0))//batchSize + 1

for myGr in range(1,myGroups + 1):

for myGr in range(1,5):
	myStart = batchSize * (myGr -1)
    myEnd = myStart + batchSize -1
    queryString = ' "%s" >=  %d And "%s" <=  %d' % ("PolyID", myStart, "PolyID", myEnd)
    arcpy.SelectLayerByAttribute_management('features_Layer2', "NEW_SELECTION", queryString )
    for myraster in range(0,len(rasters)):  #Skipping DEM already done
        raster = rasters[myraster]    
        outTable09 = dataOut + raster + "_" + str(wria) + "_" + str(myGr) + ".dbf"
        arcpy.sa.TabulateArea('features_Layer2', "PolyID", rasterDict[raster], "Value", outTable09, 1)		  