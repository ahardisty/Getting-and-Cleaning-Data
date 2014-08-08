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

#Ordering
X[order(X$var1),3]


library(Hmisc)
yesno <- sample(c(“yes”,”no”), size=10, replace=TRUE)
yesno <- sample(c("yes","no"), size=10, replace=TRUE)
yesnofac <- factor(yesno, levels = c("yes", "no"))
relevel(yesnofac, ref = "yes")
?relevel


# Melting data frames
library(reshape2)
data(mtcars)
mtcars$carname <- rownames(mtcars) #create variable name from row names
carMelt <- melt(mtcars, id = c("carname","gear", "cyl"),measure.vars=c("mpg","hp")) #indicate which variables are ID variables; which are measure variables
carMelt
head(carMelt, n=3) #there is now a row for each car mpg and hp
tail(carMelt, n = 3)

# Casting data frames
cylData <- dcast(carMelt, cyl ~ variable)
cylData
carMelt

cylData <- dcast(carMelt, cyl ~ variable, mean) #recast by mean
cylData
carMelt


summary(carMelt$cyl)
carMelt$cyl
table(carMelt$cyl)

#averaging values within a factor
head(InsectSprays)
tapply(InsectSprays$count, InsectSprays$spray, sum)

#split values
spIns <- split(InsectSprays$count, InsectSprays$spray)
spIns

#unlist and sapply
unlist(spCount)

#sapply
sapply(spIns,sum)

library(dplyr)
?ddply
??dplyr

#plyr package
ddply(InsectSprays,.(spray),summarize,sum=sum(count))


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
if(!file.exists("./data")){dir.create("./data")}
fileUrl1 = "https://dl.dropboxusercontent.com/u/7710864/data/reviews-apr29.csv"
fileUrl2 = "https://dl.dropboxusercontent.com/u/7710864/data/solutions-apr29.csv"
download.file(fileUrl1,destfile="./data/reviews.csv",method="curl")
download.file(fileUrl2,destfile="./data/solutions.csv",method="curl")
reviews = read.csv("./data/reviews.csv"); solutions <- read.csv("./data/solutions.csv")
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
