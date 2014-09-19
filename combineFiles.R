#Combine delimited files
#http://www.rforexcelusers.com/combine-delimited-files-r/
#https://github.com/nvenkataraman1/rforexcelusers/blob/master/Names%20data%20analysis/2_dplyr_name_trends.R

#find files
file_names <- list.files("../../Data/namesbystate")
file_names

fileNames <- file_names[grepl(".TXT",file_names)]
fileNames

fileRead <- read.csv("../../Data/namesbystate/WY.txt", header=FALSE, stringsAsFactors=F)
head(fileRead)
str(fileRead)


setwd("../../Data/namesbystate/")
files = lapply(fileNames, read.csv, header=F, stringsAsFactors = F)
files = do.call(rbind,files)
head(files)
summary(files)
str(files)
names(files) = c("state", "gender", "year", "name", "count")

#naming trends
#Step 1: summarize the data
install.packages("googleVis")
library(dplyr)
library(googleVis)
library(reshape2)

names_count = group_by(files, year, gender)

names_count = summarise(names_count, unique_names = n_distinct(name),
                        names_per_1M = unique_names / (sum(count) / 1000000))

uniqe_names_count = dcast(names_count, year ~ gender, value.var="unique_names")
names_per_1M = dcast(names_count, year ~ gender, value.var="names_per_1M")

uniq_names_count
summary(names_per_1M)
str(names_per_1M)

plot(gvisLineChart(names_per_1M, xvar="year", yvar=c("F","M"),
                   options=list(title="Number of Names Per Million Births",
                                hAxis="{title: 'Year'}",
                                vAxis="{title: '# of Names'}")))



#dplyr Example #1
#http://fishr.wordpress.com/2014/04/17/dplyr-example-1/

library(FSAdata)
data(RuffeSLRH92)
install.packages("plotrix")
library(plotrix)
data(RuffeSLRH92)
library(dplyr)


btoData
male <- filter(RuffeSLRH92,sex=="male")
xtabs(~sex,data=male)