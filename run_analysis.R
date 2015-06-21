# Read the raw data
X_train         <- read.table("X_train.txt")         # Train data with all 561 features
X_test          <- read.table("X_test.txt")
subject_train   <- read.table("subject_train.txt")   # A subject number is a person
subject_test    <- read.table("subject_test.txt")
y_train         <- read.table("y_train.txt")         # Activity as a number; number to activity, see below
y_test          <- read.table("y_test.txt")
features        <- read.table("features.txt")        # Describes the variables in X_train & X_test
# number to activity: WALKING...LAYING (Read as string.)
activity_labels <- read.table("activity_labels.txt", stringsAsFactors = F)

# Extracts only the measurements on the mean and standard deviation for each measurement.
variableNamesAll <- features[,2]
meanGrep <- grepl("mean()", variableNamesAll, fixed=T)
stdGrep  <- grepl("std()", variableNamesAll, fixed=T)

vaiablesToKeep    <- meanGrep | stdGrep
data_train_Step_1 <- X_train[vaiablesToKeep]
data_test_Step_1  <- X_test[vaiablesToKeep]

# Merges the training and the test sets to create one data set.
# Merge the columns first with cbind
data_train_Step_2 <- cbind(subject_train, y_train, data_train_Step_1)
data_test_Step_2  <- cbind(subject_test,  y_test,  data_test_Step_1)
# Merge the rows
data <- rbind(data_train_Step_2, data_test_Step_2)

# Appropriately labels the data set with descriptive variable names.
# Fix the variable names. Let's use "." as the new separator
variableNamesStep1 <- variableNamesAll[vaiablesToKeep]        # Filter out the names
variableNamesStep2 <- gsub("-", ".",      variableNamesStep1) # Replace all "-"  with "."
variableNamesStep3 <- gsub("\\(", ".",    variableNamesStep2) # Replace all "("  with "."
variableNamesStep4 <- gsub("\\)", "",     variableNamesStep3) # Replace all ")"  with nothing
variableNamesStep5 <- gsub("\\.\\.", ".", variableNamesStep4) # Replace all ".." with "."
variableNamesStep6 <- gsub("\\.$", "", variableNamesStep5) # Replace ending "." with "."

# Don't forget to add names for the first two columns
variableNames <- c("subject", "activity_as_number", variableNamesStep6)

names(data) <- variableNames # Add the names
#str(data)                    # Looks good...
#summary(data)

# Uses descriptive activity names to name the activities in the data set
# Time to change from numbers to more descreptive names. Only 6, so no for loop...
data$activity <- "Nothing"
data$activity[data$activity_as_number == 1] <- activity_labels[1,2]
data$activity[data$activity_as_number == 2] <- activity_labels[2,2]
data$activity[data$activity_as_number == 3] <- activity_labels[3,2]
data$activity[data$activity_as_number == 4] <- activity_labels[4,2]
data$activity[data$activity_as_number == 5] <- activity_labels[5,2]
data$activity[data$activity_as_number == 6] <- activity_labels[6,2]
data$activity <- as.factor(data$activity)
#summary(data$activity) # Looks good

# Independent tidy data set with the average of each variable for each activity and each subject.
# Time to do some dplyr for grouping and meaning
library(dplyr)
dat <- tbl_df(data)
dat <- select(dat, -activity_as_number) # Rwmove. We have the information in activity
by_subject_activity <- group_by(dat, subject, activity)

the_End <- summarise_each(by_subject_activity, funs(mean) )
#View(the_End) # Looks tidy
write.table(the_End, "tidy data set.txt", row.name=F)

# Viewing the data in the file is easy in TStudio
#tidy <- read.table("tidy data set.txt", header=T)
#View(tidy)
