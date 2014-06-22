GettingAndCleaningData
======================
Repo created for Coursera's Getting and Cleaning Data course, June 2014

Course Project: Getting and Cleaning Data
-----------------------------------------
Brian D. Priddy
---------------
June 22, 2014
------------- 
Per the project requirements, this R script does the following:
 1. Merges training and test sets collected by Jorge L. Reyes-Ortiz, Davide Anguita, 
    Alessandro Ghio, and Luca Oneto from Samsung smartphone accelerometers at the 
    Non Linear Complex Systems Laboratory, Universita degli Studi di Genova, Italy
 2. Extracts only the measurements on the mean and standard deviation for each 
    measurement
 3. Uses descriptive activity names to name the activities in the data set
 4. Appropriately labels the data set with descriptive variable names
 5. Creates a second, independent tidy data set with the average of each variable 
    for each activity and each subject

Information on the original, raw dataset is available at the following URL:
 http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
 
The raw dataset can be downloaded via the following URL:
 https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
 
This R script assumes that the raw dataset archive (.zip file) has been extracted to the folder:
 (R working directory)/data/UCI HAR Dataset/
  
The following packages need to be installed on the client: 
1. sqldf (Performs SQL Selects on R Data Frames) 
2. Hmisc (Harrell Miscellaneous)

