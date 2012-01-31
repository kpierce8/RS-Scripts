library(RSQLite)
rsql <- dbDriver("SQLite")
tfile <- tempfile()
con <- dbConnect(rsql, dbname = tfile)
dbWriteTable(con, "testdata", singleDissolved)
rs <- dbSendQuery(con, "select * from testdata")
d1 <- fetch(rs, n=10)
d1