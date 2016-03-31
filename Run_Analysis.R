## STEP 1 : CREATE ONE DATASET ##
# First step: Download the Zip File
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)

# Create tables in R from unzipping the different tables in the directory
# Test Tables
ytest <- read.table(unzip(temp, "UCI HAR Dataset/test/y_test.txt"))
xtest <- read.table(unzip(temp, "UCI HAR Dataset/test/X_test.txt"))
subject_test <- read.table(unzip(temp, "UCI HAR Dataset/test/subject_test.txt"))
# Train Tables
ytrain <- read.table(unzip(temp, "UCI HAR Dataset/train/y_train.txt"))
xtrain <- read.table(unzip(temp, "UCI HAR Dataset/train/X_train.txt"))
subject_train <- read.table(unzip(temp, "UCI HAR Dataset/train/subject_train.txt"))
# Feature Table with all the column names
features <- read.table(unzip(temp, "UCI HAR Dataset/features.txt"))

unlink(temp)

## STEP 4 done within STEP 1: Appropriately labels the data set with descriptive variable names ##

# Assigment of column names to the main datasets X, to replace V2,3,etc. by descriptive names
names(xtest)<-t(features$V2)
names(xtrain)<-t(features$V2)
# Assigment of column names to the datasets Y to describe activities and subjects
names(ytest)[1] <- "activity"
names(ytrain)[1] <- "activity"
names(subject_test)[1] <- "subject"
names(subject_train)[1] <- "subject"


# Combination of the different tables by columns
sample_test<-cbind(subject_test,ytest,xtest)
sample_train<-cbind(subject_train,ytrain,xtrain)

# Combination of test and training samples by rows
sample<-rbind(sample_test,sample_train)

## STEP 1 and 4 Completed! One dataset has been created with descriptive variable names


## STEP 2 : Extract only Mean and STDev for each measurement ##

# Grep names containing mean and std > getting columns numbers
mean_sample<-grep("mean",names(sample))
std_sample<-grep("std",names(sample))

# Creating datasets with those columns
mean_sample_table<-sample[mean_sample]
std_sample_table<-sample[std_sample]

# Combining those 2 datasets and adding back subject and activity columns
combined<-cbind(mean_sample_table,std_sample_table)
combined_total<-cbind(sample[1:2],combined)

## STEP 2 completed! combined_total is a dataset with only mean and std measurements

##STEP 3: Uses descriptive activity names to name the activities in the data set ##

combined_total$activity<-as.character(combined_total$activity)
combined_total$activity[combined_total$activity==1]<-"WALKING"
combined_total$activity[combined_total$activity==2]<-"WALKING_UPSTAIRS"
combined_total$activity[combined_total$activity==3]<-"WALKING_DOWNSTAIRS"
combined_total$activity[combined_total$activity==4]<-"SITTING"
combined_total$activity[combined_total$activity==5]<-"STANDING"
combined_total$activity[combined_total$activity==6]<-"LAYING"

## STEP 3 and 4 Completed! The dataset has descriptive activity names to name the activities and labels are set with descriptive variable names.


## STEP 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. ## 

# Calling dplyr for manipulation purposes
library(dplyr)
combined_total_df<-tbl_df(combined_total)
# Group by subject and activity to calculate the average of each variable
TidyData <- group_by(combined_total ,subject,activity)
# Summarise to calculate the mean
dataset_final<-summarise_each(TidyData,funs(mean))

## STEP 5 completed! dataset_final gives average by participant and activity

# Write table into a txt file
write.table(dataset_final,file="tidy.txt",row.name=FALSE)
