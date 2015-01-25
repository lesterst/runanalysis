---
title: "README"
output: html_document
---

The run_analysis.R file is an R script while will transform the data in the UCI HAR Dataset into a tidy data set.

The run_analysis.R file should be in your working directory.
The entire folder of the UCI HAR Dataset should also be in your working directory.  The scripts will reach down into the data folder and grab the data.  The original data will not be changed.

This script requires the dplyr package.

This script first reads the 6 data tables plus the two supporting tables (activies and feature names) into R variables.
It then combines the 6 tables into a single large dataset by first column binding the subjects and activites onto the main data, and then row binding the test and training data sets together.

It then extracts just the data columns that contain mean or std in their titles (plus the subject and activity columns).
It renames the columns to more readable and R friendly titles.

It then groups the data by subject and activity. (30 subjects and 6 activites)
And takes the mean for each column of the 180 cominations of subject and activity
