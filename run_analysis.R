#import libraries that are suitable for large datasets 
library(data.table)

library(dplyr)

#Load supporting data into variables
featureNames <- read.table("C:\\Users\\577512\\Documents\\UCI HAR Dataset\\features.txt")
activityLabels <- read.table("C:\\Users\\577512\\Documents\\UCI HAR Dataset\\activity_labels.txt", header = FALSE)

#Read Training data
subjectTrain <- read.table("C:\\Users\\577512\\Documents\\UCI HAR Dataset\\train\\subject_train.txt", header = FALSE)
activityTrain <- read.table("C:\\Users\\577512\\Documents\\UCI HAR Dataset\\train\\y_train.txt", header = FALSE)
featuresTrain <- read.table("C:\\Users\\577512\\Documents\\UCI HAR Dataset\\train\\X_train.txt", header = FALSE)

#Read Test Data
subjectTest <- read.table("C:\\Users\\577512\\Documents\\UCI HAR Dataset\\test\\subject_test.txt", header = FALSE)
activityTest <- read.table("C:\\Users\\577512\\Documents\\UCI HAR Dataset\\test\\y_test.txt", header = FALSE)
featuresTest <- read.table("C:\\Users\\577512\\Documents\\UCI HAR Dataset\\test\\X_test.txt", header = FALSE)


#Merge the training and the test sets to create one data set
subject <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
features <- rbind(featuresTrain, featuresTest)

#Naming Columns 
colnames(features) <- t(featureNames[2])

#Merge the data
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
completeData <- cbind(features,activity,subject)

#Extracts only the measurements on the mean and standard deviation for each measurement
columnsWithMeanSTD <- grep(".*Mean.*|.*Std.*", names(completeData), ignore.case=TRUE)

requiredColumns <- c(columnsWithMeanSTD, 562, 563)
dim(completeData)

extractedData <- completeData[,requiredColumns]
dim(extractedData)

#Uses descriptive activity names to name the activities in the data set
extractedData$Activity <- as.character(extractedData$Activity)
for (i in 1:6){
extractedData$Activity[extractedData$Activity == i] <- as.character(activityLabels[i,2])
}

extractedData$Activity <- as.factor(extractedData$Activity)

#Cleaning format of names

names(extractedData)<-gsub("Acc", "Accelerometer", names(extractedData))
names(extractedData)<-gsub("Gyro", "Gyroscope", names(extractedData))
names(extractedData)<-gsub("BodyBody", "Body", names(extractedData))
names(extractedData)<-gsub("Mag", "Magnitude", names(extractedData))
names(extractedData)<-gsub("^t", "Time", names(extractedData))
names(extractedData)<-gsub("^f", "Frequency", names(extractedData))
names(extractedData)<-gsub("tBody", "TimeBody", names(extractedData))
names(extractedData)<-gsub("-mean()", "Mean", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-std()", "STD", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-freq()", "Frequency", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("angle", "Angle", names(extractedData))
names(extractedData)<-gsub("gravity", "Gravity", names(extractedData))

extractedData$Subject <- as.factor(extractedData$Subject)
extractedData <- data.table(extractedData)

tidyData <- aggregate(. ~Subject + Activity, extractedData, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
#write tidy_data text file
write.table(tidyData, file = "tidy_data.txt", row.names = FALSE)
