# Getting and Cleaning Data - CourseProject

Even if the problem is hard, the program **run_analysis.R** is short and easy to understand. The program flow is linear and have the following steps:

### 1. Read the raw data

Reads the 8 txt-files that is needed with **read.table**

Note: "activity_labels.txt" is read with stringsAsFactors = F. That makes it easier to convert numbers to strings later in the program. 

### 2. Extracts only the measurements on the mean and standard deviation for each measurement.

A simple task with the R function **grepl**

### 3. Merges the training and the test sets to create one data set.

3.1 Merge the columns first with **cbind**

3.2 Merge the rows

### 4. Appropriately labels the data set with descriptive variable names.
I used "." to build R (and human) friendly names,

The hardes part. Probably there is a much simpler method than **gsub**, that I used.

### 5. Uses descriptive activity names to name the activities in the data set

I used a very primitive method. But it worked.

### 6. Independent tidy data set with the average of each variable for each activity and each subject.

I used **dplyr** for this part. With dplyr it was very easy to do the grouping.

And when I found **summarise_each** the averaging also became easy.

### 7. Create a txt-file with the  tidy data set

Only one row with R.
