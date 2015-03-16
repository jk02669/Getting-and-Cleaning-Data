Code Book
====================
1. Call libraries suitable for large data.

2. Load like named data into featureNames and activiyLabels, respectively.

3. Read like named training data into subjectTrain, activityTrain, and featuresTrain, respectively.

4. Read like named test data into subjectTest, activityTest, and featuresTest, respectively.

5. Merge the training and the test sets to create one data set using rbind().

6. Name columns with values from featureNames.

7. Merge data into completeData using cbind(features, activity, subject).

8. Extracts only the measurements on the mean and standard deviation for each measurement.

9. Clean format of names. 

10. Write tidy data into a a text file 'tidy_data.txt'. 
