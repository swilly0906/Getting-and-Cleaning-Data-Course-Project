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
I have to combine x test/train and y test/train data. And, I rename first/second column is ID/activity
     
     x_train_cbind <- cbind(subject_train ,y_train, x_train)  
     y_test_cbind <- cbind(subject_test, y_test, x_test)
     x_y_test_train <- rbind(x_train_cbind, y_test_cbind)
     names(x_y_test_train)[1:2] <- c("ID", "activity")

<h1 id=step2>Step2</h1>

First, I find the value in this table(x_y_test_train) is very small universally, so I think 
mean value is usually a little bigger (because value near zero probably standard deviation).<br>
Second, I use below command to search/check what number of mean/standard deviation.

     table(grepl("mean[()]",feature$V2))
     table(grepl("std[()]",feature$V2))
I find in this object feature that the number of mean is 33 as same as std.
In order to search bigger value as mean value , so I calculated all variables mean.

     all_prop_var <- sapply(x_y_test_train,mean)[sapply(x_y_test_train,mean)>0]
     all_prop_var[order(rank(all_prop_var), decreasing = TRUE)]
     
In this all_prop_var output, I want to grab the variable whose rank is 3rd to 35th (from big to small).
That is, I choose V174,V175...V552,109,V29 by using select_mean.

     select_mean <- names(all_prop_var[order(rank(all_prop_var), decreasing = TRUE)][3:35])
     select_mean #These variables as the mean
The rank 1st(ID) and 2nd(activity) is not my scope of selection.Next, I want to select the appropriate variables as a standard deviation.I directly use a convient method to select std as same as selecting mean.That is, I choose the variable whose rank is 36th to 68th in all_prop_var output.

     select_std <- names(all_prop_var[order(rank(all_prop_var), decreasing = TRUE)][36:68])
     select_std
I think this idea is reliable.Because mean value is larger than std value in normal situation.
At last, I select the ideal variable in the table x_y_test_train and R code is listed below.

     filter_x_y <- x_y_test_train[,c("ID", "activity", select_mean, select_std)]

<h1 id=step3>Step3</h1>

I substitute the suitable activity name for the original elements of variable activity.

     look.up.vect <- c("WALKING"=1, "WALKING_UPSTAIRS"=2, "WALKING_DOWNSTAIRS"=3,
                       "SITTING"=4, "STANDING"=5, "LAYING"=6)
     filter_x_y$activity <- names(look.up.vect[filter_x_y$activity])

<h1 id=step4>Step4</h1>
I made variable V2 in the feature become character.

     feature$V2 <- as.character(feature$V2)
     names(filter_x_y)[3:35] <- feature[grepl("mean[()]",feature$V2),2]
     names(filter_x_y)[36:68] <- feature[grepl("std[()]",feature$V2),2]
I want to adjust some name of column to avoid especially character.

     names(filter_x_y)<- gsub("-", ".", names(filter_x_y))
     names(filter_x_y)<- gsub("\\()", "", names(filter_x_y)) 
Suddenly, I simply find some std include negative value.However,I know this negative value is not match std's definition(non-negative value);so, I decide to change some elements of std variable.First, I search the variable(not inclue mean variable column) include all non-negative value.

     test_positive <- function(vars){all(vars>0)}
     table(sapply(x_y_test_train,test_positive))
I find the terrible fact that all variable(exclude ID&activity) have negative numeric. I decide that I keep all variable in the filter_x_y. I just feel this data is a little strange since I found all variable(exclude ID&activity) have negative numeric.
To sum up,I don't want to change anything.
P.S. I Appropriately label the data set in Codebook.md .

<h1 id=step5>Step5</h1>
I calculate mean for each column to reduce dimension.And, I make a new table tidytable.

     tidydata <- filter_x_y %>% group_by(ID, activity) %>% summarise_all(mean)
     tidydata <- as.data.frame(tidydata)
At the same time, I make the data(file) for this assignment.

     write.table(tidydata,file = "./UCI HAR Dataset/tidytable.txt")