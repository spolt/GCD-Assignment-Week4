library(dplyr)

# set directory

setwd("UCI HAR Dataset")

# feature and activity

featureNames <- read.table("./features.txt")
activityLabels <- read.table("./activity_labels.txt", header = FALSE)

# read train data

x_train   <- read.table("./train/X_train.txt")
y_train   <- read.table("./train/Y_train.txt") 
sub_train <- read.table("./train/subject_train.txt")

# and test data

x_test   <- read.table("./test/X_test.txt")
y_test   <- read.table("./test/Y_test.txt") 
sub_test <- read.table("./test/subject_test.txt")

# merge the training and the test sets to create one data set

subject <- rbind(sub_train, sub_test)
activity <- rbind(y_train, y_test)
features <- rbind(x_train, x_test)

# naming the columns 

colnames(features) <- t(featureNames[2])

# Merge the data

colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
completeData <- cbind(features,activity,subject)

# keep only measurements for mean and standard deviation

columnsWithMeanSTD <- grep(".*Mean.*|.*Std.*", names(completeData), ignore.case=TRUE)
requiredColumns <- c(columnsWithMeanSTD, 562, 563)
dim(completeData)

extractedData <- completeData[,requiredColumns]
dim(extractedData)

# Uses descriptive activity names to name the activities in the data set
extractedData$Activity <- as.character(extractedData$Activity)
for (i in 1:6){
        extractedData$Activity[extractedData$Activity == i] <- as.character(activityLabels[i,2])
}

extractedData$Activity <- as.factor(extractedData$Activity)

# create a summary independent tidy dataset from final dataset 

extractedData$Subject <- as.factor(extractedData$Subject)
extractedData <- data.table(extractedData)

tidyData <- aggregate(. ~Subject + Activity, extractedData, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]

# write to Tidy.txt
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)

