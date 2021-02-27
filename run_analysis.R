#download file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2F
UCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "hw4_data.zip")
unzip(zipfile = "hw4_data.zip")

#prepare label files
ACTLAB <- read.table("./UCI HAR Dataset/activity_labels.txt", 
                     col.names = c("activityLabels", "activityName"),
                     quote = "")
FEATURES <- read.table("./UCI HAR Dataset/features.txt", 
                       col.names = c("featureLabels", "featureName"),
                       quote = "")

#prepare test data
SUBTEST <- read.table("./UCI HAR Dataset/test/subject_test.txt", 
                      col.names = c("subjectId"))
XTEST <- read.table("./UCI HAR Dataset/test/x_test.txt")
YTEST <- read.table("./UCI HAR Dataset/test/y_test.txt")

#combine all test data and give column names 
colnames(XTEST) <- features$featureName
colnames(YTEST) <- c("activityLabels")
TESTDATA <- cbind(SUBTEST,XTEST, YTEST)

#prepare training data
SUBTRAIN <- read.table("./UCI HAR Dataset/train/subject_train.txt", 
                       col.names = c("subjectId"))
XTRAIN <- read.table("./UCI HAR Dataset/train/x_train.txt")
YTRAIN <- read.table("./UCI HAR Dataset/train/y_train.txt")

#combine all training data and give column names 
colnames(XTRAIN) <- features$featureName
colnames(YTRAIN) <- c("activityLabels")
TRAINDATA <- cbind(SUBTRAIN, XTRAIN, YTRAIN)

#combine all training data and give column names 
ALLDATA <- rbind(TRAINDATA, TESTDATA)

#extract the mean and standard deviation measurements
meanSDdata <- ALLDATA[, c(1, grep(pattern = "mean\\(\\)|std\\(\\)", 
                                  x = names(ALLDATA)), 563)]

#use descriptive activity names for the activities in the data set
meanSDdata$subjectId <- as.factor(meanSDdata$subjectId)
meanSDdata$activity <- factor(meanSDdata$activityLabels, 
                              levels = ACTLAB$activityLabels,
                              labels = ACTLAB$activityName)

meanSDdata <- meanSDdata[, -68] 
#remove the activity labels column to tidy up the data
names(meanSDdata)

#Label the data set with descriptive variable names
colnames(meanSdDdata) <- gsub(pattern = "\\(\\)", replacement = "", 
                             x = names(meanSDdata))
#remove the () for the mean and sd in measurements

meanSDdata <- meanSDdata[, c(1, 68, 2:67)]
#move the activity colun to the second column
write.table(meanSDdata, file = "tidyData.txt", row.names = F, quote = F, 
            sep = "\t")

#create a second data set with the average of each variable for each 
#activity and each subject
library(dplyr)
meanSDdataByIdAct <- group_by(meanSDdata, subjectId, activity) %>% 
  summarise_all(funs(mean))
write.table(meanSDdataByIdAct, file = "tidyDataMean.txt", row.names = F, 
            quote = F, sep = "\t")