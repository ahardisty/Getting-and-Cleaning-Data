##Getting and Cleaning Data Week 3 Quiz

#Question 1
houseUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(houseUrl,"../../Data/house.csv", method = "curl")
houseData <- read.csv("../../Data/house.csv", header=TRUE)

#subset on households greater than 10 acres and $10,000 of agricultural products
agriculturalLogical <- which(houseData$ACR == 3 & houseData$AGS == 6,) #identify the rows that meet the which arguments
agriculturalLogical <- select(houseData, ACR == 3 & AGS == 6)
agriculturalLogical <- houseData[ houseData$ACR == 3 & houseData$AGS == 6, ]
summary(agriculturalLogical)
agriculturalLogical[1:3]
agriculturalLogical

#Question 2
#Using the jpeg package read in the following picture of your instructor into R 
install.packages("jpeg")
?download.file
library(jpeg)
Q2Link <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(Q2Link, "../../Data/jeff.jpg", method="curl")
Q2Image <- readJPEG("../../Data/jeff.jpg",native=TRUE)
quantile (Q2Image,probs= c(.3, .8))


#Question 3
#Load the Gross Domestic Product data for the 190 ranked countries in this data set:
#Load the educational data from this data set: 
#Match the data based on the country shortcode. 
#How many of the IDs match? Sort the data frame in descending order by GDP rank. 
#What is the 13th country in the resulting data frame? 

Q3GDP <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
Q3EDU <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"

download.file(Q3GDP,"../../Data/GDP.csv", method="curl", )
download.file(Q3EDU,"../../Data/EDU.csv", method="curl")

GDP <- read.csv("../../Data/GDP.csv", header=TRUE, sep=",", skip=4 , blank.lines.skip = TRUE,na.strings=c("", "NA") ) #skip first four rows of csv; change blanks to NA
EDU <- read.csv("../../Data/EDU.csv", header=TRUE, sep=",")
head(GDP)

GDP <- select(GDP, 1:2,4:5)
names(GDP)
head(GDP)
colnames(GDP) = c("CountryCode","Rank","CountryName","GDP") #rename columns

#check if data frame was created correctly
str(GDP)
GDP %>%
  arrange(desc(Rank)) %>%
  filter

newGDP <- GDP[order(GDP$Rank, decreasing=F),]
newGDP <- newGDP[1:190,]


newGDP$Rank <- as.numeric( newGDP$Rank ) #change class of GDP$Rank
newGDP$Income <- as.numeric( newGDP$Income ) #change class of GDP$Income
newGDP <- GDP[which(GDP$Rank<190),]
newGDP2 <- GDP[which(GDP$Rank==1),]

newGDP
GDP 
sort

names(GDP)
names(EDU)
#default is to merge all common column names


intersect(names(GDP),names(EDU)) #shows intersection of data sets; must indicate merge fields

mergedData = merge.data.frame(GDP,EDU,by.x="CountryCode",by.y="CountryCode",all=FALSE) #merge dataframes on shared id
head(mergedData)


library(reshape2) #load reshape library