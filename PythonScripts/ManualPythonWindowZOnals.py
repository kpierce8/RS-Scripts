
rasterDict = {
              "dem10":"I:/wria39_2011/IMAGERY/DEM/wria39_dem10.img",
             "aspect10":"I:/wria39_2011/IMAGERY/DEM/wria39_dem10_as.img",
             "slope10":"I:/wria39_2011/IMAGERY/DEM/wria39_dem10_sl.img",
              }

batchSize = 70000			  
exp_workspace = "I:/wria39_2011/Segments/EXPORT_ATTRIBUTES"
dataOut = exp_workspace + "/"
tPolys = "wria39_11Segments"
rasters = ["dem10","aspect10","slope10"]
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