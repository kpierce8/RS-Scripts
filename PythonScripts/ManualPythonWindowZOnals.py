
rasterDict = {
              "dem10":"J:/wria22_2011/IMAGERY/DEM/wria22_dem10.img",
             "aspect10":"J:/wria22_2011/IMAGERY/DEM/wria22_dem10_as.img",
             "slope10":"J:/wria22_2011/IMAGERY/DEM/wria22_dem10_sl.img",
              }

batchSize = 70000			  
exp_workspace = "J:/wria22_2011/Segments/EXPORT_ATTRIBUTES"
dataOut = exp_workspace + "/"
tPolys = "w22_11Segments483K_proj"
rasters = ["dem10","aspect10","slope10"]
wria = 22

for myGr in range(1,8):
    for myraster in range(1,len(rasters)):  #Skipping DEM already done
        raster = rasters[myraster]
        myStart = batchSize * (myGr -1)
        myEnd = myStart + batchSize -1
        queryString = ' "%s" >=  %d And "%s" <=  %d' % ("PolyID", myStart, "PolyID", myEnd)
        arcpy.SelectLayerByAttribute_management(tPolys, "NEW_SELECTION", queryString )
        outTable09 = dataOut + raster + "_" + str(wria) + "_" + str(myGr) + ".dbf"
        arcpy.sa.ZonalStatisticsAsTable(tPolys, "PolyID", rasterDict[raster], outTable09, "DATA", "MEAN_STD")		  