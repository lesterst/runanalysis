
## First portion reads the 6 data sets and the 2 supporting tables into R

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
feature_names <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

## load the dplyr package
library(dplyr)

## rename some columns so they are not duplicated
Y_test_rename <- rename(Y_test, Ycolumn = V1)
Y_train_rename <- rename(Y_train, Ycolumn = V1)
subject_test_rename <- rename(subject_test, subjectcolumn = V1)
subject_train_rename <- rename(subject_train, subjectcolumn = V1)

## convert to more user friendly names from the features table,
## and use the check.names parameter from the data.frame function
## to make them R friendly
names(X_test) <- feature_names[["V2"]]
names(X_train) <- feature_names[["V2"]]
X_test_rename <- data.frame(X_test, check.names=TRUE)
X_train_rename <- data.frame(X_train, check.names=TRUE)

## column bind the subject, activey and main data tables together for 
## both the test and training groups
combined_test <- cbind(subject_test_rename,Y_test_rename,X_test_rename)
combined_train <- cbind(subject_train_rename,Y_train_rename,X_train_rename)

## keep a record of which group they came from just in case
combined_test_withsource <- mutate(combined_test,sourcecol = "test")
combined_train_withsource <- mutate(combined_train,sourcecol = "train")

## rowbind the test and training groups together
combined_all <- rbind(combined_test_withsource,combined_train_withsource)

## select just the mean and std columns (plus the subject and activity)
combined_mean_or_std <- select(combined_all, subjectcolumn, Ycolumn, contains("std"), contains("mean"))

## make user friendly activity names
combo_with_activities <- merge(combined_mean_or_std,activity_labels, by.x = "Ycolumn", by.y = "V1")
combo_with_activities2 <- rename(combo_with_activities, activity = V2)

## group by subject (30) and activity (6) into 180 subgroups
grouped_combo <- group_by(combo_with_activities2,subjectcolumn,activity)

## use the summarise_each function to get the mean of each of the 180 subgroups
sumall <- summarise_each(grouped_combo, funs(mean))
