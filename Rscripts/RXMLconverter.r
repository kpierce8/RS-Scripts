library(XML)

data <- read.csv("C:\\data\\Visual Studio 2010\\Projects\\WpfApplication1\\WpfApplication1\\boxData.csv")

library(XML)

xml <- xmlTree()
xml$addTag("ArrayofBoxDataSource", close=FALSE)
for (i in 1:nrow(data)) {
    xml$addTag("boxDataSource", close=FALSE)
    for (j in names(data)) {
        xml$addTag(j, data[i, j])
    }
    xml$closeTag()
}
xml$closeTag()

# view the result
cat(saveXML(xml))

saveXML(xml, "C:\\data\\Visual Studio 2010\\Projects\\WpfApplication1\\WpfApplication1\\boxDataR.xml", compression = 0, indent=T)