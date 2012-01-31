import sys, string, os, arcgisscripting, re
#stolen from HD_subroutines, removing wx, time

gp = arcgisscripting.create()
gp.SetProduct("ArcInfo")
gp.CheckOutExtension("spatial")
gp.OverwriteOutput = True
gp.AddToolbox("C:/Program Files/ArcGIS/ArcToolbox/Toolboxes/Spatial Analyst Tools.tbx")
gp.AddToolbox("C:/Program Files/ArcGIS/ArcToolbox/Toolboxes/Conversion Tools.tbx")
gp.AddToolbox("C:/Program Files/ArcGIS/ArcToolbox/Toolboxes/Data Management Tools.tbx")
gp.AddToolbox("C:/Program Files/ArcGIS/ArcToolbox/Toolboxes/Analysis Tools.tbx")

#Get necessary files

#Create a BATCH field in the shapefile of interest using any applicable mehtod
#example using python syntax in ARC10 try math.ceil(!myID!/90000)+1 to get groups of size 90000


#myFeatures = "K:/PugetSoundDataStack/ParcelAnalysis/PS_Parcels_v2010_prov4.shp"
myFeatures = "D:/WRIA13/segments/wria13segments/wria13segments457"


myRaster = "D:/WRIA13/imagery/2009_naip/wria13_veg6layer.img"
#myRaster2 = "K:/SpatialData/CCAP/imperv06_4602.img"



# Set the output table name


MaxIter = 33
rasterField = "Class_name"

for n in range(0,MaxIter):
    try:
       # outTable01 = "K:/PugetSoundDataStack/ParcelAnalysis/nlcdREDO/nlcd01_" + str(n) + ".dbf"
       # outTable06 = "K:/PugetSoundDataStack/ParcelAnalysis/nlcdREDO/nlcd06_" + str(n) + ".dbf"
        outTable = "D:/WRIA13/segments/wria13segments/wria13segments457_veg09_" + str(n) + ".dbf"
       # outTable2 = "K:/PugetSoundDataStack/ParcelAnalysis/ISREDO/Round3/imper06_" + str(n) + ".dbf"
        # MAKE copy to process
        gp.MakeFeatureLayer_management(myFeatures, 'features_Layer2')
        gp.SelectLayerByAttribute_management('features_Layer2', "NEW_SELECTION", ' "%s" =  %d' % ("Batch", n))
        #gp.CopyFeatures_management('features_Layer2', newFeatures)
        #gp.TabulateArea_sa('features_Layer2', "myParcelID", myRaster01, rasterField, outTable01, 30)
        #gp.TabulateArea_sa('features_Layer2', "myParcelID", myRaster06, rasterField, outTable06, 30)
        gp.ZonalStatisticsAsTable_sa('features_Layer2', "myParcelID", myRaster, outTable, "DATA")
       # gp.ZonalStatisticsAsTable_sa('features_Layer2', "myParcelID", myRaster2, outTable2, "DATA")
    except:
        print "iteration for batch" + str(n)