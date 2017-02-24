library(reshape2) # library required for melt and dcast function

#following 3 lines read training data, activities associated with the training data and
#subjects to whom the data belongs
trainData <- read.table("./UCI HAR Dataset/train/X_train.txt")
trainLabel <- read.table("./UCI HAR Dataset/train/y_train.txt")
trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")

#following 3 lines read test data, labels associated with the test data and
#subjects to whom the data belongs
testData <- read.table("./UCI HAR Dataset/test/X_test.txt")
testLabel <- read.table("./UCI HAR Dataset/test/y_test.txt")
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#following line combines training data along with the activiteies and subject
trainFin <- cbind(trainData, trainLabel, trainSubject)

#following line combines test data along with the activiteies and subject
testFin <- cbind(testData, testLabel, testSubject)

#following line combines the training data and test data obtained in the previous
#two steps - part 1
data <- rbind(trainFin, testFin)

#reads the file containing the names of all the features
colNames <- readLines("./UCI HAR Dataset/features.txt")

#seprates the numbering in the begining of features file
colNames <- sub("^[0-9]+ ", "", colNames)

#following 2 lines adds two more elements to colNames vector i.e. column names
#for activity and subject column
colNames[length(colNames)+1] <- "activity"
colNames[length(colNames)+1] <- "subject"

#assigns the column names to the data frame - part 4
names(data) <- colNames

#col will contain the column names which contains mean or std (standard deviation)
#as part of their names
col <- grep("mean|std", names(data), value=TRUE)

#following lines add two more column names to the col vector - activity and 
#subject
col[length(col)+1] <- "activity"
col[length(col)+1] <- "subject"

#subData will contain only the columns with mean or std as their part and activity
#and subject column - part 2
subData <- subset(data, select=col)

#labels the activity column with appropriate labels using
#activity_labels.txt - part 3
subData$activity <- factor(subData$activity, levels=c(1, 2, 3, 4, 5, 6), labels=c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))

#Creates a new dataset subDataMelt using subData. In this new
#dataset observation will be made around activity and subject
#column and measurements will be taken around all the remaining columns
subDataMelt <- melt(subData, id=c("activity", "subject"), measure.vars=c(1:79))

#finData is the final dataset summarized for each activity
#and subject combination
finData <- dcast(subDataMelt, activity+subject~variable, mean)

#the final result is stoed in finData.txt file in the working directory
write.table(finData, "finData.txt", row.names = FALSE)