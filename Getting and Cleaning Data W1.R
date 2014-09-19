#This is week 1 of getting and cleaning data;
#I am using it to review GitHub commands.
#here are some more changes. Wonder if it will work
#I have no idea
#testing third push
#testing changes again to test cloning fun stuff

#Here are some changes I made to test the GitHub push

#Lecture Notes
#flat files
fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl, destfile = "../../Data/cameras.csv", method = "curl")
dateDownloaded <- date()

#read.table
cameraData <- read.table("../../Data/cameras.csv") #will not work
cameraData <- read.table("../../Data/cameras.csv", sep = ",", header = TRUE)
head(cameraData)

#read.csv
cameraData2 <-read.csv("../../Data/cameras.csv")
head(cameraData2)

#reading excel files
library(xlsx)
fileUrl2 <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xlsx?accessType=DOWNLOAD"
download.file(fileUrl2, destfile = "../../Data/cameras.xlsx", method = "curl")
dateDownloaded2 <- date()
cameraData3 <- read.xlsx("../../Data/cameras.xlsx",sheetIndex=1,header=TRUE)
colIndex <- 2:3
rowIndex <- 1:4
cameraDataSubset <- read.xlsx("../../Data/cameras.xlsx",sheetIndex=1, colIndex=colIndex,rowIndex=rowIndex)
cameraDataSubset

#reading XML
library(XML)
fileUrl3 <- "http://www.w3schools.com/xml/simple.xml"
doc <- xmlTreeParse(fileUrl3,useInternal=TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)
names(rootNode)
?xmlName
?xmlRoot

rootNode[[1]]
rootNode[[2]]
rootNode[[1]][[1]]

#xmlSApply
xmlSApply(rootNode,xmlValue)
xpathSApply(rootNode,"//name",xmlValue)
xpathSApply(rootNode,"//name",xmlValue)[3]
xpathSApply(rootNode,"//price",xmlValue)[1]


#Baltimore Ravens - html parse
fileUrl4 <- "http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"
doc4 <- htmlTreeParse(fileUrl4,useInternal=TRUE) #html tree parse; useInternal = all content
scores <- xpathSApply(doc4,"//li[@class='score']",xmlValue) #list items; class = score
teams <- xpathSApply(doc4,"//li[@class='team-name']",xmlValue) # list items; class = team
rootNode4 <-xmlRoot(doc4)
xmlName(rootNode4)
names(rootNode4)
rootNode4[[2]][[2]]
scores
teams


#Reading JSON

library(jsonlite)
jsonData <- fromJSON("https://api.github.com/users/jtleek/repos")
names(jsonData)
names(jsonData$owner)
jsonData$owner$id
jsonData$owner$login
jsonData$name

myjson <- toJSON(iris, pretty=TRUE)
cat(myjson)


#trying again. We will see what's up.

#H 1: How many housing units in this survey were worth more than $1,000,000?

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv" 
download.file(fileURL,destfile="../../Data/ACS.csv", method = "curl")
list.files("../../Data")
dateDownLoaded <- date()
dateDownLoaded
Q1 <- read.csv("../../Data/ACS.csv")
head(Q1)

Q1 %>%
  group_by(VAL) %>%
  summarize(count = n()
  )

Q1 %>%
  group_by(VAL)%>%
  summarise(valCount =n ())%>%
  filter(VAL == 24)
  

# 2 Use the data you loaded from Question 1. Consider the variable FES in the code book. 
# Which of the "tidy data" principles does this variable violate?


# 3 Download the Excel spreadsheet on Natural Gas Aquisition Program here: 
# Read rows 18-23 and columns 7-15 into R and assign the result to a variable called: dat
# sum(dat$Zip*dat$Ext,na.rm=T) 
fileURL3 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
download.file(fileURL3, destfile="../../Data/NBAP.xlsx",method="curl")
dateDownloaded <- date()
install.packages("xlsx")
library(xlsx)

colIndex <- 7:15
rowIndex <- 18:23

dat <- read.xlsx("../../Data/NBAP.xlsx", sheetIndex=1, colIndex=colIndex, rowIndex=rowIndex)

head(dat)
names(dat)
sum(dat$Zip*dat$Ext,na.rm=T)

#4
#Read the XML data on Baltimore restaurants from here: 
#How many restaurants have zipcode 21231?

install.packages("XML")
library(XML)
fileUrl4 <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml" 
doc <- xmlTreeParse(fileUrl4,useInternal=TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)
names(rootNode)
rootNode[[1]][[1]]
xmlSApply(rootNode,xmlValue)
xpathSApply(rootNode,"//name",xmlValue)
zip <- xpathSApply(rootNode,"//zipcode",xmlValue)
class(zip)
zip <- data.frame(zip)

names(zip)

dim(filter(zip, zip == 21231)) this works

#try dplyr
Q4 <- zip %>%
  group_by(zip)%>%
  summarise(count = n())%>%
  filter(zip == 21231)



fileUrlTest <- "http://www.w3schools.com/xml/simple.xml"
doc <- xmlTreeParse(fileUrlTest,useInternal=TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)


#
fileUrl5 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl5, destfile="./Data/IDH.csv",method="curl")
install.packages("data.table")
library(data.table)
DT <- fread("./Data/IDH.csv",sep = ,)

#using the fread() command load the data into an R object
#DT 
#Which of the following is the fastest way to calculate the average value of the variable
#pwgtp15 
#broken down by sex using the data.table package?
#Your Answer  	Score	Explanation
DT[,mean(pwgtp15),by=SEX]	#Correct	3.00	
mean(DT$pwgtp15,by=DT$SEX)			
sapply(split(DT$pwgtp15,DT$SEX),mean)			
mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)			
tapply(DT$pwgtp15,DT$SEX,mean)			
rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]

warpbreaks$replicate <- rep(1:9, len=54)
xt <- xtabs (breaks ~., data = warpbreaks)
xt
ftable(xt)
