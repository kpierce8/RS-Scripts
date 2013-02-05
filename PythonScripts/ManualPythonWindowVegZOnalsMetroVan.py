
rasterDict = {"veg04":"G:/MetroVanWDFW/Examples/mv04_unsurpervised10.img",
              "veg09":"G:/MetroVanWDFW/Examples/mv09_unsurpervised10.img"
              }

segments = "G:/Abbotsford/MV2012remodel.gdb/metroVanSegments2013"
dataOut = "G:/Abbotsford/Segments/EXPORT_ATTRIBUTES/"

# Set the output table name
batchSize = 80000
rasterField = "Value"
arcpy.MakeFeatureLayer_management(segments, 'features_Layer2')
featCount = arcpy.GetCount_management('features_Layer2')

rasters = ["veg04", "veg09"]
myGroups = int(featCount.getOutput(0))//batchSize + 1



for myGr in range(1,2):

for myGr in range(1,myGroups + 1):
	myStart = batchSize * (myGr -1)
    myEnd = myStart + batchSize -1
    queryString = ' "%s" >=  %d And "%s" <=  %d' % ("NewPolyID", myStart, "NewPolyID", myEnd)
    arcpy.SelectLayerByAttribute_management('features_Layer2', "NEW_SELECTION", queryString )
    for myraster in range(0,len(rasters)):  #Skipping DEM already done
        raster = rasters[myraster]    
        outTable09 = dataOut + raster + "_" + str(myGr) + ".dbf"
        arcpy.sa.TabulateArea('features_Layer2', "NewPolyID", rasterDict[raster], "Value", outTable09, 1)		  