#Five basic verbs: filter, select, arrange, mutate, summarise (plus group_by)

data.frame(ToothGrowth)
head(ToothGrowth)
dim(ToothGrowth)

toothOne <- ToothGrowth %.%
  group_by(supp) %.%
  summarize(meanLen = mean(len))
toothOne

#What about mean teeth length by delivery method and dose level? No problem. Just add dose to the group_by function:
toothTwo <- ToothGrowth %.%
  group_by(supp, dose) %.%
  summarize(meanLen = mean(len))
dim(toothTwo)

#filter out the rows with dose level equal to 0.5, 
#then select only the len and supp columns, and 
#then finally sort ascending by len.

toothFive <- ToothGrowth %.%
  filter(dose==0.5) %.% #filter
  select(len, supp) %.% #select
  arrange(len) #arrange ascending
toothFive

toothFiveB <- ToothGrowth %.%
  filter(dose==0.5) %.% #filter
  arrange(len) #arrange ascending
toothFiveB

#first filter out the rows with dose level equal to 0.5, 
#then select only the len and supp columns,
#sorting in descending order (notice the desc function, included with dplyr) 
#and using the head function to get the top 5 tooth lengths.
toothSix <- ToothGrowth %.%
  filter(dose==0.5) %.%
  select(len, supp) %.%
  arrange(desc(len)) %.%
  head(n=5)

#dplyr with Houston flights data
#http://rstudio-pubs-static.s3.amazonaws.com/11068_8bc42d6df61341b2bed45e9a9a3bf9f4.html
library(hflights)
data(hflights)
summary(hflights)

#create a wrapper for a large data frame
#this is a wrapper around a data frame that won't accidentally print a lot of data to the screen.
hflights_df <- tbl_df(hflights)
dim(hflights_df)

##basic dplyr verbs
#Filter rows with filter()
#For example, we can select all flights on January 1st with:
filter(hflights_df, Month == 1, DayofMonth == 1)

# you can also use %in% operator
filter(hflights_df, UniqueCarrier %in% c("AA", "UA"))
# use colon to select multiple contiguous columns, and use `contains` to match columns by name
# note: `starts_with`, `ends_with`, and `matches` (for regular expressions) can also be used to match columns by name
select(hflights_df, Year:DayofMonth, contains("Taxi"), contains("Delay"))

# nesting method to select UniqueCarrier and DepDelay columns and filter for delays over 60 minutes
dim (hflights_df %.%
  select(UniqueCarrier, DepDelay) %.%
  filter(DepDelay > 60))

names(hflights_df)

#Arrange rows with arrange()
arrange(hflights_df, DayofMonth, Month, Year)
arrange(hflights_df, desc(ArrDelay))
names(hflights_df)

hflights_df %.%
  select(UniqueCarrier, DepDelay) %.%
  arrange(DepDelay)

hflights_df %.%
  select(UniqueCarrier, DepDelay) %.%
  arrange(DepDelay)

#Select columns with select()
select(hflights_df, Year, Month, DayOfWeek)

# Select all columns between Year and DayOfWeek (inclusive)
select(hflights_df, Year:DayOfWeek)
select(hflights_df, 1:4)

# Select all columns except Year and DayOfWeek
select(hflights_df, -(Year:DayOfWeek))
select(hflights_df, -(1:6))

hflights_df %.%
  select(UniqueCarrier, DepDelay) %.%
  filter(DepDelay > 60)

hflights_df %.%
  select(UniqueCarrier, DepDelay) %.%
  arrange(desc(DepDelay))

hflights_df %>%
  select(UniqueCarrier, DepDelay) %>%
  arrange(desc(DepDelay))

#Add new columns with mutate()
#Create new variables that are functions of existing variables
# dplyr approach (prints the new variable but does not store it)
hflights_df %.%
  select(Distance, AirTime) %.% #select only Distance and AirTime columns
  mutate(Speed = Distance/AirTime*60) #create new variable called Speed

# store the new variable
flights <- hflights_df %.% mutate(Speed = Distance/AirTime*60)
names(flights)
summary(flights)
head(flights)
names(hflights_df)

hflights_df <- subset(hflights_df, select = -Gain) #remove the Gain variable



##Summarize##
# Primarily useful with data that has been grouped by one or more variables
# group_by creates the groups that will be operated on
# summarise uses the provided aggregation function to summarise each group
# dplyr approach: create a table grouped by Dest, and then summarise each group by taking the mean of ArrDelay

hflights_df %>%
  group_by(Dest) %>% #group by Destination
  summarise(avg_delay = mean(ArrDelay, na.rm=TRUE)) #summarise by mean arrival delay; assign to avg_delay

#result is average delay for each destination

##summarise_each
#summarise_each allows you to apply the same summary function to multiple columns at once
#Note: mutate_each is also available

# for each carrier, calculate the percentage of flights cancelled or diverted
hflights_df %.%
  group_by(UniqueCarrier) %.%
  summarise_each(funs(mean), Cancelled, Diverted)

# for each carrier, calculate the minimum and maximum arrival and departure delays
hflights_df %.%
  group_by(UniqueCarrier) %.%
  summarise_each(funs(min(., na.rm=TRUE), max(., na.rm=TRUE)), matches("Delay")) #match any column with the word delay in it

# for each day of the year, count the total number of flights and sort in descending order
hflights_df %>%
  group_by(Month, DayofMonth) %>%
  summarise(flight_count = n()) %>% #define column name for summarise
  arrange(desc(flight_count))

# rewrite more simply with the `tally` function
#replace n() function with tally() function
flights %>%
  group_by(Month, DayofMonth) %>%
  tally(sort = TRUE)

# for each destination, count the total number of flights and the number of distinct planes that flew there
flights %>%
  group_by(Dest) %>%
  summarise(flight_count = n(), plane_count = n_distinct(TailNum))

# for each destination, show the number of cancelled and not cancelled flights
flights %>%
  group_by(Dest) %>%
  select(Cancelled) %>%
  table() %>%
  head()

##Window Functions vs aggregation functions
#Aggregation function (like mean) takes n inputs and returns 1 value
#Window function takes n inputs and returns n values
#Includes ranking and ordering functions (like min_rank), 
#offset functions (lead and lag), and cumulative aggregates (like cummean).

# for each carrier, calculate which two days of the year they had their longest departure delays
# note: smallest (not largest) value is ranked as 1, so you have to use `desc` to rank by largest value
?min_rank

#min_rank
flights %>%
  group_by(UniqueCarrier) %>% #group on carrier
  select(Month, DayofMonth, DepDelay) %>% #select only three columns to show
  filter(min_rank(desc(DepDelay)) <= 2) %>% #getting departure delays, ranking them, getting first two 
  arrange(UniqueCarrier, desc(DepDelay))

#top_n()
# rewrite more simply with the `top_n` function
flights %>%
  group_by(UniqueCarrier) %>%
  select(Month, DayofMonth, DepDelay) %>%
  top_n(2) %>%
  arrange(UniqueCarrier, desc(DepDelay))

#lag()
flights %>%
  group_by(Month) %>%
  summarise(flight_count = n()) %>%
  mutate(change = flight_count - lag(flight_count))

# rewrite more simply with the `tally` function
flights %>%
  group_by(Month) %>%
  tally() %>%
  mutate(change = n - lag(n))

#sample_n
# randomly sample a fixed number of rows, without replacement
flights %>% sample_n(5)
flights %>% sample_frac(0.25, replace=TRUE)

#glimpse
# dplyr approach: better formatting, and adapts to your screen width
glimpse(flights)

#Connecting to Databases
#dplyr can connect to a database as if the data was loaded into a data frame
#Use the same syntax for local data frames and databases
#Only generates SELECT statements
#Currently supports SQLite, PostgreSQL/Redshift, MySQL/MariaDB, BigQuery, MonetDB
#Example below is based upon an SQLite database containing the hflights data
#Instructions for creating this database are in the databases vignette
# connect to an SQLite database containing the hflights data
my_db <- src_sqlite("my_db.sqlite3")
install.packages("RSQLite")
library(RSQLite)

flights_tbl <- tbl(my_db, "hflights")
flights_tbl %>%
  select(UniqueCarrier, DepDelay) %>%
  arrange(desc(DepDelay))

library(Lahman)
batting_tbl <- tbl_df(Batting)
tally(group_by(batting_tbl, yearID))
tally(group_by(batting_tbl, yearID), sort = TRUE)

##helper functions
#Helper function n() counts the number of rows in a group
#Helper function n_distinct(vector) counts the number of unique items in that vector

#The first argument is a data frame.
#The subsequent arguments describe what to do with it, and you can refer to columns in the data frame directly without using $.
#The result is a new data frame
#we split the complete dataset into individual planes 
#and then summarise each plane by counting the number of flights (count = n()) 
#and computing the average distance (dist = mean(Distance, na.rm = TRUE)) and delay (delay = mean(ArrDelay, na.rm = TRUE)). We then use ggplot2 to display the output.

planes <- group_by(hflights_df, TailNum)
filter(hflights_df, TailNum == "N576AA")
planes <- select(planes, 7:13)
delay <- summarise(planes, 
                   count = n(), 
                   dist = mean(Distance, na.rm = TRUE), 
                   delay = mean(ArrDelay, na.rm = TRUE))

delay2 <- hflights_df %.%
  group_by(TailNum) %.%
  filter(ArrDelay != "NA")%.%
  summarise(dist = mean(Distance, na.rm = TRUE),
            delay = mean(ArrDelay, na.rm = TRUE))

# Interestingly, the average delay is only slightly related to the
# average distance flown a plane.

ggplot(delay2, aes(dist, delay)) + 
  geom_point(aes(size = count), alpha = 1/2) + 
  geom_smooth() + 
  scale_y_continuous(limits=c(yLimMin,yLimMax)) +
  scale_size_area()

yLimMin <- quantile(delay2$delay,.05)
yLimMax <- quantile(delay2$delay,.95)

#find the number of planes and the number of flights that go to each possible destination:
destinations <- group_by(hflights_df, Dest)
summarise(destinations,
          planes = count_distinct(TailNum),
          flights = n())    

destinations <- summarize(destinations,
          planes = n(),
          flights = n())
destinations <- group_by(hflights_df, Dest)
summarise(destinations,
          planes = sum(TailNum),
          flights = n())
head(destinations)
summarise(destinations,
          planes = count_distinct(TailNum),
          flights = n()  
)

http://pastebin.com/HYuauh7z

destinations <- group_by(hflights_df, Dest)
dest <- summarise(destinations,
          planes = n_distinct(TailNum),
          flights = n())

dest
str(dest)

#dplyr lecture https://www.youtube.com/watch?v=jWjqLW-u3hc&feature=youtu.be
#dplyr documentation http://rpubs.com/justmarkham/dplyr-tutorial
#hadley tutorial: https://www.dropbox.com/sh/i8qnluwmuieicxc/AAAgt9tIKoIm7WZKIyK25lh6a



