#-----------------------------------------------------------------------------------------------
# Course Project
# Getting and Cleaning Data
# Brian D. Priddy
# June 22, 2014
#
# Per the project requirements, this R script does the following:
#   1). Merges training and test sets collected by Jorge L. Reyes-Ortiz, Davide Anguita, 
#       Alessandro Ghio, and Luca Oneto from Samsung smartphone accelerometers at the 
#       Non Linear Complex Systems Laboratory, Universita degli Studi di Genova, Italy
#   2). Extracts only the measurements on the mean and standard deviation for each measurement
#   3). Uses descriptive activity names to name the activities in the data set
#   4). Appropriately labels the data set with descriptive variable names
#   5). Creates a second, independent tidy data set with the average of each variable 
#       for each activity and each subject
#
# Information on this dataset is available at the following URL:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
#
# The raw dataset can be downloaded via the following URL:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
#-----------------------------------------------------------------------------------------------

# Set local working directory and local path to dataset files
# (These values are user dependent)
setwd("C:\\Users\\Brian\\Documents\\Coursera\\Getting and Cleaning Data\\")
datapath <- ".\\data\\UCI HAR Dataset\\"

# Load required libraries for script
library("Hmisc", lib.loc="~/R/win-library/3.0")
library("sqldf", lib.loc="~/R/win-library/3.0")

# Read data and merge corresponding training and testing datasets row-wise, where necessary
dfXData <- rbind(read.table(paste0(datapath, "train\\x_train.txt")), read.table(paste0(datapath, "test\\x_test.txt")))
dfYData <- rbind(read.table(paste0(datapath, "train\\y_train.txt")), read.table(paste0(datapath, "test\\y_test.txt")))
dfSubject <- rbind(read.table(paste0(datapath, "train\\subject_train.txt")), read.table(paste0(datapath, "test\\subject_test.txt")))
dfFeatures <- read.table(paste0(datapath, "features.txt"))
dfActivities <- read.table(paste0(datapath, "activity_labels.txt"))

# Extract only the mean and standard deviation data using Structured Query Language (SQL)
pertinentColumns <- sqldf("SELECT * FROM dfFeatures WHERE V2 LIKE '%std()%' or V2 LIKE '%mean()%'")
dfXDataStdMean <- dfXData[,pertinentColumns$V1]

# Tidy-up column names for the mean and standard deviation dataset
pertinentColumns$V2 <- gsub("-mean()-X", "XAxisMean", pertinentColumns$V2, fixed=TRUE)
pertinentColumns$V2 <- gsub("-mean()-Y", "YAxisMean", pertinentColumns$V2, fixed=TRUE)
pertinentColumns$V2 <- gsub("-mean()-Z", "ZAxisMean", pertinentColumns$V2, fixed=TRUE)
pertinentColumns$V2 <- gsub("-std()-X", "XAxisStdDev", pertinentColumns$V2, fixed=TRUE)
pertinentColumns$V2 <- gsub("-std()-Y", "YAxisStdDev", pertinentColumns$V2, fixed=TRUE)
pertinentColumns$V2 <- gsub("-std()-Z", "ZAxisStdDev", pertinentColumns$V2, fixed=TRUE)
pertinentColumns$V2 <- gsub("-mean()", "Mean", pertinentColumns$V2, fixed=TRUE)
pertinentColumns$V2 <- gsub("-std()", "StdDev", pertinentColumns$V2, fixed=TRUE)

# Tidy-up the activity descriptions and apply to dataset
ActivityDescriptions <- capitalize(tolower(dfActivities$V2))
ActivityDescriptions <- sub("_d", " D", ActivityDescriptions)
ActivityDescriptions <- sub("_u", " U", ActivityDescriptions)
vecActivities <- ActivityDescriptions[dfYData[,1]]
dfYData [,1] <- vecActivities

# Apply tidy column names to datasets
names(dfXDataStdMean) <- pertinentColumns$V2
names(dfYData) <- "Activity"
names(dfSubject) <- "Subject"

# Merge datasets column-wise and save the result to disk
dfFinalData <- cbind(dfSubject, dfYData, dfXDataStdMean) 
write.table(dfFinalData, ".\\data\\final_data.txt")

# Create SQL statement to extract the average of each variable,
# for each subject and activity
SQL <- "SELECT Subject, Activity"
SQLAggregates <- paste(paste0(", Avg(", pertinentColumns$V2, ")"), collapse = '')
SQLPredicate <- " FROM dfFinalData GROUP BY Subject, Activity ORDER BY Subject, Activity;"
SQL <- paste0(SQL, SQLAggregates, SQLPredicate)

# Execute SQL statement and write results to disk 
dfAveragedData <- sqldf(SQL)
write.table(dfAveragedData, ".\\data\\final_data_averages.txt")

