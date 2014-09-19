#Getting and Cleaning Data - Week 3
#added heading to test Git Hub
#testing R Studio push

#Subsetting review
set.seed(13435)
X <- data.frame("var1"=sample(1:5),"var2"=sample(6:10),"var3"=sample(11:15))
X <- X[sample(1:5),]; X$var2[c(1,3)] = NA
X

X[,"var1"]
X[,1]
X[,2]
X[1:2,"var2"]
X[1:2,2]

#Dealing with missing values
X[which(X$var2 > 8),]
sort(X$var1)
sort(X$var1, decreasing=T)
sort(X$var2, na.last=F)
sort(X$var2)

#Logicals ands ors
X[(X$var1 <= 3 & X$var3 > 11),] #and
X[(X$var1 <= 3 | X$var3 > 15),] #or

#Ordering
X[order(X$var1),3]

#ordering with dplyr
arrange(X,var1)
arrange(X,desc(var1))
filter(X, var1 <= 5, var2 >=1)

#adding rows and columns
X$var4 <- rnorm(5)
X
Y <- cbind(X,rnorm(5))
Y

library(Hmisc)
yesno <- sample(c(“yes”,”no”), size=10, replace=TRUE)
yesno <- sample(c("yes","no"), size=10, replace=TRUE)
yesnofac <- factor(yesno, levels = c("yes", "no"))
relevel(yesnofac, ref = "yes")
?relevel

##Summarizing data
fileUrl <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl,"../../Data/restaurants.csv", method="curl")
restData <- read.csv("../../Data/restaurants.csv")
head(restData, n=3)
tail(restData, n=3)
summary(restData)
list.files("../../Data")

quantile(restData$councilDistrict,na.rm=TRUE)
quantile(restData$councilDistrict,probs=c(0.5,0.75,0.9))
table(restData$zipCode,useNA="ifany")
table(restData$councilDistrict,restData$zipCode)
colSums(is.na(restData))
all(colSums(is.na(restData))==0)
table(restData$zipCode %in% c("21212"))
head(restData [ restData$zipCode %in% c("21212","21213"),])

#cross tabs
data(UCBAdmissions)
DF = as.data.frame(UCBAdmissions)
summary(DF)
xt <- xtabs(Freq ~ Gender + Admit,data=DF)
xt


##Creating new variables
restData2 <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(restData2,"../../Data/restData3.csv", method = "curl")
restData2 <- read.csv("../../Data/restData2.csv")

summary(restData2)
getwd()




# Melting data frames
library(reshape2)
data(mtcars)
names(mtcars)
head(mtcars)
rownames(mtcars)
mtcars$carname <- rownames(mtcars) #create variable name from row names
carMelt <- melt(mtcars, id = c("carname","gear", "cyl"),measure.vars=c("mpg","hp")) #indicate which variables are ID variables; which are measure variables
carMelt #this is now a tall skinny data set
head(carMelt, n=3) #there is now a row for each car mpg and hp
tail(carMelt, n = 3)


# Casting data frames
cylData <- dcast(carMelt, cyl ~ variable)
cylData #will show number of measures of each variable

cylData <- dcast(carMelt, cyl ~ variable, mean) #recast by mean
cylData
?dcast

summary(carMelt$cyl)
carMelt$cyl
table(carMelt$cyl)

#averaging values within a factor
head(InsectSprays)
names(InsectSprays)
summary(InsectSprays)
tapply(InsectSprays$count, InsectSprays$spray, sum) #apply along an index, a particular count
tapply()

#split values
spIns <- split(InsectSprays$count, InsectSprays$spray)
spIns
sprCount = lapply(spIns,sum)
sprCount = lapply(spIns,sum)
sprCount

#unlist and sapply
unlist(sprCount)

#sapply
sapply(spIns,sum)

library(dplyr)
?ddply
??dplyr

#plyr package
library(plyr)
ddply(InsectSprays,.(spray),summarize,sum=sum(count))
groupSpray <- group_by(x = InsectSprays,spray)
summarize(groupSpray, sum = sum(count))

sprayGroup <- InsectSprays %.%
  group_by(spray) %.%
  summarise(sum = sum(count), 
            sum2 = sum(count))

spraySums <- InsectSprays%.%
  group_by(spray)%.%
  mutate(sum=ave(count, FUN=sum))

names(spraySums)
dim(spraySums)

spraySums <- group_by(InsectSprays, spray)

spraySums <- mutate(spraySums, sum=ave(count,FUN = sum))
head(spraySums)

sprayGroup

#creating a new variable
spraySums <- ddply (InsectSprays,.(spray), summarize, sum=ave(count,FUN=sum))
dim(spraySums)
spraySums
head(spraySums)
spraySums <- ddply(InsectSprays,. (spray), summarize,sum=ave(count,FUN=sum))


spraySums <- ddply(InsectSprays,.(spray),,summarise,sum=sum(count))
spraySums2 <- ddply(InsectSprays,.(spray),summarise,sum=ave(count,FUN=sum))
spraySums
spraySums2
head(spraySums2)


##Merging Data
#will merge on common variable in data sets' id and solution_id
#Peer Review Data
if(!file.exists("./data")){dir.create("./data")}
fileUrl1 = "https://dl.dropboxusercontent.com/u/7710864/data/reviews-apr29.csv"
fileUrl2 = "https://dl.dropboxusercontent.com/u/7710864/data/solutions-apr29.csv"
download.file(fileUrl1,destfile="../../Data/reviews1.csv",method="curl")
download.file(fileUrl2,destfile="../../Data/reviews2.csv",method="curl")
reviews = read.csv("../../Data/reviews.csv"); 
solutions <- read.csv("../../Data/reviews2.csv")
head(reviews,2)
head(solutions,2)

#merge command merge()
names(reviews)
names(solutions)

mergedData = merge(reviews,solutions,by.x="solution_id",by.y="id",all=TRUE)
head(mergedData)

#default is to merge all common column names
intersect(names(solutions),names(reviews)) #shows intersection of data sets; must indicate merge fields

#join using plyr package
df1 = data.frame(id=sample(1:10),x=rnorm(10))
df2 = data.frame(id=sample(1:10),y=rnorm(10))
df3 = data.frame(id=sample(1:10),z=rnorm(10))
dfList = list(df1,df2,df3)
join_all(dfList)
df1

##Week 3 Quiz
#Create a logical vector that identifies the households on greater than 10 acres who sold more than $10,000 worth of agriculture products. 
#Assign that logical vector to the variable agricultureLogical. Apply the which() function like this to identify the rows of the data frame 
#where the logical vector is TRUE. which(agricultureLogical) What are the first 3 values that result?

#Question 1
fileUrlQ1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv" 
download.file(fileUrlQ1,"../../Data/w3Q1.csv", method = "curl")
w3Q1 <- read.csv("../../Data/w3Q1.csv", header=TRUE)
head(w3Q1)
str(w3Q1)
agricultureLogical <- w3Q1[which(w3Q1$AGS ==6 & w3Q1$ACR == 3),]

agricultureLogical[1:3]


#Question 2
install.packages("jpeg")
library(jpeg)
??jpeg
fileUrlQ2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg" 
download.file(fileUrlQ2,"../../Data/w3Q2.jpg", method="curl")
w3Q2 <- readJPEG("../../Data/w3Q2.jpg", native =TRUE)
head(w3Q2)
str(w3Q2)

quantile(w3Q2, probs = c(.30,.80))

#Question 4
fileUrlQ3a <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv" 
fileUrlQ3b <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"

download.file(fileUrlQ3a,"../../Data/gdp.csv", method="curl")
download.file(fileUrlQ3b,"../../Data/edu.csv", method="curl")

GDP <- read.csv("../../Data/gdp.csv",header = TRUE,skip = 4, stringsAsFactors = FALSE)
EDU <- read.csv("../../Data/edu.csv",header = TRUE)


#GDP <- GDP[1:190,]
GDP <- select(GDP, c(1:2,4:5) )
colnames(GDP) <- c("shortcode","rank","countryNames","gdpMM")
GDP$rank <- as.numeric(GDP$rank)
GDP$gdpMM <-as.numeric(GDP$gdpMM)
class(GDP$gdpMM)
class(GDP$rank)

mergedData <- merge(GDP, EDU, by.x = "shortcode", by.y = "CountryCode", all=TRUE)

GDP2 <- mergedData %>%
  filter(rank <=190) %>%
  arrange(desc(rank))
head(mergedData)

filter(GDP, shortcode == "KNA")

GDP2 [13,1:3]

head(GDP)

x <- c(1, 1, 2, 2, 2)
row_number(x = x)
?row_number


#ordering by a variable: 
merged3<- mergedData[order(mergedData$rank,decreasing = TRUE),]
head(merged3)
merged2[,1:3]
merged2[13,1:5]
merged2[190,1:5]
merged2

#4
#What is the average GDP ranking for the "High income: OECD" and "High income: nonOECD" group?

mergedData %.%
  group_by(Income.Group)%.%
  summarise(meanRank = mean(rank, na.rm = TRUE))

names(mergedData)

#5
#Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. 
#How many countries are Lower middle income but among the 38 nations with highest GDP?

restData$zipGroups = cut(restData$zipCode,breaks=quantile(restData$zipCode))
GDP2$gdpQuartile <- cut(GDP2$rank, breaks=quantile(GDP2$rank,probs = seq(0,1,0.2),na.rm = TRUE))
summary(GDP2$gdpQuartile)
table(GDP2$gdpQuartile,GDP2$Income.Group)

table(merged2$gdpQuartile,merged2$Income.Group)
merged2$gdpQuartile2 <- cut2(merged2$rank, g=5)
merged2$gdpQuartile2

restData$zipGroups = cut2(restData$zipCode,g=4)
table(restData$zipGroups)

summary(gdpRankings)

restData$zipGroups = cut2(restData$zipCode,g=5)
table(restData$zipGroups)

hflights_df %>%
  group_by(Dest) %>%
  select(Cancelled) %>%
  table() %>%
  head()