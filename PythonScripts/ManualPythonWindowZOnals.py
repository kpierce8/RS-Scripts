
rasterDict = {
              "veg09":"J:/wria10_2009/Separation/wria10_2009_10class.img"
              }

batchSize = 70000			  
exp_workspace = "J:/wria10_2009/Segments/EXPORT_ATTRIBUTES"
dataOut = exp_workspace + "/"
tPolys = "wria10Segments"
rasters = ["veg09"]
wria = 39


for myGr in range(4,9):
   for myraster in range(0,len(rasters)):  #Skipping DEM already done
		try:
			raster = rasters[myraster]
			myStart = batchSize * (myGr -1)
			myEnd = myStart + batchSize -1
			queryString = ' "%s" >=  %d And "%s" <=  %d' % ("PolyID", myStart, "PolyID", myEnd)
			arcpy.SelectLayerByAttribute_management(tPolys, "NEW_SELECTION", queryString )
			outTable09 = dataOut + raster + "_" + str(wria) + "_" + str(myGr) + ".dbf"
			arcpy.sa.ZonalStatisticsAsTable(tPolys, "PolyID", rasterDict[raster], outTable09, "DATA", "MEAN_STD")		  
		except:
			print("oops")