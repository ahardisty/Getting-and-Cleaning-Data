#getting and cleaning data week 4
names(cameraData)
fileUrl1 <- "https://dl.dropboxusercontent.com/u/7710864/data/reviews-apr29.csv"
fileUrl2 <- "https://dl.dropboxusercontent.com/u/7710864/data/solutions-apr29.csv"
download.file(fileUrl1,destfile="../../Data/reviews.csv",method="curl")
download.file(fileUrl2,destfile="../../Data/solutions.csv",method="curl")
reviews <- read.csv("../../Data/reviews.csv"); solutions <- read.csv("../../Data/solutions.csv")

#tolower
tolower(names(cameraData))

head(reviews,2)
head(solutions,2)
getwd()

#strsplit()
splitNames <- strsplit(names(cameraData),"\\.") #string split on the names of cameraData data frame
splitNames
str(cameraData)
cameraData[1,5:6]
(cameraData[1,1:4])
splitNames[[5]]
splitNames[[6]]

#list
mylist <- list(letters = c("A", "b", "c"), numbers = 1:3, matrix(1:25, ncol = 5,byrow = TRUE))
head(mylist)
mylist$letters
mylist[1]
mylist[[1]]

#fixing character vectors - sapply
splitNames[[6]][1]
firstElement <- function(x){x[1]} #x and the first element of x
sapply(splitNames,firstElement)

#Fixing character vectors - sub()
#Important parameters: pattern, replacement, x
names(reviews)
sub(pattern = "_",replacement = "",x = names(reviews))

#Fixing character vectors - gsub()
#gsub()
testName <- "this_is_a_test"
sub("_","",testName)
gsub(pattern = "_","",testName)
install.packages("rapport")
library(rapport)
tocamel(x = testName)
tocamel(names(x = reviews))
?tocamel
??rapport
str(testName)

#grep
grep("Alameda", cameraData$intersection) #find all instances of the variable.
?grep

letters
grep("[a-z]", letters)
grep("[a:z]", letters)
grep("[a-c, l-z]", letters)


#grepl()
#return the vector where variable is true and false
cameraData$intersection
table(grepl("Alameda", cameraData$intersection)) #table of true and falce vectors
table(!grepl("Alameda", cameraData$intersection)) #table of true and falce vectors
!grepl("Alameda",cameraData$intersection) #not including Alameda
grepl("Alameda",cameraData$intersection) #including Alameda
dim(select(cameraData,grepl("Alameda",cameraData$intersection),address,direction))
grep("Alameda",cameraData$intersection,value=TRUE)


cameraData3 <- cameraData[!grepl("Alameda",cameraData$intersection),]
cameraData2 <- cameraData[grepl("Alameda",cameraData$intersection),]
cameraData[grepl("Alameda",cameraData$intersection),] #including Alameda
select(cameraData2, 1:3)
select(cameraData3, 1:3)


##working with dates
d1 <- date()
class(d1)
d2 <- Sys.Date()
class(d2)

#reformat dates
d2
format(d2,"%A %B %d %y")

x = c("1jan1960", "2jan1960", "31mar1960", "30jul1960")
x
class(x)
z = as.Date(x, "%d%b%Y")
z
class(z)
z[1] - z[2]

as.numeric(z[1]-z[2])

weekdays(d2)
months(d2)
julian(d2)

#lubridate
class(yearMDate)
yearMDate
ymd("20140108") #will look for year, month, date in any format; changes any string to match Lubridate format
mdy("08/04/2013") #look for month, day, year; presents in Lubridate format
mdy("08042013")
dmy("03042013")

#times
ymd_hms("2011-08-03 10:15:03")
ymd_hms("2011-08-03 10:15:03",tz="Pacific/Auckland")
ymd_hms("2011-08-03 10:15:03",tz="America/Los_Angeles")
?Sys.timezone


##Week 4 Quiz
#Question 1
Q1ACS <- read.csv("../../Data/ACS.csv")
names(Q1ACS)
head(Q1ACS)
#Apply strsplit() to split all the names of the data frame on the characters "wgtp". 
#What is the value of the 123 element of the resulting list?

splitNames = strsplit(names(cameraData),"\\.")
splitNames
Q1split <- strsplit(names(Q1ACS),"wgtp")

#Question 2
#Remove the commas from the GDP numbers in millions of dollars and average them. What is the average? 
GDP <- filter(GDP,rank ==c(1:190))
GDP$gdpMM <-gsub(",","",GDP$gdpMM)
GDP$gdpMM <- as.numeric(GDP$gdpMM)
class(GDP$gdpMM)
mean(GDP$gdpMM)
summary(GDP$gdpMM)

#Question 3
#In the data set from Question 2 what is a regular expression that 
#would allow you to count the number of countries whose name begins with "United"? 

df<- as.matrix(grep("^United",GDP$countryNames))
df<- as.matrix(grep("^United",GDP$countryNames))
dim(df)
class(df)
grep("Alameda", cameraData$intersection, value = TRUE)
str((grep("Alameda", cameraData$intersection)))

str(cameraData)
cameraData[1,1:6]


#Question 4
#Load the Gross Domestic Product data for the 190 ranked countries in this data set: 
#Match the data based on the country shortcode. Of the countries for which the end of the fiscal year is available, how many end in June? 
?grep

str(names(merged2))
names(merged2) <- tocamel(names(x = merged2),upper = FALSE)
summary(merged2)
str(merged2)
?is.factor
names(merged2)
merged4 <- subset(merged2, select = -c(6:12))
str(merged4)

grep("Unit", names(merged2),value = TRUE)
grep("Unit", names(merged2))
grepl("Unit", names(merged2))

merged4c <- merged4[grep("[Ff]iscal+ (.*)[Jj]une+",merged4$SpecialNotes),] #subset on grep in special notes column
grep("[Ff]iscal+ (.*)[Jj]une+",merged4$SpecialNotes, value= TRUE)
grep("[Ff]iscal+ (.*)[Jj]une+",merged4$SpecialNotes)

#Question 5
install.packages("quantmod")
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn) 
?quantmod

#How many values were collected in 2012? 
#How many values were collected on Mondays in 2012?
amzn['2012'] #select 2012 from amzn
amzn2012<- amzn['2012'] #subset 2012 from amzn
amznMond<- amzn2012[wday(amzn2012)==2] #subset Monday FROM 2012
amzn5 <- amzn['2012'] & amzn[wday(amzn)==2] #Subset 2012 and Monday
dim(amzn2012)
dim(amzn['2012'])
dim(amznMond)
dim(amzn5)


x = dmy(c("2jan2013","31mar2013","1jan2013", "2jan2013", "30jul2014","30jul2013","9jan2013","16jan2013"))
x
wday(x,label=TRUE)
wday(x)
wday(x[1], label = TRUE)
wday(x, label = TRUE,abbr = TRUE)
months(x, abbreviate = TRUE)
str(amzn)
names(amzn)
head(amzn)
group_by(x = )
format()
amznDF <- data.frame(amzn)
melt(amzn,)
names(amznDF)
?melt
df_xts <- as.xts(as.data.frame(sample_matrix),
                 important = 'very important info!')
str(df_xts)
str(xts(1:10, Sys.Date()+1:10))
matrix_xts['Monday']
index()
dim(matrix_xts['/2007-01-07'])
first(matrix_xts,'1 week') #Here is the first 1 week of the data
first(last(matrix_xts,'1 week'),'3 days') #and here is the first 3 days of the last week of the data.
indexClass(matrix_xts)
indexClass(convertIndex(matrix_xts,'POSIXct'))
axTicksByTime(matrix_xts, ticks.on='months')
plot(matrix_xts[,1],major.ticks='months',minor.ticks=FALSE,main=NULL,col=3)
