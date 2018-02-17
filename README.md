# Getting-and-Cleaning-Data-Course-Project

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

* [Step1 : Merges the training and the test sets to create one data set.](#step1)
* [Step2 : Extracts only the measurements on the mean and standard deviation for each measurement.](#step2)
* [Step3 : Uses descriptive activity names to name the activities in the data set.](#step3)
* [Step4 : Appropriately labels the data set with descriptive variable names.](#step4)
* [Step5 : From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.](#step5)

Before first step, I have to laod my necessary Rpackage and all file

     library(dplyr)   
     
     activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
     feature <- read.table("./UCI HAR Dataset/features.txt")
     subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
     x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
     y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
     subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
     x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
     y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")


<h1 id=step1>Step1</h1>
I have to combine x test/train and y test/train data.And,I add two column `ID` and `activity`
     
     x_train_cbind <- cbind(subject_train ,y_train, x_train)  
     y_test_cbind <- cbind(subject_test, y_test, x_test)
     x_y_test_train <- rbind(x_train_cbind, y_test_cbind)
     names(x_y_test_train)[1:2] <- c("ID", "activity")



<h1 id=step2>Step2</h1>

<h1 id=step3>Step3</h1>

<h1 id=step4>Step4</h1>

<h1 id=step5>Step5</h1>