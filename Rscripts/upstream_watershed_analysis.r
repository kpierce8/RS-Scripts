# code to loop through watersheds and upstream edge lists to create upstream and adjacnt lists
edgePairs <- read.csv("C:\\data\\ProjectsLocal\\Segments\\wria9\\upWRIA9Edges.csv")
dim(edgePairs)
#table(edgePairs[1:100000,1])
edgeData <- read.csv("C:\\data\\ProjectsLocal\\Segments\\wria9\\edgeData.txt")

lowJunction <- read.dbf("C:\\data\\ProjectsLocal\\Segments\\wria9\\junct_elev_low.dbf")

adjList <-  read.dbf("C:\\data\\ProjectsLocal\\Segments\\wria9\\AU_9_Project_Intersect1.dbf")


wsListData <- matrix(0,1,2)

for(i in 1:dim(lowJunction)[1]){
    origin <- lowJunction[i,"Fixed"]
    targetWS <- lowJunction[i,"AU_ID"]
    sub1 <- edgePairs[edgePairs[,1] == origin,]
    #dim(sub1)
    edgeslist1 <- sub1[,2]
    getEdges <- match(edgeslist1, edgeData$ERID)
    upEdges<- edgeData[getEdges,]

    uniqueWatersheds <- unique(upEdges$OriginWS)
    uniqueWatersheds <- uniqueWatersheds[!is.na(uniqueWatersheds)]
    #uw <- list(origin, uniqueWatersheds)
    uwLength <- length(uniqueWatersheds)

    if (uwLength > 0)
    {
      for (j in 1:uwLength){
      wsListData<-rbind(wsListData, c(targetWS, uniqueWatersheds[j]))

      }
    }
}
    
    
wsListData <- data.frame(wsListData)
names(wsListData) <- c("originWS", "upstreamWS")

write.csv(wsListData, "C:\\data\\ProjectsLocal\\Segments\\wria9\\wsUpstreamList.txt", row.names=F)

# Find adjacency lists

wsAdjData <- matrix(0,1,2)

for(i in 1:dim(lowJunction)[1]){

    targetWS <- lowJunction[i,"AU_ID"]
    sub1 <- adjList[adjList$AU_ID == targetWS,]

    uniqueAdjacent <- unique(sub1$AU_ID_1)
    uniqueAdjacent <- uniqueAdjacent[!is.na(uniqueAdjacent)]
    uwLength <- length(uniqueAdjacent)

    if (uwLength > 0)
    {
      for (j in 1:uwLength){
      wsAdjData<-rbind(wsAdjData, c(targetWS, uniqueAdjacent[j]))

      }
    }
}

wsAdjData

names(wsAdjData) <- c("origin", "adjacentUP")

wsAdjUpData <- data.frame(matrix(0,1,2))
names(wsAdjUpData) <- c("origin", "adjacentUP")
for(i in 1:dim(lowJunction)[1]){


    #i <- 7
    targetWS <- lowJunction[i,"AU_ID"]
    adj1 <- data.frame(wsAdjData[wsAdjData[,1] == targetWS,])
    names(adj1) <- c("origin", "adjacentUP")
    
    up1 <-  wsListData[wsListData[,1]== targetWS,2]

    getUpAdj <- match(up1, adj1[,2])
    getUpAdj <- getUpAdj[!is.na(getUpAdj)]
    upAdj <- adj1[getUpAdj,]
    
    uwLength <- length(getUpAdj)
    uwLength
        
        
    if (uwLength > 0)
    {      
      wsAdjUpData<-rbind(wsAdjUpData, upAdj, deparse.level=2)
    }
}

wsAdjUpData

write.csv(wsAdjUpData, "C:\\data\\ProjectsLocal\\Segments\\wria9\\wsUpstreamAdjacentList.txt", row.names=F)

