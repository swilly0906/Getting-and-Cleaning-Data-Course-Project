library(dplyr)   

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
feature <- read.table("./UCI HAR Dataset/features.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

x_train_cbind <- cbind(subject_train ,y_train, x_train)  
y_test_cbind <- cbind(subject_test, y_test, x_test)
x_y_test_train <- rbind(x_train_cbind, y_test_cbind)
names(x_y_test_train)[1:2] <- c("ID", "activity")

table(grepl("mean[()]",feature$V2))
table(grepl("std[()]",feature$V2))

all_prop_var <- sapply(x_y_test_train,mean)[sapply(x_y_test_train,mean)>0]
all_prop_var[order(rank(all_prop_var), decreasing = TRUE)]

select_mean <- names(all_prop_var[order(rank(all_prop_var), decreasing = TRUE)][3:35])
select_mean #These variables as the mean

select_std <- names(all_prop_var[order(rank(all_prop_var), decreasing = TRUE)][36:68])
select_std

filter_x_y <- x_y_test_train[,c("ID", "activity", select_mean, select_std)]

look.up.vect <- c("WALKING"=1, "WALKING_UPSTAIRS"=2, "WALKING_DOWNSTAIRS"=3,
                  "SITTING"=4, "STANDING"=5, "LAYING"=6)
filter_x_y$activity <- names(look.up.vect[filter_x_y$activity])

feature$V2 <- as.character(feature$V2)
names(filter_x_y)[3:35] <- feature[grepl("mean[()]",feature$V2),2]
names(filter_x_y)[36:68] <- feature[grepl("std[()]",feature$V2),2]

names(filter_x_y)<- gsub("-", ".", names(filter_x_y))
names(filter_x_y)<- gsub("\\()", "", names(filter_x_y)) 

test_positive <- function(vars){all(vars>0)}
table(sapply(x_y_test_train,test_positive))

tidydata <- filter_x_y %>% group_by(ID, activity) %>% summarise_all(mean)
tidydata <- as.data.frame(tidydata)

write.table(tidydata,file = "./UCI HAR Dataset/tidytable.txt", row.names = FALSE)
