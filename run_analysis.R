library(plyr)
library(reshape2)

#Specifies the path of the files
original_path <- file.path("./project_data" , "UCI HAR Dataset")

#Reads training sets into R
ActivityTrain <- read.table(file.path(original_path, "train", "Y_train.txt"),header = FALSE)
FeaturesTrain <- read.table(file.path(original_path, "train", "X_train.txt"),header = FALSE)
SubjectTrain <- read.table(file.path(original_path, "train", "subject_train.txt"),header = FALSE)

#Reads test sets into R
ActivityTest  <- read.table(file.path(original_path, "test" , "Y_test.txt" ),header = FALSE)
FeaturesTest  <- read.table(file.path(original_path, "test" , "X_test.txt" ),header = FALSE)
SubjectTest  <- read.table(file.path(original_path, "test" , "subject_test.txt"),header = FALSE)

#Combines training and test sets of each related files
dataSubject <- rbind(SubjectTrain, SubjectTest)
dataActivity<- rbind(ActivityTrain, ActivityTest)
dataFeatures<- rbind(FeaturesTrain, FeaturesTest)

#Gives proper names to the columns of each dataframes
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataAllFeaturesNames <- read.table(file.path(original_path, "features.txt"),head=FALSE)
names(dataFeatures)<- dataAllFeaturesNames$V2

#Combines all the Subject and Activity data frames
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

#Selects the names including mean and std
requiredFeaturesNames<-dataAllFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataAllFeaturesNames$V2)]
selectedNames<-c(as.character(requiredFeaturesNames), "subject", "activity" )

#Subsets data according to selected names
Data<-subset(Data,select=selectedNames)


activityLabels <- read.table(file.path(original_path, "activity_labels.txt"),header = FALSE)

head(Data$activity,30)

#Converts abbreviations to its full names
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

#Displays the name of the resulting data frame
names(Data)

#Computer the mean of data according to each group of subject and activity
Data2<-aggregate(. ~subject + activity, Data, mean)
#Orders Data according to subject and activity respectively
Data2<-Data2[order(Data2$subject,Data2$activity),]

#Writes Data 2 to a file called "tidydata.txt"
write.table(Data2, file = "tidydata.txt",row.name=FALSE)







