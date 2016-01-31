## Getting and Cleaning Data Project

Aleksey G. Kovalyov

### Description
This code book describes the variables, the data, and transformations / work performed to clean up the data for the Johns Hopkins Univeristy *Getting and Cleaning Data* course *Coursera* project.

### Data Source
As directed in the assignment, the source data set can be obtained (in the format of a *zip* archive) from [this link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

### Source Data Set Description
As specified in the project description, please refer to [this page](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) for an explanation of data and variables used in the source data set.

### Assignment tasks
We need to do some preliminary work to prepare the data prior to performing the tasks in the assignment. In particular, we read the following data sets from the source data:

+  `activity_labels.txt` that contains activity labels;
+  `features.txt` that contains variable names, both for test and train measurements;
+  `X_test.txt` that contains test measurements data
+  `subject_test.txt` that contains subject IDs for observations in test measurements;
+  `y_test.txt` that contains activity classes for observations in test measurements;
+  `X_train.txt` that contains train measurements data
+  `subject_train.txt` that contains subject IDs for observations in train measurements;
+  `y_train.txt` that contains activity classes for observations in train measurements.

After reading in these data tables, appropriate column headings are added to make data manipulation easier.

In particular, measurements can now be combined with the corresponding test subject ID performing a specific activity, both for the train and test data, using `cbind()` command; these are stored in the `train_full` and `test_full` data frames, respectively.

With this preliminary work, accomplishing step

1. **Merge the training and the test sets to create one data set.**  
is easy: we just employ `rbind()` to combine the two aforementioned data frames (which now have identical column headings).
2. **Extract only the measurements on the mean and standard deviation for each measurement.**  
Examining variable names with `names(full)` we can see that variables containing the means have substring `mean` while those for the standard deviation have substring `std` (followed by a set of an opening and a closing parentheses) in their names. Thus, employing a regular expression to extract only such columns (and also retaining the first two columns containing subject IDs and activity classes that we added during preliminary processing), we can subset `full` to extract a data frame, `full_means_and_stds`, that contains only the required measurements.
3. **Use descriptive activity names to name the activities in the data set.**  
Activity names are stored in the `activityLabels` data frame; substituting activity classes in the `Activity` column of the `full_means_and_stds` with the coresponding activity label can be done either by converting this variable to a factored variable with appropriate levels (as shown) or by joining the two data frames together with the `Activity` column as the anchor (this variant is commented out in the script).
4. **Appropriately label the data set with descriptive variable names.**  
Well, it appears to me that the variables names are already pretty descriptive (especially considering their detailed explanations supplied in the `feature_info.txt` text file that has been provided with the source dataset). It is possible, however, to expand their names using string substutions (via `gsub()` routine) as shown, if so desired.
5. **From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.**  
To accomplish this task, we simply group the observations by subject and activity and compute the means for each group (via `agrregate()` function) and write out the resulting data frame.