# Download and read the source data set
download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "source_data.zip")
unzip("source_data.zip")
setwd("./UCI HAR Dataset")

# Additional column names to add
  activityHeading <- "Activity"
  subjectIDHeading <- "SubjectID"
  
  # Read the activity labels
  activityLabels <- read.table("./activity_labels.txt")
  colnames(activityLabels) <- t(c(activityHeading, "Activity Label"))
  
  # Read the variable names from the following table
  features <- read.table("./features.txt")
  
  # Read the test measurements and add the variable names as column headings
  test_data <- read.table("./test/X_test.txt")
  colnames(test_data) <- t(features[2])
  
  # Read the test subjects from the following table and add the column heading
  test_subjects <- read.table("./test/subject_test.txt")
  colnames(test_subjects) <- c(subjectIDHeading)
  
  # Read the activitiy classes for the test data from the following table and add the column heading
  test_activities <- read.table("./test/y_test.txt")
  colnames(test_activities) <- c(activityHeading)
  
  # Combine test data with test activities and test subjects
  test_full = cbind(test_subjects, test_activities, test_data)
  
  # Read the train measurements and add the variable names as column headings
  train_data <- read.table("./train/X_train.txt")
  colnames(train_data) <- t(features[2])
  
  # Read the train subjects from the following table and add the column heading
  train_subjects <- read.table("./train/subject_train.txt")
  colnames(train_subjects) <- c(subjectIDHeading)
  
  # Read the activity classes for the train data from the following table and add the column heading
  train_activities <- read.table("./train/y_train.txt")
  colnames(train_activities) <- c(activityHeading)
  
  # Combine train data with train activities and train subjects
  train_full = cbind(train_subjects, train_activities, train_data)
  
  # Task 1: Merge the training and the test sets to create one data set.
  full = rbind(train_full, test_full)
  
  # Step 2: Extract only the measurements on the mean and standard deviation for each measurement.
  means_and_std_names <- grepl("(mean|std)\\(\\)", names(full))
  means_and_std_names[1] <- TRUE # we would like to reatain the first two columns
  means_and_std_names[2] <- TRUE # that contain the subject IDs and activities
  full_means_and_stds <- full[, means_and_std_names]

# Step 3: Use descriptive activity names to name the activities in the data set
# activities <- unlist(strsplit("WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING", ", "))
# full_means_and_stds$Activity <- factor(full_means_and_stds$Activity, labels = activities)
full_means_and_stds$Activity <- factor(full_means_and_stds$Activity, labels = activityLabels$ActivityLabel)
# Alternatively:
#full_means_and_stds = merge(full_means_and_stds, activityLabels, by = ActivityHeading)

# Step 4: Appropriately label the data set with descriptive variable names.
names(full_means_and_stds) <- gsub("Acc", "Acceleration", names(full_means_and_stds))
#names(full_means_and_stds) <- gsub("Mag", "Magnitude", names(full_means_and_stds))
# etc

# Step 5: From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
FinalTidyDataTable <- aggregate(. ~ SubjectID + Activity, data = full_means_and_stds, mean)
write.table(FinalTidyDataTable, file = "TidyDataSet.txt")