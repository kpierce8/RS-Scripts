#MATCH example, ID columns are just rownumbers permuted once

df1 <- data.frame(rownum = seq(1:100), ID = sample(seq(1:100), 100))

df2 <- data.frame(rownum = seq(1:456), ID = sample(seq(1:456), 456))

##Get the 100 from df2 that match df1 in the order of df1$ID

# Usual method with an index and a subsetting
#		getSubset <- match(df1$ID, df2$ID)
#		df3 <- df2[getSubset,]
#OR as one line

df3 <- df2[match(df1$ID, df2$ID),]

dim(df1)
dim(df2)
dim(df3)

head(df1)
head(df2)
head(df3)