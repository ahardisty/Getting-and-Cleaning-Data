library(ggplot2)
library(GGally)
library(scales)
library(memisc)
library(reshape2)
library(plyr)
library(reshape)
library(gridExtra)
library(RColorBrewer)
library(bitops)
library(RCurl)
library(xlsx)
library(XML)
library(dplyr)
library(httr)

#Getting and Cleaning Data - Week 2
#Testing the push
#testing second push
#testing third push - through R Studio


install.packages("RMySQL")
library(RMySQL)
#connecting and listing databases
hg19 <- dbConnect(MySQL(), user="genome", db = "hg19", host = "genome-mysql.cse.ucsc.edu")
result <- dbGetQuery(ucscDb, "show databases;"); dbDisconnect(ucscDb);
result
hg19 <- dbConnect (MySQL(), user = "genome", db="hg19,
                   host="genome-mysql.cse.ucsc.edu")
allTables <- dbListTables(hg19)
length(allTables)
allTables[1:5]
dbListFields(hg19, "affyU133Plus2")
#get dimension of a specific table
dbGetQuery(hg19, "select count(*) from affyU133Plus2") 

#read from a table
affyData <- dbReadTable(hg19, "affyU133Plus2")
head(affyData)

#select a specific subset  using dbSendQuery
query <- dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3")
affyMis <- fetch(query); quantile(affyMis$misMatches)
affyMisSmall <- fetch(query, n=10); dbClearResult(query); #fetch command with only top 10 records
dim(affyMisSmall)

dbDisconnect(hg19) #close connection

#reading from HDF5
source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")
library(rhdf5)
a

created = h5createFile("example.h5")
created #this will install the packages from Bioconductor; primarily Genomics but good for Big Data

#create groups
created = h5createGroup("example.h5", "foo")
created = h5createGroup("example.h5", "baa")
created = h5createGroup("example.h5","foo/foobaa")
h5ls("example.h5")

#Getting data from the web
#using readLines
con <- url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode <- readLines(con)
close(con)
htmlCode

#parsing with XML
library(XML)
url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
html <- htmlTreeParse(url, useInternalNodes=T)
xpathSApply(html, "//title", xmlValue)
xpathSApply(html, "//td[@id='col-citedby']", xmlValue)

#GET from the httr package
install.packages("httr")
html2 <- GET(url)
content2 = content(html2,as="text")
parsedHtml = htmlParse(file = content2, asText=TRUE)
xpathSApply(parsedHtml,"//title", xmlValue)


#Accessing websites with passwords
pg1 <- GET("http://httpbin.org/basic-auth/user/passwd")
pg1

pg2 <- GET("http://httpbin.org/basic-auth/user/passwd", authenticate("user","passwd"))
pg2
names(pg2)

pg3 <- GET("https://clicky.com/stats/export?site_id=100745457", authenticate("ihq@kp.orgr","img2014"))
clickyURL <-"https://clicky.com/stats/export?site_id=100745457&type=visitors-unique&date_export=2014&daily=1&output=csv"
download.file(clickyURL,"../clickyVisitors.csv", method ="curl")
download.file(clickyURL,"asdf)
getwd()

download.file(clickyVisitorsURL,"../clickyVistors.csv", method="curl")
pg3 <- GET("https://clicky.com/stats/export?site_id=100745457")
pg3
names(pg3)

#Using handles
#allows for authentication across multiple authentications
#RBloggers - web scrapping

##Reading from APIs
install.packages("twitteR")
library(twitteR)
library(jsonlite)

tweets <- searchTwitter("#rstats",n=50)

myapp = oauth_app("athtweets", key="kfdiasTdf2otAhNIpROZ6SxSa", secret="JPO3yXeimdqhXDsIDpBMJYZhQo9Y2IFbWv4cYuKD2rQ2GtmGst")
sig = sign_oauth1.0(myapp, token= "24193168-oCRShwWAHeoJmVFnmfTbVcHMXanHMsAwdMtkIY8yV", token_secret ="mVSBoF6LmQwzpNbu12HLPNRNvNH19IRVDxohHnP3ZMq5C" )
homeTL = GET("https://api.twitter.com/1.1/statuses/home_timeline.json", sig)
json1 = content(homeTL)
json1[1,]
dim(json1)
summary(json1)
json2<- jsonlite::fromJSON(json1)
json2 <- jsonlite::fromJSON(toJSON(json1))
jsonlite::fromJSON(toJSON(json1))
json2

#Week 2 Quiz

#Question 1
install.packages("httr")
library(httr)
install.packages("httpuv")
library(httpuv)
install.packages("jsonlite")
library(jsonlite)

oauth_endpoints("github")
github <- oauth_endpoints("github")
myapp <- oauth_app("github",key="cee6a4fbd8aff94a36bd",secret = "e90188902ee086108f80e3f2f2e04e2735efec87") 
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

req <- GET("https://api.github.com/users/jtleek/repos/", config(token = github_token))
req

json1 <- content(req)
json2 <- jsonlite::fromJSON(toJSON(json1))
names(json2)
json2
json2$

jsonData <- fromJSON("https://api.github.com/users/jtleek/repos")
jsonData$id

names(jsonData$id)
jsonData$name

names(jsonData$name)
jsonData$blobs_url
jsonData$owner$login
jsonData$owner$followers_url



#Question 2
library(RMySQL)
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileURL,destfile="./data/acs.csv", method= "curl" )

list.files("./data")

acs <- read.table("./data/acs.csv",header=TRUE,sep=",")
str(acs)
install.packages("sqldf")
getwd()
library(sqldf)
typeof(acs)
require(sqldf)

A1 <- sqldf("select * from acs where AGEP < 50") #
A2 <- sqldf("select pwgtp1 from acs")
A3 <- sqldf("select pwgtp1 from acs where AGEP < 50")
A4 <- sqldf(“select * from acs”)

head(A1)
A1$AGEP
A2
A3$pwgtp1
A1 [1:2,]
A2 [1:2,]
A3 [1:2,]

sqldf()

#3
Q3 <- unique(acs$AGEP)
str(Q3)
class(Q3)
head(Q3)
Q3A <- sqldf("select distinct AGEP from acs")#
Q3B <- sqldf("select unique * from acs")
Q3C <- sqldf("select distinct pwgtp1 from acs")
Q3D<- sqldf("select unique AGEP from acs")
class(Q3A)

head(Q3A)
head(Q3B)
head(Q3C)

#Q4

con <- url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode <- readLines(con)
close(con)
htmlCode
Q4A <- nchar(htmlCode[10])
Q4B <- nchar(htmlCode[20])
Q4C <- nchar(htmlCode[30])
Q4D <- nchar(htmlCode[100])

Q4 <-matrix(c(Q4A,Q4B,Q4C,Q4D),nrow=1,ncol=4)
Q4
#using readLines
con <- url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode <- readLines(con)
close(con)
htmlCode

#parsing with XML
library(XML)
url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
html <- htmlTreeParse(url, useInternalNodes=T)
xpathSApply(html, "//title", xmlValue)
xpathSApply(html, "//td[@id='col-citedby']", xmlValue)

#GET from the httr package
install.packages("httr")
library(httr); html2 = GET(url)
html2 <- GET(con)
content2 = content(html2,as="text")
parsedHtml = htmlParse(content2, asText=TRUE)
xpathSApply(parsedHtml,"//title", xmlValue)

#5
 
#using fixed width file
url <-"https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
download.file(url,destfile="./data/Q5Data.for", method= "curl" )
str()
Q5 <- read.fwf("./data/Q5Data.for", skip=4,widths=c(12,7,4,9,4,9,4,9,4))
sum(Q5[,4])

head(Q5)

read.fwf

#GET from the httr package
install.packages("httr")
library(httr); html2 = GET(url)
html2 <- GET(con)
content2 = content(html2,as="text")
parsedHtml = htmlParse(content2, asText=TRUE)
xpathSApply(parsedHtml,"//title", xmlValue)

htmlCode <- readLines(con)
con
close(con)
htmlCode
Q4A <- nchar(htmlCode[10])
Q4B <- nchar(htmlCode[20])
Q4C <- nchar(htmlCode[30])
Q4D <- nchar(htmlCode[100])
